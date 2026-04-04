import 'dart:convert';
import 'package:http/http.dart' as http;

class PrayerService {
  static const String baseUrl = 'https://api.aladhan.com/v1/timingsByCity';

  Future<Map<String, dynamic>> getPrayerTimings({
    String city = 'Jakarta',
    String country = 'Indonesia',
    int method = 11, // Kemenag Indonesia
  }) async {
    final url = Uri.parse('$baseUrl?city=$city&country=$country&method=$method');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final timings = data['data']['timings'] as Map<String, dynamic>;
        
        // Map keys to match our app labels
        final normalizedTimings = {
          'Fajr': timings['Fajr'],
          'Dzuhur': timings['Dhuhr'],
          'Ashar': timings['Asr'],
          'Maghrib': timings['Maghrib'],
          'Isha': timings['Isha'],
        };
        
        return {
          'timings': normalizedTimings,
          'date': data['data']['date'],
        };
      } else {
        throw Exception('Gagal mengambil jadwal sholat: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Kesalahan jaringan: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getMonthlyTimings({
    String city = 'Jakarta',
    String country = 'Indonesia',
    int method = 11,
    int? year,
    int? month,
  }) async {
    final now = DateTime.now();
    year ??= now.year;
    month ??= now.month;

    final url = Uri.parse('https://api.aladhan.com/v1/calendarByCity/$year/$month?city=$city&country=$country&method=$method');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> days = data['data'];
        
        return days.map((day) {
          final timings = day['timings'] as Map<String, dynamic>;
          final dateObj = day['date'] as Map<String, dynamic>;
          
          // API returns HH:mm (Timezone) or just HH:mm
          return {
            'date': dateObj['gregorian']['date'], // dd-mm-yyyy
            'timings': {
              'Fajr': timings['Fajr'].split(' ')[0],
              'Dzuhur': timings['Dhuhr'].split(' ')[0],
              'Ashar': timings['Asr'].split(' ')[0],
              'Maghrib': timings['Maghrib'].split(' ')[0],
              'Isha': timings['Isha'].split(' ')[0],
            },
          };
        }).toList();
      } else {
        throw Exception('Gagal mengambil kalender sholat: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Kesalahan jaringan: $e');
    }
  }
}
