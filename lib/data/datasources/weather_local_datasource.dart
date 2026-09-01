import '../../core/constants/app_constants.dart';
import '../../core/services/storage_service.dart';
import '../../modules/weather/models/forecast_model.dart';
import '../../modules/weather/models/weather_model.dart';

abstract class WeatherLocalDataSource {
  Future<void> cacheCurrentWeather(WeatherModel weather);
  WeatherModel? getCachedCurrentWeather();
  Future<void> cacheForecast(ForecastModel forecast);
  ForecastModel? getCachedForecast();
  Future<void> saveLastCity(String city);
  String? getLastCity();
  List<String> getSearchHistory();
  Future<void> addSearchHistory(String city);
  Future<void> removeSearchHistory(String city);
  Future<void> clearSearchHistory();
}

class WeatherLocalDataSourceImpl implements WeatherLocalDataSource {
  final StorageService _storageService;

  WeatherLocalDataSourceImpl(this._storageService);

  @override
  Future<void> cacheCurrentWeather(WeatherModel weather) async {
    await _storageService.setObject(AppConstants.keyCachedWeather, weather.toJson());
  }

  @override
  WeatherModel? getCachedCurrentWeather() {
    final json = _storageService.getObject(AppConstants.keyCachedWeather);
    if (json == null) return null;
    try {
      return WeatherModel.fromJson(json);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> cacheForecast(ForecastModel forecast) async {
    await _storageService.setObject(AppConstants.keyCachedForecast, forecast.toJson());
  }

  @override
  ForecastModel? getCachedForecast() {
    final json = _storageService.getObject(AppConstants.keyCachedForecast);
    if (json == null) return null;
    try {
      return ForecastModel.fromJson(json);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> saveLastCity(String city) async {
    await _storageService.setString(AppConstants.keyLastSearchedCity, city);
  }

  @override
  String? getLastCity() {
    return _storageService.getString(AppConstants.keyLastSearchedCity);
  }

  @override
  List<String> getSearchHistory() {
    return _storageService.getSearchHistory();
  }

  @override
  Future<void> addSearchHistory(String city) {
    return _storageService.addSearchHistory(city);
  }

  @override
  Future<void> removeSearchHistory(String city) {
    return _storageService.removeSearchHistoryItem(city);
  }

  @override
  Future<void> clearSearchHistory() {
    return _storageService.clearSearchHistory();
  }
}
