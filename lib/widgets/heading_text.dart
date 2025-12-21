import 'package:flutter/material.dart';
import 'package:invoice_management_flutter_fe/constants/colors.dart';
import 'package:invoice_management_flutter_fe/constants/font.dart';

Widget h1(String text, {Color? color = AppColors.black, double fontSize = 24}) {
  return Text(
    text,
    style: TextStyle(
      fontSize: fontSize,
      fontWeight: FontWeight.bold,
      color: color,
      fontFamily: AppFonts.poppins,
      decoration: TextDecoration.none,
      decorationColor: null,
    ),
  );
}

Widget h2(String text, {Color? color = AppColors.black, double fontSize = 18}) {
  return Text(
    text,
    style: TextStyle(
      fontSize: fontSize,
      fontWeight: FontWeight.bold,
      color: color,
      fontFamily: AppFonts.poppins,
      decoration: TextDecoration.none,
      decorationColor: null,
    ),
  );
}

Widget h3(String text, {Color? color = AppColors.black, double fontSize = 16}) {
  return Text(
    text,
    style: TextStyle(
      fontSize: fontSize,
      fontWeight: FontWeight.bold,
      color: color,
      fontFamily: AppFonts.poppins,
      decoration: TextDecoration.none,
      decorationColor: null,
    ),
  );
}

Widget text(
  String text, {
  Color? color = AppColors.black,
  double fontSize = 14,
  FontWeight? fontWeight = FontWeight.normal,
}) {
  return Text(
    text,
    style: TextStyle(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      fontFamily: AppFonts.poppins,
      decoration: TextDecoration.none,
      decorationColor: null,
    ),
  );
}

Widget label(
  String text, {
  Color color = AppColors.black,
  double fontSize = 14,
  bool required = false,
}) {
  return RichText(
    text: TextSpan(
      children: [
        TextSpan(
          text: text,
          style: TextStyle(
            fontFamily: AppFonts.poppins,
            fontSize: fontSize,
            fontWeight: FontWeight.w600,
            color: color,
            decoration: TextDecoration.none,
          ),
        ),
        if (required)
          TextSpan(
            text: ' *',
            style: TextStyle(
              fontFamily: AppFonts.poppins,
              fontSize: fontSize,
              fontWeight: FontWeight.w600,
              color: AppColors.danger,
              decoration: TextDecoration.none,
            ),
          ),
      ],
    ),
  );
}
