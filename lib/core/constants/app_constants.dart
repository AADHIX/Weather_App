class AppConstants {
  AppConstants._();

  static const String appName = 'WeatherWise';
  static const String appTagline = 'Your Real-Time Weather Companion';

  // Storage Keys
  static const String keyUserSession = 'user_session';
  static const String keyRegisteredUsers = 'registered_users';
  static const String keyRememberMe = 'remember_me';
  static const String keyLastSearchedCity = 'last_searched_city';
  static const String keySearchHistory = 'search_history';
  static const String keyCachedWeather = 'cached_weather';
  static const String keyCachedForecast = 'cached_forecast';
  static const String keyThemeMode = 'app_theme_mode';
  static const String keyCustomApiKey = 'custom_api_key';

  // Animation Durations
  static const Duration splashDuration = Duration(milliseconds: 1500);
  static const Duration animationDuration = Duration(milliseconds: 300);
  static const Duration snackbarDuration = Duration(seconds: 3);

  // Max search history items
  static const int maxSearchHistory = 8;
}
