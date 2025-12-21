import 'package:flutter/material.dart';
import 'package:invoice_management_flutter_fe/constants/colors.dart';
import 'package:invoice_management_flutter_fe/constants/font.dart';

Widget input({
  String placeholder = "Enter text",
  Icon? prefixIcon,
  dynamic sufficIcon,
  Color fillColor = AppColors.transparent,
  Color placeholderColor = AppColors.grey,
  double paddindX = 10,
  double paddindY = 12,
  String? lableText,
  bool hideBorder = false,
  bool hideUnderline = false,
  Color borderColor = AppColors.secondary,
  Color focusBorderColor = AppColors.primary,
  Color errorBorderColor = AppColors.danger,
  double borderRadius = 5,
  bool obscureText = false,
  bool disabled = false,
  TextEditingController? controller,
  TextInputType keyboardType = TextInputType.text,
  bool readOnly = false,
  Function(String)? onChanged,
  Function(String?)? onSaved,
  String? Function(String?)? validator,
  bool autofocus = false,
  Color textColor = AppColors.black,
  FontWeight fontWeight = FontWeight.w700,
  TextCapitalization textCapitalization = TextCapitalization.none,
  String obscuringCharacter = "•",
}) {
  return TextFormField(
    autofocus: autofocus,
    obscureText: obscureText,
    obscuringCharacter: obscuringCharacter,
    enabled: !disabled,
    controller: controller,
    keyboardType: keyboardType,
    readOnly: readOnly,
    onChanged: onChanged,
    onSaved: onSaved,
    validator: validator,
    style: TextStyle(
      color: textColor,
      fontFamily: AppFonts.poppins,
      fontWeight: fontWeight,
    ),
    textCapitalization: textCapitalization,
    decoration: InputDecoration(
      labelText: lableText,
      hintText: placeholder,
      prefixIcon: prefixIcon,
      suffixIcon: sufficIcon,
      border: hideBorder && hideUnderline
          ? InputBorder.none
          : hideBorder
          ? UnderlineInputBorder(borderSide: BorderSide(color: borderColor))
          : OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              borderSide: BorderSide(color: borderColor),
            ),
      enabledBorder: hideBorder && hideUnderline
          ? InputBorder.none
          : hideBorder
          ? UnderlineInputBorder(borderSide: BorderSide(color: borderColor))
          : OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              borderSide: BorderSide(color: borderColor),
            ),
      focusedBorder: hideBorder && hideUnderline
          ? InputBorder.none
          : hideBorder
          ? UnderlineInputBorder(
              borderSide: BorderSide(color: focusBorderColor),
            )
          : OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              borderSide: BorderSide(color: focusBorderColor),
            ),
      errorBorder: hideBorder && hideUnderline
          ? InputBorder.none
          : hideBorder
          ? UnderlineInputBorder(
              borderSide: BorderSide(color: errorBorderColor),
            )
          : OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              borderSide: BorderSide(color: errorBorderColor),
            ),
      focusedErrorBorder: hideBorder && hideUnderline
          ? InputBorder.none
          : hideBorder
          ? UnderlineInputBorder(
              borderSide: BorderSide(color: errorBorderColor),
            )
          : OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              borderSide: BorderSide(color: errorBorderColor),
            ),
      contentPadding: EdgeInsets.symmetric(
        horizontal: paddindX,
        vertical: paddindY,
      ),
      hintStyle: TextStyle(color: placeholderColor),
      labelStyle: TextStyle(color: placeholderColor),
      errorStyle: TextStyle(color: errorBorderColor),
      errorMaxLines: 2,
      isDense: false,
      filled: false,
      fillColor: fillColor,
    ),
  );
}
