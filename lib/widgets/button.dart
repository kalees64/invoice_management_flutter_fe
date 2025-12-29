import 'package:flutter/material.dart';
import 'package:invoice_management_flutter_fe/constants/colors.dart';
import 'package:invoice_management_flutter_fe/widgets/heading_text.dart';

Widget button(
  String text, {
  required VoidCallback onPressed,
  Color textColor = AppColors.white,
  double width = double.infinity,
  double height = 40,
  bool disabled = false,
  bool isLoading = false,
  double paddingY = 0,
  double paddingX = 0,
  Color btnColor = AppColors.primary,
  double btnRadious = 5,
  double fontSize = 14,
  double loaderSize = 14,
  double loaderStrokeWidth = 3,
  IconData? icon,
}) {
  void handleTap() {
    if (!disabled && !isLoading) {
      onPressed();
    }
  }

  return Flexible(
    child: InkWell(
      onTap: handleTap,
      child: Opacity(
        opacity: disabled || isLoading ? 0.5 : 1,
        child: Container(
          width: width,
          height: height,
          padding: EdgeInsets.symmetric(
            vertical: paddingY,
            horizontal: paddingX,
          ),
          decoration: BoxDecoration(
            color: btnColor,
            borderRadius: BorderRadius.circular(btnRadious),
          ),
          child: Center(
            child: Row(
              spacing: 5,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (icon != null && !isLoading)
                  Icon(icon, color: textColor, size: fontSize + 4),

                h3(text, color: textColor, fontSize: fontSize),
                if (isLoading) SizedBox(width: 5),
                if (isLoading)
                  SizedBox(
                    width: loaderSize,
                    height: loaderSize,
                    child: CircularProgressIndicator(
                      strokeWidth: loaderStrokeWidth,
                      color: textColor,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
