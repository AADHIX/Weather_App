import '../../../core/constants/asset_constants.dart';

class WeatherModel {
  final String cityName;
  final String country;
  final double temperature;
  final double feelsLike;
  final double tempMin;
  final double tempMax;
  final int humidity;
  final double windSpeed;
  final String description;
  final String conditionMain;
  final String iconCode;
  final double pressure;
  final double visibility;
  final int clouds;
  final int sunrise;
  final int sunset;
  final double latitude;
  final double longitude;
  final DateTime timestamp;

  const WeatherModel({
    required this.cityName,
    required this.country,
    required this.temperature,
    required this.feelsLike,
    required this.tempMin,
    required this.tempMax,
    required this.humidity,
    required this.windSpeed,
    required this.description,
    required this.conditionMain,
    required this.iconCode,
    required this.pressure,
    required this.visibility,
    required this.clouds,
    required this.sunrise,
    required this.sunset,
    required this.latitude,
    required this.longitude,
    required this.timestamp,
  });

  // Computed Properties
  String get temperatureDisplay => '${temperature.round()}°';
  String get feelsLikeDisplay => '${feelsLike.round()}°';
  String get tempMinDisplay => '${tempMin.round()}°';
  String get tempMaxDisplay => '${tempMax.round()}°';
  String get windSpeedDisplay => '${windSpeed.toStringAsFixed(1)} m/s';
  String get pressureDisplay => '${pressure.round()} hPa';
  String get humidityDisplay => '$humidity%';
  String get visibilityDisplay => '${(visibility / 1000).toStringAsFixed(1)} km';
  String get cloudsDisplay => '$clouds%';
  String get weatherIconUrl => AssetConstants.getWeatherIconUrl(iconCode);

  String get conditionEmoji {
    switch (iconCode) {
      case '01d':
        return '☀️';
      case '01n':
        return '🌙';
      case '02d':
      case '02n':
        return '⛅';
      case '03d':
      case '03n':
      case '04d':
      case '04n':
        return '☁️';
      case '09d':
      case '09n':
        return '🌧️';
      case '10d':
      case '10n':
        return '🌦️';
      case '11d':
      case '11n':
        return '⛈️';
      case '13d':
      case '13n':
        return '❄️';
      case '50d':
      case '50n':
        return '🌫️';
      default:
        return '🌤️';
    }
  }

  bool get isDayTime {
    final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    if (sunrise > 0 && sunset > 0) {
      return now >= sunrise && now <= sunset;
    }
    return !iconCode.endsWith('n');
  }

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    final main = json['main'] as Map<String, dynamic>? ?? {};
    final weatherList = json['weather'] as List<dynamic>? ?? [];
    final firstWeather = weatherList.isNotEmpty
        ? weatherList[0] as Map<String, dynamic>
        : <String, dynamic>{};
    final wind = json['wind'] as Map<String, dynamic>? ?? {};
    final sys = json['sys'] as Map<String, dynamic>? ?? {};
    final cloudsMap = json['clouds'] as Map<String, dynamic>? ?? {};
    final coord = json['coord'] as Map<String, dynamic>? ?? {};

    return WeatherModel(
      cityName: json['name'] as String? ?? 'Unknown City',
      country: sys['country'] as String? ?? '',
      temperature: (main['temp'] as num?)?.toDouble() ?? 0.0,
      feelsLike: (main['feels_like'] as num?)?.toDouble() ?? 0.0,
      tempMin: (main['temp_min'] as num?)?.toDouble() ?? 0.0,
      tempMax: (main['temp_max'] as num?)?.toDouble() ?? 0.0,
      humidity: (main['humidity'] as num?)?.toInt() ?? 0,
      pressure: (main['pressure'] as num?)?.toDouble() ?? 1013.0,
      windSpeed: (wind['speed'] as num?)?.toDouble() ?? 0.0,
      description: firstWeather['description'] as String? ?? 'Clear sky',
      conditionMain: firstWeather['main'] as String? ?? 'Clear',
      iconCode: firstWeather['icon'] as String? ?? '01d',
      visibility: (json['visibility'] as num?)?.toDouble() ?? 10000.0,
      clouds: (cloudsMap['all'] as num?)?.toInt() ?? 0,
      sunrise: (sys['sunrise'] as num?)?.toInt() ?? 0,
      sunset: (sys['sunset'] as num?)?.toInt() ?? 0,
      latitude: (coord['lat'] as num?)?.toDouble() ?? 0.0,
      longitude: (coord['lon'] as num?)?.toDouble() ?? 0.0,
      timestamp: json['dt'] != null
          ? DateTime.fromMillisecondsSinceEpoch((json['dt'] as int) * 1000)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': cityName,
      'sys': {
        'country': country,
        'sunrise': sunrise,
        'sunset': sunset,
      },
      'main': {
        'temp': temperature,
        'feels_like': feelsLike,
        'temp_min': tempMin,
        'temp_max': tempMax,
        'humidity': humidity,
        'pressure': pressure,
      },
      'weather': [
        {
          'main': conditionMain,
          'description': description,
          'icon': iconCode,
        }
      ],
      'wind': {'speed': windSpeed},
      'visibility': visibility,
      'clouds': {'all': clouds},
      'coord': {'lat': latitude, 'lon': longitude},
      'dt': timestamp.millisecondsSinceEpoch ~/ 1000,
    };
  }

  // Fallback demo data for immediate testing
  factory WeatherModel.demo() {
    return WeatherModel(
      cityName: 'San Francisco',
      country: 'US',
      temperature: 19.5,
      feelsLike: 18.8,
      tempMin: 14.0,
      tempMax: 22.0,
      humidity: 68,
      windSpeed: 4.2,
      description: 'Partly cloudy with gentle breeze',
      conditionMain: 'Clouds',
      iconCode: '02d',
      pressure: 1014.0,
      visibility: 10000.0,
      clouds: 35,
      sunrise: (DateTime.now().millisecondsSinceEpoch ~/ 1000) - 14400,
      sunset: (DateTime.now().millisecondsSinceEpoch ~/ 1000) + 21600,
      latitude: 37.7749,
      longitude: -122.4194,
      timestamp: DateTime.now(),
    );
  }
}
