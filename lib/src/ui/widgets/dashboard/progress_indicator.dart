import 'dart:math';
import 'package:flutter/material.dart';
import 'package:tradeable_flutter_sdk/src/ui/widgets/dashboard/custom_linear_progress_indicator.dart';

class ProgressWidget extends StatelessWidget {
  final List<ProgressItem> items;
  final double overallProgress;

  const ProgressWidget({
    super.key,
    required this.items,
    required this.overallProgress,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Recent Activity',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  children:
                      items.map((item) => _buildProgressItem(item)).toList(),
                ),
              ),
              const SizedBox(width: 16),
              SizedBox(
                width: 100,
                height: 100,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: CustomPaint(
                        painter: ContainerSemiCirclePainter(
                          items: items,
                          containerSize: const Size(100, 100),
                          strokeWidth: 8,
                          gap: 4,
                        ),
                      ),
                    ),
                    Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '${overallProgress.toInt()}%',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Text(
                            'Overall',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProgressItem(ProgressItem item) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            height: 24,
            width: 4,
            color: item.color,
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${item.progress.toInt()}%',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                item.label,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ContainerSemiCirclePainter extends CustomPainter {
  final List<ProgressItem> items;
  final Size containerSize;
  final double strokeWidth;
  final double gap;

  ContainerSemiCirclePainter({
    required this.items,
    required this.containerSize,
    this.strokeWidth = 8,
    this.gap = 4,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(containerSize.width / 2, containerSize.height);
    final radius = containerSize.width * 0.7;

    final bgPaint = Paint()
      ..color = Colors.grey[300]!
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    for (int i = 0; i < items.length; i++) {
      final item = items[i];
      final currentRadius = radius - (i * (strokeWidth + gap));

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: currentRadius),
        pi,
        pi,
        false,
        bgPaint,
      );

      final progressPaint = Paint()
        ..color = item.color
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round;

      final angleToTopRight = pi * 0.75;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: currentRadius),
        pi,
        angleToTopRight * (item.progress / 100),
        false,
        progressPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
