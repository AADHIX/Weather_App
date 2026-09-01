import 'package:flutter/material.dart';
import '../../../app/theme/app_colors.dart';
import '../../../core/constants/asset_constants.dart';

class SearchHistoryList extends StatelessWidget {
  final List<String> history;
  final ValueChanged<String> onSelectCity;
  final ValueChanged<String> onDeleteItem;
  final VoidCallback onClearAll;

  const SearchHistoryList({
    super.key,
    required this.history,
    required this.onSelectCity,
    required this.onDeleteItem,
    required this.onClearAll,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Popular Cities Section
          Row(
            children: [
              const Icon(Icons.trending_up_rounded, size: 18, color: AppColors.primary),
              const SizedBox(width: 8),
              Text(
                'Popular Destinations',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: AssetConstants.popularCities.map((item) {
              final city = item['city']!;
              return ActionChip(
                label: Text(city),
                avatar: const Icon(Icons.location_city_rounded, size: 16),
                backgroundColor: isDark ? AppColors.darkCard : AppColors.lightCard,
                side: BorderSide(
                  color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                onPressed: () => onSelectCity(city),
              );
            }).toList(),
          ),
          const SizedBox(height: 28),

          // Recent Searches Section
          if (history.isNotEmpty) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.history_rounded, size: 18, color: AppColors.primary),
                    const SizedBox(width: 8),
                    Text(
                      'Recent Searches',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
                TextButton(
                  onPressed: onClearAll,
                  child: const Text(
                    'Clear All',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.error,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkCard : AppColors.lightCard,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                ),
              ),
              child: ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: history.length,
                separatorBuilder: (context, index) => Divider(
                  color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                  height: 1,
                ),
                itemBuilder: (context, index) {
                  final city = history[index];
                  return ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                    leading: const Icon(Icons.history_toggle_off_rounded, size: 20),
                    title: Text(
                      city,
                      style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.close_rounded, size: 18),
                      onPressed: () => onDeleteItem(city),
                    ),
                    onTap: () => onSelectCity(city),
                  );
                },
              ),
            ),
          ],
        ],
      ),
    );
  }
}
