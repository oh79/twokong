import 'package:flutter/material.dart';
import '../core/theme/theme.dart';

class TossButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isLoading;
  final bool isOutlined;
  final double height;

  const TossButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.isOutlined = false,
    this.height = 52,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: AppTheme.duration,
      curve: AppTheme.curve,
      height: height,
      child: MaterialButton(
        onPressed: isLoading ? null : onPressed,
        elevation: isOutlined ? 0 : 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: isOutlined ? AppTheme.primaryColor : Colors.transparent,
            width: isOutlined ? 1 : 0,
          ),
        ),
        color: isOutlined ? Colors.transparent : AppTheme.primaryColor,
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
                  color: isOutlined ? AppTheme.primaryColor : Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
    );
  }
}
