import 'package:flutter_test/flutter_test.dart';
import 'package:weatherapps/modules/weather/models/forecast_model.dart';
import 'package:weatherapps/modules/weather/models/weather_model.dart';

void main() {
  group('Weather & Forecast Model Tests', () {
    test('WeatherModel fromJson parses OpenWeatherMap schema correctly', () {
      final json = {
        'name': 'Tokyo',
        'sys': {'country': 'JP', 'sunrise': 1600000000, 'sunset': 1600045000},
        'main': {
          'temp': 25.4,
          'feels_like': 26.1,
          'temp_min': 23.0,
          'temp_max': 27.5,
          'humidity': 65,
          'pressure': 1012.0,
        },
        'weather': [
          {'main': 'Clear', 'description': 'clear sky', 'icon': '01d'}
        ],
        'wind': {'speed': 3.6},
        'visibility': 10000,
        'clouds': {'all': 10},
        'coord': {'lat': 35.6895, 'lon': 139.6917},
        'dt': 1600020000,
      };

      final weather = WeatherModel.fromJson(json);

      expect(weather.cityName, 'Tokyo');
      expect(weather.country, 'JP');
      expect(weather.temperature, 25.4);
      expect(weather.temperatureDisplay, '25°');
      expect(weather.feelsLikeDisplay, '26°');
      expect(weather.humidityDisplay, '65%');
      expect(weather.windSpeedDisplay, '3.6 m/s');
      expect(weather.conditionEmoji, '☀️');
      expect(weather.conditionMain, 'Clear');
      expect(weather.visibilityDisplay, '10.0 km');
    });

    test('ForecastModel groupings and daily aggregations work properly', () {
      final forecast = ForecastModel.demo();
      expect(forecast.cityName, 'San Francisco');
      expect(forecast.items.isNotEmpty, true);
      expect(forecast.next24Hours.length, 8);
      expect(forecast.fiveDayForecast.length, 5);
      expect(forecast.fiveDayForecast.first.minTempDisplay.contains('°'), true);
    });
  });
}
