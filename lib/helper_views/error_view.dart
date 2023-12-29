import 'package:flutter/material.dart';

class ErrorView extends StatelessWidget {
  final String errorTitle;
  final String errorMessage;
  final VoidCallback? onPress;
  final String? buttonText;

  const ErrorView({
    super.key,
    required this.errorTitle,
    required this.errorMessage,
    this.onPress,
    this.buttonText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: Colors.red),
        color: Colors.red.withOpacity(0.1),
      ),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            errorTitle,
            style: const TextStyle(
              color: Colors.red,
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            errorMessage,
            style: const TextStyle(
              color: Colors.red,
              fontSize: 16.0,
            ),
          ),
          if (onPress != null && buttonText != null)
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: onPress,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(color: Colors.red),
                      color: Colors.red.withOpacity(0.1),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Text(
                        buttonText!,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
