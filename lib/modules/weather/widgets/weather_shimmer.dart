import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class WeatherShimmer extends StatelessWidget {
  const WeatherShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final baseColor = isDark ? Colors.grey.shade800 : Colors.grey.shade300;
    final highlightColor = isDark ? Colors.grey.shade700 : Colors.grey.shade100;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Shimmer.fromColors(
        baseColor: baseColor,
        highlightColor: highlightColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Main Weather Hero Box
            Container(
              height: 280,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(28),
              ),
            ),
            const SizedBox(height: 24),

            // Hourly Forecast Placeholder Title
            Container(
              height: 20,
              width: 140,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            const SizedBox(height: 12),

            // Hourly items row
            SizedBox(
              height: 110,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 5,
                separatorBuilder: (context, index) => const SizedBox(width: 12),
                itemBuilder: (context, index) => Container(
                  width: 80,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // 5-Day Forecast Title
            Container(
              height: 20,
              width: 160,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            const SizedBox(height: 12),

            // 5-day list
            Container(
              height: 220,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
              ),
            ),
            const SizedBox(height: 24),

            // Weather Details Grid
            Container(
              height: 180,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
