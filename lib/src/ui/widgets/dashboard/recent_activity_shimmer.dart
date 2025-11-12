import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tradeable_flutter_sdk/src/tfs.dart';
import 'package:tradeable_flutter_sdk/src/utils/app_theme.dart';

class RecentActivityShimmer extends StatelessWidget {
  const RecentActivityShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final colors =
        TFS().themeData?.customColors ?? Theme.of(context).customColors;

    return Column(
      children: List.generate(2, (_) {
        return Container(
          width: double.infinity,
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          decoration: BoxDecoration(
            color: colors.neutral_2,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Shimmer.fromColors(
            baseColor:
                colors.borderColorSecondary.withAlpha((0.3 * 255).round()),
            highlightColor:
                colors.cardBasicBackground.withAlpha((0.6 * 255).round()),
            period: const Duration(milliseconds: 1200),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withAlpha((0.8 * 255).round()),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 14,
                        width: 130,
                        decoration: BoxDecoration(
                          color: Colors.white.withAlpha((0.8 * 255).round()),
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        height: 10,
                        width: 200,
                        decoration: BoxDecoration(
                          color: Colors.white.withAlpha((0.6 * 255).round()),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(height: 10),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          height: 6,
                          width: double.infinity,
                          color: Colors.white.withAlpha((0.5 * 255).round()),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
