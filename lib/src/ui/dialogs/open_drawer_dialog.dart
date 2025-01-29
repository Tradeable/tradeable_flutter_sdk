import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:tradeable_flutter_sdk/tradeable_flutter_sdk.dart';

class OpenDrawerDialog extends StatelessWidget {
  final Function(bool) onOkPressed;

  const OpenDrawerDialog({
    super.key,
    required this.onOkPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: SizedBox(
        height: MediaQuery.of(context).size.height *
            0.5, // Dialog takes 60% of screen height
        width: MediaQuery.of(context).size.width *
            0.8, // Dialog takes 80% of screen width
        child: Column(
          children: [
            Expanded(
              flex: 2,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xffed1164), Color(0xff97144d)],
                  ),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: IconButton(
                            onPressed: () {
                              onOkPressed(false);
                            },
                            icon: Icon(
                              Icons.close,
                              color: Colors.white,
                            )),
                      ),
                    ),
                    Spacer(),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width *
                            0.9, // 80% of dialog width
                        child: Lottie.asset(
                          'packages/tradeable_flutter_sdk/lib/assets/lottie/lottie_open_helper.json', // Replace with your Lottie animation file
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Bottom section with text and button (1/3 of dialog height)
            Expanded(
              flex: 1,
              child: Container(
                padding: EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Confused with financial jargon on page, try to understand it better',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: TextButton(
                        onPressed: () {
                          onOkPressed(true);
                        },
                        child: Text(
                          'OK',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Usage example:
void showOpenDrawerDialog(
  BuildContext context,
) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return OpenDrawerDialog(
        onOkPressed: (p0) {
          StorageManager().setDrawerDialogueShown(true);
          Navigator.of(context).pop();
        },
      );
    },
  );
}
