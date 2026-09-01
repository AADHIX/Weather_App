import '../../core/utils/app_logger.dart';
import '../../modules/weather/models/forecast_model.dart';
import '../../modules/weather/models/weather_model.dart';
import '../datasources/weather_local_datasource.dart';
import '../datasources/weather_remote_datasource.dart';

abstract class WeatherRepository {
  Future<WeatherModel> getCurrentWeatherByCity(String cityName);
  Future<WeatherModel> getCurrentWeatherByCoordinates(double lat, double lon);
  Future<ForecastModel> getForecastByCity(String cityName);
  Future<ForecastModel> getForecastByCoordinates(double lat, double lon);
  WeatherModel? getCachedWeather();
  ForecastModel? getCachedForecast();
  String? getLastSearchedCity();
  List<String> getSearchHistory();
  Future<void> addSearchHistory(String city);
  Future<void> removeSearchHistory(String city);
  Future<void> clearSearchHistory();
}

class WeatherRepositoryImpl implements WeatherRepository {
  final WeatherRemoteDataSource _remoteDataSource;
  final WeatherLocalDataSource _localDataSource;

  WeatherRepositoryImpl(this._remoteDataSource, this._localDataSource);

  @override
  Future<WeatherModel> getCurrentWeatherByCity(String cityName) async {
    try {
      final weather = await _remoteDataSource.getCurrentWeatherByCity(cityName);
      await _localDataSource.cacheCurrentWeather(weather);
      await _localDataSource.saveLastCity(cityName);
      await _localDataSource.addSearchHistory(cityName);
      return weather;
    } catch (e) {
      AppLogger.error('Failed to get weather by city: $cityName', e, null, 'WeatherRepo');
      // If offline/error, return cached if exists
      final cached = _localDataSource.getCachedCurrentWeather();
      if (cached != null && cached.cityName.toLowerCase() == cityName.toLowerCase()) {
        AppLogger.info('Returning cached weather for $cityName', 'WeatherRepo');
        return cached;
      }
      rethrow;
    }
  }

  @override
  Future<WeatherModel> getCurrentWeatherByCoordinates(double lat, double lon) async {
    try {
      final weather = await _remoteDataSource.getCurrentWeatherByCoordinates(lat, lon);
      await _localDataSource.cacheCurrentWeather(weather);
      await _localDataSource.saveLastCity(weather.cityName);
      return weather;
    } catch (e) {
      AppLogger.error('Failed to get weather by coords ($lat, $lon)', e, null, 'WeatherRepo');
      final cached = _localDataSource.getCachedCurrentWeather();
      if (cached != null) {
        return cached;
      }
      rethrow;
    }
  }

  @override
  Future<ForecastModel> getForecastByCity(String cityName) async {
    try {
      final forecast = await _remoteDataSource.getForecastByCity(cityName);
      await _localDataSource.cacheForecast(forecast);
      return forecast;
    } catch (e) {
      AppLogger.error('Failed to get forecast for $cityName', e, null, 'WeatherRepo');
      final cached = _localDataSource.getCachedForecast();
      if (cached != null) {
        return cached;
      }
      rethrow;
    }
  }

  @override
  Future<ForecastModel> getForecastByCoordinates(double lat, double lon) async {
    try {
      final forecast = await _remoteDataSource.getForecastByCoordinates(lat, lon);
      await _localDataSource.cacheForecast(forecast);
      return forecast;
    } catch (e) {
      AppLogger.error('Failed to get forecast by coords ($lat, $lon)', e, null, 'WeatherRepo');
      final cached = _localDataSource.getCachedForecast();
      if (cached != null) {
        return cached;
      }
      rethrow;
    }
  }

  @override
  WeatherModel? getCachedWeather() => _localDataSource.getCachedCurrentWeather();

  @override
  ForecastModel? getCachedForecast() => _localDataSource.getCachedForecast();

  @override
  String? getLastSearchedCity() => _localDataSource.getLastCity();

  @override
  List<String> getSearchHistory() => _localDataSource.getSearchHistory();

  @override
  Future<void> addSearchHistory(String city) => _localDataSource.addSearchHistory(city);

  @override
  Future<void> removeSearchHistory(String city) => _localDataSource.removeSearchHistory(city);

  @override
  Future<void> clearSearchHistory() => _localDataSource.clearSearchHistory();
}
