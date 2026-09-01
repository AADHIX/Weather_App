import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../../app/theme/app_colors.dart';
import '../../../core/utils/date_formatter.dart';
import '../models/forecast_model.dart';

class HourlyForecastList extends StatelessWidget {
  final List<ForecastItemModel> hourlyItems;

  const HourlyForecastList({super.key, required this.hourlyItems});

  @override
  Widget build(BuildContext context) {
    if (hourlyItems.isEmpty) return const SizedBox.shrink();

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.access_time_rounded, size: 18, color: AppColors.primary),
            const SizedBox(width: 8),
            Text(
              'Hourly Forecast',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 130,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: hourlyItems.length,
            separatorBuilder: (context, index) => const SizedBox(width: 10),
            itemBuilder: (context, index) {
              final item = hourlyItems[index];
              final isFirst = index == 0;

              return Container(
                width: 85,
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                decoration: BoxDecoration(
                  color: isFirst
                      ? AppColors.primary
                      : (isDark ? AppColors.darkCard : AppColors.lightCard),
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(
                    color: isFirst
                        ? Colors.transparent
                        : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
                  ),
                  boxShadow: isFirst
                      ? [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          )
                        ]
                      : null,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      isFirst ? 'Now' : DateFormatter.formatHourly(item.dateTime),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: isFirst ? FontWeight.bold : FontWeight.w500,
                        color: isFirst
                            ? Colors.white
                            : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                      ),
                    ),
                    CachedNetworkImage(
                      imageUrl: item.iconUrl,
                      height: 36,
                      width: 36,
                      placeholder: (context, url) => const SizedBox(
                        height: 20,
                        width: 20,
                        child: Center(
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      ),
                      errorWidget: (context, url, error) => const Icon(
                        Icons.wb_cloudy_rounded,
                        size: 24,
                        color: Colors.grey,
                      ),
                    ),
                    if (item.popProbability > 0)
                      Text(
                        '${item.popProbability}%',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: isFirst ? Colors.white70 : Colors.blueAccent,
                        ),
                      ),
                    Text(
                      item.temperatureDisplay,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: isFirst
                            ? Colors.white
                            : Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
