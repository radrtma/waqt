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
}
