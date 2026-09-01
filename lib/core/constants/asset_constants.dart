class AssetConstants {
  AssetConstants._();

  // OpenWeatherMap icon resolver helper
  static String getWeatherIconUrl(String iconCode, {bool highRes = true}) {
    final size = highRes ? '@4x.png' : '@2x.png';
    return 'https://openweathermap.org/img/wn/$iconCode$size';
  }

  // Popular default cities for quick search
  static const List<Map<String, String>> popularCities = [
    {'city': 'London', 'country': 'United Kingdom'},
    {'city': 'New York', 'country': 'United States'},
    {'city': 'Tokyo', 'country': 'Japan'},
    {'city': 'Paris', 'country': 'France'},
    {'city': 'Dubai', 'country': 'United Arab Emirates'},
    {'city': 'Sydney', 'country': 'Australia'},
    {'city': 'Singapore', 'country': 'Singapore'},
    {'city': 'San Francisco', 'country': 'United States'},
  ];
}
