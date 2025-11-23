import 'package:flutter/material.dart';

/// Task 2: Reusable Custom Button Widget
/// Configurable text, color, and onTap callback
/// Demonstrates: responsive sizing with MediaQuery
class CustomButton extends StatelessWidget {
  final String text;
  final Color? backgroundColor;
  final Color? textColor;
  final VoidCallback onTap;
  final double? width;
  final double? height;
  final double borderRadius;
  final bool isLoading;

  const CustomButton({
    Key? key,
    required this.text,
    this.backgroundColor,
    this.textColor,
    required this.onTap,
    this.width,
    this.height,
    this.borderRadius = 12,
    this.isLoading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Responsive sizing using MediaQuery
    final screenWidth = MediaQuery.of(context).size.width;
    
    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: Container(
        width: width ?? screenWidth * 0.9,
        height: height ?? 50,
        decoration: BoxDecoration(
          color: isLoading 
            ? (backgroundColor ?? Colors.blue).withAlpha(128)
            : (backgroundColor ?? Colors.blue),
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: Center(
          child: isLoading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Text(
                text,
                style: TextStyle(
                  color: textColor ?? Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
        ),
      ),
    );
  }
}