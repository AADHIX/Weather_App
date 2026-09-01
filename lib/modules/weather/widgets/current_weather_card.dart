import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../../app/theme/app_colors.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../core/utils/extensions.dart';
import '../models/weather_model.dart';

class CurrentWeatherCard extends StatelessWidget {
  final WeatherModel weather;
  final VoidCallback? onLocationTap;

  const CurrentWeatherCard({
    super.key,
    required this.weather,
    this.onLocationTap,
  });

  List<Color> _getBackgroundGradient() {
    if (!weather.isDayTime) {
      return AppColors.nightClearGradient;
    }
    final condition = weather.conditionMain.toLowerCase();
    if (condition.contains('rain') || condition.contains('drizzle')) {
      return AppColors.rainyGradient;
    }
    if (condition.contains('thunder')) {
      return AppColors.thunderstormGradient;
    }
    if (condition.contains('snow')) {
      return AppColors.snowyGradient;
    }
    if (condition.contains('cloud') || condition.contains('fog') || condition.contains('mist')) {
      return AppColors.cloudyGradient;
    }
    return AppColors.sunnyGradient;
  }

  @override
  Widget build(BuildContext context) {
    final gradient = _getBackgroundGradient();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 28.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        gradient: LinearGradient(
          colors: gradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: gradient.first.withValues(alpha: 0.35),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // City Name & Country
          GestureDetector(
            onTap: onLocationTap,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.location_on_rounded,
                  color: Colors.white,
                  size: 22,
                ),
                const SizedBox(width: 6),
                Flexible(
                  child: Text(
                    '${weather.cityName}${weather.country.isNotEmpty ? ", ${weather.country}" : ""}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.3,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 6),

          // Date & Time
          Text(
            DateFormatter.formatFullDate(weather.timestamp),
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.85),
              fontSize: 13,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 16),

          // Weather Icon and Temperature Row
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CachedNetworkImage(
                imageUrl: weather.weatherIconUrl,
                width: 100,
                height: 100,
                fit: BoxFit.contain,
                placeholder: (context, url) => Text(
                  weather.conditionEmoji,
                  style: const TextStyle(fontSize: 54),
                ),
                errorWidget: (context, url, error) => Text(
                  weather.conditionEmoji,
                  style: const TextStyle(fontSize: 54),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                weather.temperatureDisplay,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 72,
                  fontWeight: FontWeight.w300,
                  height: 1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Condition Description
          Text(
            weather.description.toTitleCase(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.2,
            ),
          ),
          const SizedBox(height: 14),

          // Feels like and Min/Max Pill
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Feels like ${weather.feelsLikeDisplay}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  height: 12,
                  width: 1,
                  color: Colors.white.withValues(alpha: 0.5),
                ),
                Text(
                  'H: ${weather.tempMaxDisplay}  L: ${weather.tempMinDisplay}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
