import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ModuleCardShimmer extends StatelessWidget {
  const ModuleCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              flex: 7,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(height: 12, width: 100, color: Colors.grey[400]),
                  const SizedBox(height: 8),
                  Container(height: 12, width: 200, color: Colors.grey[400]),
                  const SizedBox(height: 8),
                  Container(height: 10, width: 150, color: Colors.grey[400]),
                ],
              ),
            ),
            Flexible(
              flex: 3,
              child: Container(
                height: 64,
                width: 64,
                color: Colors.grey[400],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
