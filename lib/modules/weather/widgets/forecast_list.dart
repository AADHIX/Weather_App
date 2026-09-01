import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../../app/theme/app_colors.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../core/utils/extensions.dart';
import '../models/forecast_model.dart';

class ForecastList extends StatelessWidget {
  final List<DailyForecastSummary> dailyItems;

  const ForecastList({super.key, required this.dailyItems});

  @override
  Widget build(BuildContext context) {
    if (dailyItems.isEmpty) return const SizedBox.shrink();

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.calendar_today_rounded, size: 18, color: AppColors.primary),
            const SizedBox(width: 8),
            Text(
              '5-Day Forecast',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkCard : AppColors.lightCard,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
              width: 1,
            ),
          ),
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: dailyItems.length,
            separatorBuilder: (context, index) => Divider(
              color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
              height: 1,
            ),
            itemBuilder: (context, index) {
              final item = dailyItems[index];
              final isToday = index == 0;

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: Row(
                  children: [
                    // Day of week
                    SizedBox(
                      width: 90,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isToday ? 'Today' : DateFormatter.formatShortDay(item.date),
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            DateFormatter.formatDayAndDate(item.date),
                            style: TextStyle(
                              fontSize: 11,
                              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Weather Icon & Description
                    Expanded(
                      child: Row(
                        children: [
                          CachedNetworkImage(
                            imageUrl: item.iconUrl,
                            height: 32,
                            width: 32,
                            placeholder: (context, url) => const SizedBox(width: 32),
                            errorWidget: (context, url, error) => const Icon(
                              Icons.wb_cloudy_rounded,
                              size: 20,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              item.description.toTitleCase(),
                              style: TextStyle(
                                fontSize: 13,
                                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.8),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Min & Max Temperature
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          item.maxTempDisplay,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          item.minTempDisplay,
                          style: TextStyle(
                            fontSize: 14,
                            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
                          ),
                        ),
                      ],
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
