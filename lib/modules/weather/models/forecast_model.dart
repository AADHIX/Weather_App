import '../../../core/constants/asset_constants.dart';

class ForecastItemModel {
  final DateTime dateTime;
  final double temperature;
  final double tempMin;
  final double tempMax;
  final double feelsLike;
  final int humidity;
  final double windSpeed;
  final String conditionMain;
  final String description;
  final String iconCode;
  final int popProbability; // Probability of precipitation %

  ForecastItemModel({
    required this.dateTime,
    required this.temperature,
    required this.tempMin,
    required this.tempMax,
    required this.feelsLike,
    required this.humidity,
    required this.windSpeed,
    required this.conditionMain,
    required this.description,
    required this.iconCode,
    this.popProbability = 0,
  });

  String get temperatureDisplay => '${temperature.round()}°';
  String get tempMinDisplay => '${tempMin.round()}°';
  String get tempMaxDisplay => '${tempMax.round()}°';
  String get iconUrl => AssetConstants.getWeatherIconUrl(iconCode);

  factory ForecastItemModel.fromJson(Map<String, dynamic> json) {
    final main = json['main'] as Map<String, dynamic>? ?? {};
    final weatherList = json['weather'] as List<dynamic>? ?? [];
    final firstWeather = weatherList.isNotEmpty
        ? weatherList[0] as Map<String, dynamic>
        : <String, dynamic>{};
    final wind = json['wind'] as Map<String, dynamic>? ?? {};

    return ForecastItemModel(
      dateTime: json['dt'] != null
          ? DateTime.fromMillisecondsSinceEpoch((json['dt'] as int) * 1000)
          : DateTime.now(),
      temperature: (main['temp'] as num?)?.toDouble() ?? 0.0,
      tempMin: (main['temp_min'] as num?)?.toDouble() ?? 0.0,
      tempMax: (main['temp_max'] as num?)?.toDouble() ?? 0.0,
      feelsLike: (main['feels_like'] as num?)?.toDouble() ?? 0.0,
      humidity: (main['humidity'] as num?)?.toInt() ?? 0,
      windSpeed: (wind['speed'] as num?)?.toDouble() ?? 0.0,
      conditionMain: firstWeather['main'] as String? ?? 'Clear',
      description: firstWeather['description'] as String? ?? '',
      iconCode: firstWeather['icon'] as String? ?? '01d',
      popProbability: (((json['pop'] as num?)?.toDouble() ?? 0.0) * 100).round(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'dt': dateTime.millisecondsSinceEpoch ~/ 1000,
      'main': {
        'temp': temperature,
        'temp_min': tempMin,
        'temp_max': tempMax,
        'feels_like': feelsLike,
        'humidity': humidity,
      },
      'weather': [
        {
          'main': conditionMain,
          'description': description,
          'icon': iconCode,
        }
      ],
      'wind': {'speed': windSpeed},
      'pop': popProbability / 100.0,
    };
  }
}

class DailyForecastSummary {
  final DateTime date;
  final double minTemp;
  final double maxTemp;
  final String conditionMain;
  final String description;
  final String iconCode;
  final int humidity;

  DailyForecastSummary({
    required this.date,
    required this.minTemp,
    required this.maxTemp,
    required this.conditionMain,
    required this.description,
    required this.iconCode,
    required this.humidity,
  });

  String get minTempDisplay => '${minTemp.round()}°';
  String get maxTempDisplay => '${maxTemp.round()}°';
  String get iconUrl => AssetConstants.getWeatherIconUrl(iconCode);
}

class ForecastModel {
  final String cityName;
  final String country;
  final List<ForecastItemModel> items;

  ForecastModel({
    required this.cityName,
    required this.country,
    required this.items,
  });

  // Next 24 hours (hourly / 3-hour steps)
  List<ForecastItemModel> get next24Hours {
    return items.take(8).toList();
  }

  // 5-Day daily grouped summary
  List<DailyForecastSummary> get fiveDayForecast {
    final Map<String, List<ForecastItemModel>> dayMap = {};

    for (final item in items) {
      final key = '${item.dateTime.year}-${item.dateTime.month}-${item.dateTime.day}';
      dayMap.putIfAbsent(key, () => []).add(item);
    }

    final List<DailyForecastSummary> summaries = [];
    dayMap.forEach((key, dayItems) {
      double min = dayItems.first.tempMin;
      double max = dayItems.first.tempMax;
      for (final it in dayItems) {
        if (it.tempMin < min) min = it.tempMin;
        if (it.tempMax > max) max = it.tempMax;
      }
      // Pick midday item for icon/condition if available
      final midDayItem = dayItems.firstWhere(
        (it) => it.dateTime.hour >= 11 && it.dateTime.hour <= 15,
        orElse: () => dayItems.first,
      );

      summaries.add(DailyForecastSummary(
        date: dayItems.first.dateTime,
        minTemp: min,
        maxTemp: max,
        conditionMain: midDayItem.conditionMain,
        description: midDayItem.description,
        iconCode: midDayItem.iconCode,
        humidity: midDayItem.humidity,
      ));
    });

    return summaries.take(5).toList();
  }

  factory ForecastModel.fromJson(Map<String, dynamic> json) {
    final cityMap = json['city'] as Map<String, dynamic>? ?? {};
    final list = json['list'] as List<dynamic>? ?? [];

    return ForecastModel(
      cityName: cityMap['name'] as String? ?? '',
      country: cityMap['country'] as String? ?? '',
      items: list
          .map((item) => ForecastItemModel.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'city': {
        'name': cityName,
        'country': country,
      },
      'list': items.map((e) => e.toJson()).toList(),
    };
  }

  // Fallback demo forecast
  factory ForecastModel.demo() {
    final now = DateTime.now();
    final List<ForecastItemModel> demoItems = [];

    for (int i = 0; i < 40; i++) {
      final itemDate = now.add(Duration(hours: i * 3));
      demoItems.add(
        ForecastItemModel(
          dateTime: itemDate,
          temperature: 18.0 + (i % 6) * 1.5,
          tempMin: 14.0 + (i % 5),
          tempMax: 22.0 + (i % 4),
          feelsLike: 17.5 + (i % 5),
          humidity: 60 + (i % 25),
          windSpeed: 3.5 + (i % 4),
          conditionMain: i % 3 == 0 ? 'Clear' : (i % 3 == 1 ? 'Clouds' : 'Rain'),
          description: i % 3 == 0 ? 'Clear sky' : (i % 3 == 1 ? 'Scattered clouds' : 'Light rain'),
          iconCode: i % 3 == 0 ? '01d' : (i % 3 == 1 ? '03d' : '10d'),
          popProbability: (i % 3 == 2) ? 60 : 10,
        ),
      );
    }

    return ForecastModel(
      cityName: 'San Francisco',
      country: 'US',
      items: demoItems,
    );
  }
}
