import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/api_constants.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/services/connectivity_service.dart';
import '../../../core/services/location_service.dart';
import '../../../core/services/storage_service.dart';
import '../../../core/utils/app_logger.dart';
import '../../../data/repositories/weather_repository.dart';
import '../models/forecast_model.dart';
import '../models/weather_model.dart';

class WeatherController extends GetxController {
  final WeatherRepository _weatherRepository;
  final LocationService _locationService;
  final ConnectivityService _connectivityService;
  final StorageService _storageService;

  WeatherController({
    required WeatherRepository weatherRepository,
    required LocationService locationService,
    required ConnectivityService connectivityService,
    required StorageService storageService,
  })  : _weatherRepository = weatherRepository,
        _locationService = locationService,
        _connectivityService = connectivityService,
        _storageService = storageService;

  // Observable States
  final Rx<WeatherModel?> currentWeather = Rx<WeatherModel?>(null);
  final Rx<ForecastModel?> forecast = Rx<ForecastModel?>(null);
  final RxBool isLoading = false.obs;
  final RxBool isRefreshing = false.obs;
  final RxBool isLocationLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxList<String> searchHistory = <String>[].obs;
  final RxBool isDarkMode = false.obs;
  final RxString activeCity = ''.obs;

  bool get isOffline => !_connectivityService.isConnected.value;

  @override
  void onInit() {
    super.onInit();
    _loadThemePreference();
    _loadSearchHistory();
    _initWeatherData();

    // Listen to network changes
    ever(_connectivityService.isConnected, (bool connected) {
      if (connected && currentWeather.value == null) {
        refreshWeather();
      }
    });
  }

  void _loadThemePreference() {
    final savedMode = _storageService.getBool(AppConstants.keyThemeMode);
    if (savedMode != null) {
      isDarkMode.value = savedMode;
    } else {
      isDarkMode.value = Get.isPlatformDarkMode;
    }
  }

  void toggleTheme() {
    isDarkMode.value = !isDarkMode.value;
    _storageService.setBool(AppConstants.keyThemeMode, isDarkMode.value);
    Get.changeThemeMode(isDarkMode.value ? ThemeMode.dark : ThemeMode.light);
  }

  void _loadSearchHistory() {
    searchHistory.assignAll(_weatherRepository.getSearchHistory());
  }

  Future<void> _initWeatherData() async {
    // 1. Try loading cached data first for instant UI
    final cachedWeather = _weatherRepository.getCachedWeather();
    final cachedForecast = _weatherRepository.getCachedForecast();
    if (cachedWeather != null) {
      currentWeather.value = cachedWeather;
      activeCity.value = cachedWeather.cityName;
    }
    if (cachedForecast != null) {
      forecast.value = cachedForecast;
    }

    // 2. Fetch fresh weather from GPS location or last city or default
    final lastCity = _weatherRepository.getLastSearchedCity();
    if (lastCity != null && lastCity.isNotEmpty) {
      await fetchWeatherByCity(lastCity, isInitial: true);
    } else {
      await fetchWeatherByLocation(isInitial: true);
    }
  }

  Future<void> fetchWeatherByLocation({bool isInitial = false}) async {
    if (!isInitial) {
      isLocationLoading.value = true;
      errorMessage.value = '';
    } else if (currentWeather.value == null) {
      isLoading.value = true;
    }

    try {
      final locResult = await _locationService.getCurrentLocation();
      if (!locResult.isSuccess) {
        AppLogger.warning('Location failed: ${locResult.error}', 'WeatherController');
        // Fallback to default city if no weather loaded yet
        if (currentWeather.value == null) {
          await fetchWeatherByCity(ApiConstants.defaultCity);
        } else if (!isInitial) {
          Get.snackbar(
            'Location Notice',
            locResult.error ?? 'Could not get current location. Showing previous weather.',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.amber.shade800,
            colorText: Colors.white,
            duration: const Duration(seconds: 4),
          );
        }
        return;
      }

      final weather = await _weatherRepository.getCurrentWeatherByCoordinates(
        locResult.latitude,
        locResult.longitude,
      );
      final forecastData = await _weatherRepository.getForecastByCoordinates(
        locResult.latitude,
        locResult.longitude,
      );

      currentWeather.value = weather;
      forecast.value = forecastData;
      activeCity.value = weather.cityName;
      errorMessage.value = '';
      AppLogger.success('Fetched weather by location for: ${weather.cityName}', 'WeatherController');
    } catch (e) {
      AppLogger.error('Error fetching weather by location', e, null, 'WeatherController');
      _handleFetchError(e);
    } finally {
      isLoading.value = false;
      isLocationLoading.value = false;
      isRefreshing.value = false;
    }
  }

  Future<bool> fetchWeatherByCity(String cityName, {bool isInitial = false}) async {
    if (cityName.trim().isEmpty) return false;

    if (!isInitial) {
      isLoading.value = true;
      errorMessage.value = '';
    }

    try {
      final weather = await _weatherRepository.getCurrentWeatherByCity(cityName.trim());
      final forecastData = await _weatherRepository.getForecastByCity(cityName.trim());

      currentWeather.value = weather;
      forecast.value = forecastData;
      activeCity.value = weather.cityName;
      errorMessage.value = '';
      _loadSearchHistory();
      AppLogger.success('Fetched weather for: $cityName', 'WeatherController');
      return true;
    } catch (e) {
      AppLogger.error('Error fetching weather by city: $cityName', e, null, 'WeatherController');
      _handleFetchError(e);
      return false;
    } finally {
      isLoading.value = false;
      isRefreshing.value = false;
    }
  }

  Future<void> refreshWeather() async {
    isRefreshing.value = true;
    if (activeCity.value.isNotEmpty) {
      await fetchWeatherByCity(activeCity.value, isInitial: true);
    } else {
      await fetchWeatherByLocation(isInitial: true);
    }
    isRefreshing.value = false;
  }

  void _handleFetchError(dynamic error) {
    // If no weather loaded at all, populate with Demo Data so user can test the UI immediately!
    if (currentWeather.value == null) {
      AppLogger.info('Using fallback demo weather data', 'WeatherController');
      currentWeather.value = WeatherModel.demo();
      forecast.value = ForecastModel.demo();
      activeCity.value = 'San Francisco';
    }

    final msg = error.toString().replaceAll('ApiException: ', '').replaceAll('Exception: ', '');
    errorMessage.value = msg;

    Get.snackbar(
      'Weather Notice',
      msg,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.redAccent.shade700,
      colorText: Colors.white,
      duration: const Duration(seconds: 4),
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
    );
  }

  Future<void> removeSearchHistoryItem(String city) async {
    await _weatherRepository.removeSearchHistory(city);
    _loadSearchHistory();
  }

  Future<void> clearAllSearchHistory() async {
    await _weatherRepository.clearSearchHistory();
    _loadSearchHistory();
  }

  Future<void> updateApiKey(String newKey) async {
    if (newKey.trim().isEmpty) {
      await _storageService.remove(AppConstants.keyCustomApiKey);
    } else {
      await _storageService.setString(AppConstants.keyCustomApiKey, newKey.trim());
    }
    refreshWeather();
  }

  String getCustomApiKey() {
    return _storageService.getString(AppConstants.keyCustomApiKey) ?? '';
  }
}
