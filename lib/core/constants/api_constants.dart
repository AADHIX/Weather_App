import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConstants {
  ApiConstants._();

  static String get baseUrl =>
      dotenv.env['WEATHER_API_URL'] ?? 'https://api.openweathermap.org/data/2.5';

  static String get apiKey =>
      dotenv.env['WEATHER_API_KEY'] ?? 'b6907d289e10d714a6e88b30761fae22';

  static String get iconBaseUrl =>
      dotenv.env['WEATHER_ICON_URL'] ?? 'https://openweathermap.org/img/wn';

  // Endpoints
  static const String currentWeather = '/weather';
  static const String forecast = '/forecast';

  // Query parameters
  static const String unitsMetric = 'metric';
  static const String defaultCity = 'London';

  // Request timeouts
  static const Duration connectTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 15);
}
