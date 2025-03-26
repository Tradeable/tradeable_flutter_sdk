import 'package:flutter/material.dart';

class DoubleLayerButtonWidget extends StatelessWidget {
  final VoidCallback onClick;
  final String text;
  final bool isDisabled;

  const DoubleLayerButtonWidget(
      {super.key,
      required this.onClick,
      required this.text,
      required this.isDisabled});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            const Color(0xff1D1D1D).withOpacity(0.8),
            const Color(0xff303030).withOpacity(0.8),
          ],
        ),
      ),
      child: InkWell(
        onTap: onClick,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xff303030), Color(0xff1D1D1D)],
            ),
          ),
          width: double.infinity,
          child: Center(
            child: Text(
              text,
              style: isDisabled
                  ? TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                      color: Color.fromRGBO(69, 66, 66, 0.5))
                  : TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                      foreground: Paint()
                        ..shader = LinearGradient(
                          colors: [Color(0xff50F3BF), Color(0xff1E1E1E)],
                        ).createShader(
                            const Rect.fromLTWH(0.0, 0.0, 400.0, 70.0)),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
