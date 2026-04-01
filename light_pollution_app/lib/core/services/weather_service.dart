import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/weather_data.dart';

class WeatherService {
  static const _baseUrl = 'https://api.open-meteo.com/v1/forecast';

  Future<WeatherData> getWeather(double lat, double lng) async {
    final uri = Uri.parse(
      '$_baseUrl?latitude=$lat&longitude=$lng'
      '&current=temperature_2m,relative_humidity_2m,cloud_cover,wind_speed_10m,weather_code'
      '&hourly=cloud_cover'
      '&forecast_days=1'
      '&timezone=auto',
    );

    final response = await http.get(uri);
    if (response.statusCode != 200) {
      throw Exception('Weather API error: ${response.statusCode}');
    }

    final data = json.decode(response.body);
    if (data is! Map<String, dynamic>) {
      throw Exception('Weather API returned unexpected data format');
    }

    final current = data['current'] as Map<String, dynamic>?;
    final hourly = data['hourly'] as Map<String, dynamic>?;

    if (current == null || hourly == null) {
      throw Exception('Weather API response missing current or hourly data');
    }

    return WeatherData(
      temperature: (current['temperature_2m'] as num?)?.toDouble() ?? 0.0,
      humidity: (current['relative_humidity_2m'] as num?)?.toInt() ?? 0,
      cloudCover: (current['cloud_cover'] as num?)?.toInt() ?? 0,
      windSpeed: (current['wind_speed_10m'] as num?)?.toDouble() ?? 0.0,
      weatherCode: (current['weather_code'] as num?)?.toInt() ?? 0,
      hourlyCloudCover: (hourly['cloud_cover'] as List?)
              ?.map((e) => (e as num?)?.toInt() ?? 0)
              .toList() ??
          [],
      hourlyTimes: (hourly['time'] as List?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
    );
  }
}
