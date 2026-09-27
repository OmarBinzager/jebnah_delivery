import 'package:flutter/material.dart';

class ConfirmOrderButton extends StatelessWidget {
  final VoidCallback onPressed;
  final bool isLoading;
  final bool isEnabled;
  final String label;
  final double height;
  final double width;
  final double borderRadius;
  final Color backgroundColor;
  final Color pressedColor;
  final Color textColor;
  final Widget? icon;

  const ConfirmOrderButton({
    super.key,
    required this.onPressed,
    this.isLoading = false,
    this.isEnabled = true,
    this.label = 'تأكيد الطلب',
    this.height = 55,
    this.width = double.infinity,
    this.borderRadius = 12,
    this.backgroundColor = const Color(0xFF2E7D32),
    this.pressedColor = const Color(0xFF1B5E20),
    this.textColor = Colors.white,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: ElevatedButton(
        onPressed: (isEnabled && !isLoading) ? onPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: textColor,
          disabledBackgroundColor: Colors.grey.shade400,
          disabledForegroundColor: Colors.grey.shade600,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          elevation: 2,
          shadowColor: Colors.black26,
          padding: const EdgeInsets.symmetric(horizontal: 20),
        ),
        child: isLoading
            ? const SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (icon != null) ...[icon!, const SizedBox(width: 10)],
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: isEnabled ? textColor : Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

// نسخة مبسطة للاستخدام السريع
class SimpleConfirmButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String label;

  const SimpleConfirmButton({
    super.key,
    required this.onPressed,
    this.label = 'تأكيد الطلب',
  });

  @override
  Widget build(BuildContext context) {
    return ConfirmOrderButton(onPressed: onPressed, label: label);
  }
}
