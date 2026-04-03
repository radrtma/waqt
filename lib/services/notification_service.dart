import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;
import 'package:permission_handler/permission_handler.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  bool _isInitialized = false;
  Future<void>? _initFuture;

  Future<void> init() async {
    if (_isInitialized) return;
    if (_initFuture != null) return _initFuture!;

    _initFuture = _performInit();
    return _initFuture!;
  }

  Future<void> _performInit() async {
    debugPrint('NotificationService: Initializing...');
    tz_data.initializeTimeZones();
    // Default to Asia/Jakarta for manual testing
    tz.setLocalLocation(tz.getLocation('Asia/Jakarta'));

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true,
        );

    const InitializationSettings initializationSettings =
        InitializationSettings(
          android: initializationSettingsAndroid,
          iOS: initializationSettingsIOS,
        );

    final bool? initialized = await _notificationsPlugin.initialize(
      settings: initializationSettings,
      onDidReceiveNotificationResponse: (details) {
        debugPrint(
          'NotificationService: Notification tapped: ${details.payload}',
        );
      },
    );
    debugPrint('NotificationService: Plugin initialized: $initialized');

    if (defaultTargetPlatform == TargetPlatform.android) {
      final androidPlugin = _notificationsPlugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >();

      await androidPlugin?.createNotificationChannel(
        const AndroidNotificationChannel(
          'waqt_general_v2',
          'WAQT Notifications',
          description: 'Main app notifications',
          importance: Importance.max,
          playSound: true,
          enableVibration: true,
        ),
      );

      await androidPlugin?.createNotificationChannel(
        const AndroidNotificationChannel(
          'waqt_prayer_v3',
          'Jadwal Sholat',
          description: 'Notifikasi jadwal sholat harian',
          importance: Importance.max,
          playSound: true,
          enableVibration: true,
        ),
      );
    }

    _isInitialized = true;
    _initFuture = null;
    await requestPermissions();
  }


  Future<void> requestPermissions() async {
    if (kIsWeb) return;
    if (defaultTargetPlatform == TargetPlatform.android) {
      await Permission.notification.request();
      if (await Permission.scheduleExactAlarm.isDenied) {
        await Permission.scheduleExactAlarm.request();
      }
      if (!(await Permission.ignoreBatteryOptimizations.isGranted)) {
        await Permission.ignoreBatteryOptimizations.request();
      }
    }
  }

  Future<void> showNotification({
    int id = 0,
    required String title,
    required String body,
  }) async {
    await init();
    const NotificationDetails platformDetails = NotificationDetails(
      android: AndroidNotificationDetails(
        'waqt_general_v2',
        'WAQT Notifications',
        importance: Importance.max,
        priority: Priority.max,
        category: AndroidNotificationCategory.alarm,
        ticker: 'Waqt General',
        playSound: true,
        enableVibration: true,
      ),
      iOS: DarwinNotificationDetails(presentAlert: true, presentSound: true),
    );

    await _notificationsPlugin.show(
      id: id,
      title: title,
      body: body,
      notificationDetails: platformDetails,
    );
  }

  Future<void> schedulePrayerNotifications(Map<String, dynamic> timings) async {
    if (kIsWeb) return;
    await init();

    // Hapus semua jadwal lama sebelum menjadwalkan ulang
    await _notificationsPlugin.cancelAll();

    final nowTz = tz.TZDateTime.now(tz.local);
    final prayerNames = ['Fajr', 'Dzuhur', 'Ashar', 'Maghrib', 'Isha'];

    debugPrint('NotificationService: Scheduling daily prayers. Now: $nowTz');

    for (int i = 0; i < prayerNames.length; i++) {
      final name = prayerNames[i];
      final timeStr = timings[name];
      if (timeStr == null) continue;

      final parts = timeStr.split(':');
      var prayerTime = tz.TZDateTime(
        tz.local,
        nowTz.year,
        nowTz.month,
        nowTz.day,
        int.parse(parts[0]),
        int.parse(parts[1]),
      );

      // Jika waktu sudah lewat hari ini, jadwalkan untuk besok
      if (prayerTime.isBefore(nowTz)) {
        prayerTime = prayerTime.add(const Duration(days: 1));
      }

      debugPrint('NotificationService: [SCHEDULED] $name at $prayerTime');
      await _scheduleNotification(
        id: i,
        title: 'Waktu $name Tiba!',
        body: 'Mari tunaikan ibadah sholat $name sekarang.',
        scheduledDate: prayerTime,
      );

      // Logika Peringatan (15 menit sebelum sholat berikutnya habis)
      if (i < prayerNames.length - 1) {
        final nextName = prayerNames[i + 1];
        final nextTimeStr = timings[nextName];
        if (nextTimeStr != null) {
          final nextParts = nextTimeStr.split(':');
          final nextPrayerTime = tz.TZDateTime(
            tz.local,
            nowTz.year,
            nowTz.month,
            nowTz.day,
            int.parse(nextParts[0]),
            int.parse(nextParts[1]),
          );

          var warningTime = nextPrayerTime.subtract(
            const Duration(minutes: 15),
          );

          if (warningTime.isBefore(nowTz)) {
            warningTime = warningTime.add(const Duration(days: 1));
          }

          debugPrint(
            'NotificationService: [SCHEDULED_WARNING] for $name at $warningTime',
          );
          await _scheduleNotification(
            id: i + 100,
            title: 'Waktu ${prayerNames[i]} Segera Berakhir',
            body: 'Tinggal 15 menit lagi sebelum waktu $nextName tiba.',
            scheduledDate: warningTime,
          );
        }
      }
    }
  }

  Future<void> _scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
  }) async {
    final tzDate = tz.TZDateTime.from(scheduledDate, tz.local);

    try {
      await _notificationsPlugin.zonedSchedule(
        id: id,
        title: title,
        body: body,
        scheduledDate: tzDate,
        notificationDetails: const NotificationDetails(
          android: AndroidNotificationDetails(
            'waqt_prayer_v3',
            'Jadwal Sholat',
            importance: Importance.max,
            priority: Priority.high,
            ticker: 'Waqt Prayer',
            playSound: true,
            enableVibration: true,
          ),
          iOS: DarwinNotificationDetails(
            presentAlert: true,
            presentSound: true,
          ),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      );
    } catch (e) {
      debugPrint('NotificationService: Critical failure in zonedSchedule: $e');
      // Fallback ke inexact jika exact dilarang sistem
      await _notificationsPlugin.zonedSchedule(
        id: id,
        title: title,
        body: body,
        scheduledDate: tzDate,
        notificationDetails: const NotificationDetails(
          android: AndroidNotificationDetails(
            'waqt_prayer_v3',
            'Jadwal Sholat',
            importance: Importance.max,
            priority: Priority.high,
            ticker: 'Waqt Fallback',
            playSound: true,
            enableVibration: true,
          ),
          iOS: DarwinNotificationDetails(),
        ),
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      );
    }
  }

  Future<void> showQadaAlert(String prayerName) async {
    await showNotification(
      id: 999,
      title: 'Sholat Terlewat',
      body:
          'Waktu $prayerName telah habis. Sholat ini telah masuk ke daftar Qada.',
    );
  }

  Future<void> showStreakResetAlert() async {
    await showNotification(
      id: 888,
      title: 'Streak Pecah!',
      body:
          'Streak ketaatan Anda harus terhenti. Yuk, mulai lagi dari awal besok!',
    );
  }
}
