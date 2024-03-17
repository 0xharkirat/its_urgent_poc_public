import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback? onTap;
  final String text;
  final bool isLoading; // New parameter to control progress indicator visibility

  const CustomButton({
    super.key,
    required this.onTap,
    required this.text,
    this.isLoading = false, // Default value is false
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Visibility(
            visible: !isLoading,
            child: Text(text),
          ),
          Visibility(
            visible: isLoading,
            child: const SizedBox(
              width: 24, // Adjust width as needed
              height: 24, // Adjust height as needed
              child: CircularProgressIndicator(
                strokeWidth: 2, // Adjust thickness of the indicator
              ),
            ),
          ),
        ],
      ),
    );
  }
}
