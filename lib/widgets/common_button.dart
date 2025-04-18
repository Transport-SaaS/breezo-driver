import 'package:breezodriver/core/utils/app_colors.dart';
import 'package:flutter/material.dart';


class CommonButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isActive;
  final Color activeColor;
  final Color inactiveColor;
  final Color textColor;
  final Color borderColor;

  const CommonButton({
    Key? key,
    required this.label,
    required this.onPressed,
    required this.isActive,
    this.activeColor = AppColors.activeButton,
    this.inactiveColor = Colors.grey,
        this.textColor = Colors.white,
    this.borderColor = Colors.transparent,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isActive ? onPressed : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: isActive ? activeColor : inactiveColor,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28),
          side: BorderSide(color: borderColor),
        ),
      ),
      child: Text(
        label,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,color: textColor),
      ),
    );
  }
}
