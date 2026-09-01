import '../../core/constants/api_constants.dart';
import '../../core/constants/app_constants.dart';
import '../../core/services/api_service.dart';
import '../../core/services/storage_service.dart';
import '../../modules/weather/models/forecast_model.dart';
import '../../modules/weather/models/weather_model.dart';

abstract class WeatherRemoteDataSource {
  Future<WeatherModel> getCurrentWeatherByCity(String cityName);
  Future<WeatherModel> getCurrentWeatherByCoordinates(double lat, double lon);
  Future<ForecastModel> getForecastByCity(String cityName);
  Future<ForecastModel> getForecastByCoordinates(double lat, double lon);
}

class WeatherRemoteDataSourceImpl implements WeatherRemoteDataSource {
  final ApiService _apiService;
  final StorageService _storageService;

  WeatherRemoteDataSourceImpl(this._apiService, this._storageService);

  String _getApiKey() {
    final customKey = _storageService.getString(AppConstants.keyCustomApiKey);
    if (customKey != null && customKey.trim().isNotEmpty) {
      return customKey.trim();
    }
    return ApiConstants.apiKey;
  }

  @override
  Future<WeatherModel> getCurrentWeatherByCity(String cityName) async {
    final response = await _apiService.get(
      ApiConstants.currentWeather,
      queryParams: {
        'q': cityName,
        'appid': _getApiKey(),
        'units': ApiConstants.unitsMetric,
      },
    );
    return WeatherModel.fromJson(response);
  }

  @override
  Future<WeatherModel> getCurrentWeatherByCoordinates(double lat, double lon) async {
    final response = await _apiService.get(
      ApiConstants.currentWeather,
      queryParams: {
        'lat': lat.toString(),
        'lon': lon.toString(),
        'appid': _getApiKey(),
        'units': ApiConstants.unitsMetric,
      },
    );
    return WeatherModel.fromJson(response);
  }

  @override
  Future<ForecastModel> getForecastByCity(String cityName) async {
    final response = await _apiService.get(
      ApiConstants.forecast,
      queryParams: {
        'q': cityName,
        'appid': _getApiKey(),
        'units': ApiConstants.unitsMetric,
      },
    );
    return ForecastModel.fromJson(response);
  }

  @override
  Future<ForecastModel> getForecastByCoordinates(double lat, double lon) async {
    final response = await _apiService.get(
      ApiConstants.forecast,
      queryParams: {
        'lat': lat.toString(),
        'lon': lon.toString(),
        'appid': _getApiKey(),
        'units': ApiConstants.unitsMetric,
      },
    );
    return ForecastModel.fromJson(response);
  }
}
