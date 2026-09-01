import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../../../app/routes/app_routes.dart';
import '../../../app/theme/app_colors.dart';
import '../../../widgets/common/error_state_widget.dart';
import '../../../widgets/common/offline_banner.dart';
import '../../../widgets/dialogs/api_key_dialog.dart';
import '../../../widgets/dialogs/logout_confirm_dialog.dart';
import '../../auth/controllers/auth_controller.dart';
import '../controllers/weather_controller.dart';
import '../widgets/current_weather_card.dart';
import '../widgets/forecast_list.dart';
import '../widgets/hourly_forecast_list.dart';
import '../widgets/weather_details_grid.dart';
import '../widgets/weather_shimmer.dart';

class WeatherHomeView extends StatefulWidget {
  const WeatherHomeView({super.key});

  @override
  State<WeatherHomeView> createState() => _WeatherHomeViewState();
}

class _WeatherHomeViewState extends State<WeatherHomeView> {
  late final WeatherController _weatherController;
  late final AuthController _authController;

  @override
  void initState() {
    super.initState();
    _weatherController = Get.find<WeatherController>();
    _authController = Get.find<AuthController>();
  }

  void _handleLogout() {
    LogoutConfirmDialog.show(
      context,
      onConfirm: () async {
        await _authController.logout();
        if (mounted) {
          context.go(AppRoutes.login);
        }
      },
    );
  }

  void _openApiKeyDialog() {
    ApiKeyDialog.show(
      context,
      currentApiKey: _weatherController.getCustomApiKey(),
      onSave: (newKey) {
        _weatherController.updateApiKey(newKey);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(() {
          final user = _authController.currentUser.value;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                user != null ? 'Hello, ${user.name.split(" ").first}' : 'WeatherWise',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const Text(
                'Live Forecast',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
              ),
            ],
          );
        }),
        actions: [
          // GPS Location Trigger
          Obx(() => IconButton(
                tooltip: 'Get GPS Location Weather',
                icon: _weatherController.isLocationLoading.value
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.my_location_rounded),
                onPressed: _weatherController.isLocationLoading.value
                    ? null
                    : () => _weatherController.fetchWeatherByLocation(),
              )),

          // Search Screen Navigator
          IconButton(
            tooltip: 'Search City',
            icon: const Icon(Icons.search_rounded),
            onPressed: () => context.push(AppRoutes.search),
          ),

          // Theme Toggle Button
          Obx(() => IconButton(
                tooltip: 'Toggle Dark/Light Mode',
                icon: Icon(
                  _weatherController.isDarkMode.value
                      ? Icons.light_mode_rounded
                      : Icons.dark_mode_rounded,
                  color: _weatherController.isDarkMode.value
                      ? Colors.amber
                      : AppColors.primary,
                ),
                onPressed: _weatherController.toggleTheme,
              )),

          // More Options Menu (API Key / Logout)
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert_rounded),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            onSelected: (value) {
              if (value == 'api_key') {
                _openApiKeyDialog();
              } else if (value == 'logout') {
                _handleLogout();
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'api_key',
                child: Row(
                  children: [
                    Icon(Icons.vpn_key_outlined, size: 20),
                    SizedBox(width: 12),
                    Text('API Key Settings'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'logout',
                child: Row(
                  children: [
                    Icon(Icons.logout_rounded, color: AppColors.error, size: 20),
                    SizedBox(width: 12),
                    Text('Logout', style: TextStyle(color: AppColors.error)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Offline Indicator
            Obx(() => _weatherController.isOffline
                ? const OfflineBanner()
                : const SizedBox.shrink()),

            // Main Weather Content
            Expanded(
              child: Obx(() {
                final weather = _weatherController.currentWeather.value;
                final forecast = _weatherController.forecast.value;
                final isLoading = _weatherController.isLoading.value;

                if (isLoading && weather == null) {
                  return const WeatherShimmer();
                }

                if (weather == null) {
                  return ErrorStateWidget(
                    message: _weatherController.errorMessage.value.isNotEmpty
                        ? _weatherController.errorMessage.value
                        : 'No weather data available.',
                    onRetry: () => _weatherController.refreshWeather(),
                  );
                }

                return RefreshIndicator(
                  color: AppColors.primary,
                  onRefresh: _weatherController.refreshWeather,
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Current Weather Card
                        CurrentWeatherCard(
                          weather: weather,
                          onLocationTap: () => _weatherController.fetchWeatherByLocation(),
                        ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.05, end: 0),
                        const SizedBox(height: 20),

                        // Hourly Forecast
                        if (forecast != null && forecast.next24Hours.isNotEmpty) ...[
                          HourlyForecastList(hourlyItems: forecast.next24Hours)
                              .animate()
                              .fadeIn(delay: 150.ms)
                              .slideY(begin: 0.05, end: 0),
                          const SizedBox(height: 20),
                        ],

                        // 5-Day Forecast
                        if (forecast != null && forecast.fiveDayForecast.isNotEmpty) ...[
                          ForecastList(dailyItems: forecast.fiveDayForecast)
                              .animate()
                              .fadeIn(delay: 250.ms)
                              .slideY(begin: 0.05, end: 0),
                          const SizedBox(height: 20),
                        ],

                        // Weather Details Grid
                        Row(
                          children: [
                            const Icon(Icons.analytics_outlined, size: 18, color: AppColors.primary),
                            const SizedBox(width: 8),
                            Text(
                              'Weather Details',
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        WeatherDetailsGrid(weather: weather)
                            .animate()
                            .fadeIn(delay: 350.ms)
                            .slideY(begin: 0.05, end: 0),
                        const SizedBox(height: 28),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
