import 'package:flutter/material.dart';
import '../../../app/theme/app_colors.dart';
import '../../../core/utils/date_formatter.dart';
import '../models/weather_model.dart';

class WeatherDetailsGrid extends StatelessWidget {
  final WeatherModel weather;

  const WeatherDetailsGrid({super.key, required this.weather});

  Widget _buildDetailTile({
    required BuildContext context,
    required IconData icon,
    required Color iconColor,
    required String title,
    required String value,
    String? subtitle,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.lightCard,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: iconColor, size: 20),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 11,
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: 0.5),
              ),
            ),
          ],
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final sunriseFormatted = weather.sunrise > 0
        ? DateFormatter.formatSunTime(weather.sunrise)
        : '--';
    final sunsetFormatted = weather.sunset > 0
        ? DateFormatter.formatSunTime(weather.sunset)
        : '--';

    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(12),
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.05,
      children: [
        _buildDetailTile(
          context: context,
          icon: Icons.water_drop_rounded,
          iconColor: Colors.blueAccent,
          title: 'Humidity',
          value: weather.humidityDisplay,
          subtitle: 'Dew point is comfortable',
        ),
        _buildDetailTile(
          context: context,
          icon: Icons.air_rounded,
          iconColor: Colors.teal,
          title: 'Wind Speed',
          value: weather.windSpeedDisplay,
          subtitle: 'Gentle breeze',
        ),
        _buildDetailTile(
          context: context,
          icon: Icons.speed_rounded,
          iconColor: Colors.orangeAccent,
          title: 'Pressure',
          value: weather.pressureDisplay,
          subtitle: 'Atmospheric pressure',
        ),
        _buildDetailTile(
          context: context,
          icon: Icons.visibility_rounded,
          iconColor: Colors.purpleAccent,
          title: 'Visibility',
          value: weather.visibilityDisplay,
          subtitle: 'Clear road view',
        ),
        _buildDetailTile(
          context: context,
          icon: Icons.cloud_queue_rounded,
          iconColor: Colors.blueGrey,
          title: 'Cloud Cover',
          value: weather.cloudsDisplay,
          subtitle: 'Sky coverage',
        ),
        _buildDetailTile(
          context: context,
          icon: Icons.wb_twilight_rounded,
          iconColor: Colors.amber,
          title: 'Sun Cycle',
          value: sunriseFormatted,
          subtitle: 'Sunset: $sunsetFormatted',
        ),
      ],
    );
  }
}
