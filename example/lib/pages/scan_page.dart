import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:tradeable_flutter_sdk/tradeable_flutter_sdk.dart';

class ScanPage extends StatefulWidget {
  final String assetPath;

  const ScanPage({
    super.key,
    required this.assetPath,
  });

  @override
  State<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  bool _showAnimation = false;
  PageId? pageId;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2), // Duration of the animation
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _triggerScanAnimation() {
    setState(() {
      _showAnimation = true;
    });

    _animationController.reset();
    _animationController.forward().then((_) {
      // Hide animation after completion
      if (mounted) {
        setState(() {
          _showAnimation = false;
          if (widget.assetPath == "assets/images/overview.png") {
            pageId = PageId.axisOverview;
          }
          if (widget.assetPath == "assets/images/indicators.png") {
            pageId = PageId.paisaDemo;
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return TradeableContainer(
      pageId: pageId,
      isLearnBtnStatic: false,
      learnBtnTopPos: 80,
      onLongPress: _triggerScanAnimation,
      child: Scaffold(
        body: Stack(
          children: [
            // Background image
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(widget.assetPath),
                  fit: BoxFit.cover,
                ),
              ),
              child: const SizedBox.expand(
                child: Center(
                  child: Text(
                    'Scan Page',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),

            // Lottie animation overlay
            if (_showAnimation)
              Positioned.fill(
                child: Container(
                  color:
                      Colors.black.withOpacity(0.3), // Semi-transparent overlay
                  child: Center(
                    child: Lottie.asset(
                      'assets/lottie/scan_animation.json', // Path to your Lottie file
                      controller: _animationController,
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      fit: BoxFit.contain,
                      repeat: false,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
