import 'package:flutter/material.dart';
import 'package:invoice_management_flutter_fe/constants/colors.dart';
import 'package:invoice_management_flutter_fe/widgets/heading_text.dart';

Widget button(
  String text, {
  required VoidCallback onPressed,
  Color textColor = AppColors.white,
  double width = double.infinity,
  bool disabled = false,
  bool isLoading = false,
  double paddingY = 16,
  double paddingX = 24,
  Color btnColor = AppColors.primary,
  double btnRadious = 5,
  double fontSize = 16,
  double loaderSize = 16,
  double loaderStrokeWidth = 3,
}) {
  void handleTap() {
    if (!disabled && !isLoading) {
      onPressed();
    }
  }

  return InkWell(
    onTap: handleTap,
    child: Opacity(
      opacity: disabled || isLoading ? 0.5 : 1,
      child: Container(
        width: width,
        padding: EdgeInsets.symmetric(vertical: paddingY, horizontal: paddingX),
        decoration: BoxDecoration(
          color: btnColor,
          borderRadius: BorderRadius.circular(btnRadious),
        ),
        child: Center(
          child: Row(
            spacing: 10,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (isLoading)
                SizedBox(
                  width: loaderSize,
                  height: loaderSize,
                  child: CircularProgressIndicator(
                    strokeWidth: loaderStrokeWidth,
                    color: textColor,
                  ),
                ),
              h3(text, color: textColor, fontSize: fontSize),
            ],
          ),
        ),
      ),
    ),
  );
}
