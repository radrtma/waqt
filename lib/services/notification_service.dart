import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_timezone/flutter_timezone.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    tz_data.initializeTimeZones();
    try {
      final currentTimeZoneInfo = await FlutterTimezone.getLocalTimezone();
      final String currentTimeZone = currentTimeZoneInfo.identifier;
      tz.setLocalLocation(tz.getLocation(currentTimeZone));
      debugPrint('NotificationService: Local timezone set to $currentTimeZone');
    } catch (e) {
      debugPrint(
        'NotificationService: Error setting local timezone: $e. Falling back to Asia/Jakarta',
      );
      tz.setLocalLocation(tz.getLocation('Asia/Jakarta'));
    }

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

    await _notificationsPlugin.initialize(
      settings: initializationSettings,
      onDidReceiveNotificationResponse: (details) {
        // Handle notification tap
      },
    );

    if (!kIsWeb) {
      if (defaultTargetPlatform == TargetPlatform.android) {
        final androidPlugin = _notificationsPlugin
            .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin
            >();

        await androidPlugin?.requestNotificationsPermission();
        await androidPlugin?.requestExactAlarmsPermission();
      }
    }
  }

  Future<void> showNotification({
    int id = 0,
    required String title,
    required String body,
  }) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'waqt_notifications',
          'WAQT Notifications',
          channelDescription: 'Main app notifications',
          importance: Importance.max,
          priority: Priority.high,
        );

    const NotificationDetails platformDetails = NotificationDetails(
      android: androidDetails,
      iOS: DarwinNotificationDetails(),
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

    await _notificationsPlugin.cancelAll();

    final nowTz = tz.TZDateTime.now(tz.local);
    final prayerNames = ['Fajr', 'Dzuhur', 'Ashar', 'Maghrib', 'Isha'];

    for (int i = 0; i < prayerNames.length; i++) {
      final name = prayerNames[i];
      final timeStr = timings[name];
      if (timeStr == null) continue;

      final parts = timeStr.split(':');
      final prayerTime = tz.TZDateTime(
        tz.local,
        nowTz.year,
        nowTz.month,
        nowTz.day,
        int.parse(parts[0]),
        int.parse(parts[1]),
      );

      if (prayerTime.isAfter(nowTz)) {
        await _scheduleNotification(
          id: i,
          title: 'Waktu $name Tiba!',
          body: 'Mari tunaikan ibadah sholat $name sekarang.',
          scheduledDate: prayerTime,
        );
      }

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

          final warningTime = nextPrayerTime.subtract(
            const Duration(minutes: 15),
          );
          if (warningTime.isAfter(nowTz)) {
            await _scheduleNotification(
              id: i + 100,
              title: 'Waktu $name Segera Berakhir',
              body: 'Tinggal 15 menit lagi sebelum waktu $nextName tiba.',
              scheduledDate: warningTime,
            );
          }
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
    try {
      await _notificationsPlugin.zonedSchedule(
        id: id,
        title: title,
        body: body,
        scheduledDate: tz.TZDateTime.from(scheduledDate, tz.local),
        notificationDetails: const NotificationDetails(
          android: AndroidNotificationDetails(
            'waqt_prayer_times',
            'Waktu Sholat',
            channelDescription: 'Jadwal sholat harian',
            importance: Importance.max,
            priority: Priority.high,
          ),
          iOS: DarwinNotificationDetails(),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      );
    } catch (e) {
      // Fallback to inexact if exact is not permitted
      await _notificationsPlugin.zonedSchedule(
        id: id,
        title: title,
        body: body,
        scheduledDate: tz.TZDateTime.from(scheduledDate, tz.local),
        notificationDetails: const NotificationDetails(
          android: AndroidNotificationDetails(
            'waqt_prayer_times',
            'Waktu Sholat',
            channelDescription: 'Jadwal sholat harian',
            importance: Importance.max,
            priority: Priority.high,
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
