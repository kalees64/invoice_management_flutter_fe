import 'package:flutter/material.dart';
import 'package:invoice_management_flutter_fe/constants/colors.dart';
import 'package:invoice_management_flutter_fe/constants/font.dart';
import 'package:invoice_management_flutter_fe/widgets/heading_text.dart';

Widget dropdownInput<T>({
  required List<T> items,
  required String Function(T) itemLabel,
  T? value,
  T? initialValue,
  String placeholder = "Select option",
  String? labelText,
  Icon? prefixIcon,
  Widget? suffixIcon,
  bool hideBorder = false,
  bool hideUnderline = false,
  Color borderColor = AppColors.secondary,
  Color focusBorderColor = AppColors.primary,
  Color errorBorderColor = AppColors.danger,
  double borderRadius = 5,
  bool disabled = false,
  double paddingX = 10,
  double paddingY = 12,
  Color textColor = AppColors.black,
  Color placeholderColor = AppColors.grey,
  FontWeight fontWeight = FontWeight.w700,
  Function(T?)? onChanged,
  Function(T?)? onSaved,
  String? Function(T?)? validator,
}) {
  return DropdownButtonFormField<T>(
    initialValue: initialValue,
    onChanged: disabled ? null : onChanged,
    onSaved: onSaved,
    validator: validator,
    icon: suffixIcon ?? const Icon(Icons.keyboard_arrow_down),
    style: TextStyle(
      color: textColor,
      fontFamily: AppFonts.poppins,
      fontWeight: fontWeight,
    ),
    decoration: InputDecoration(
      labelText: labelText,
      hintText: placeholder,
      prefixIcon: prefixIcon,
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
        horizontal: paddingX,
        vertical: paddingY,
      ),
      hintStyle: TextStyle(color: placeholderColor),
      labelStyle: TextStyle(color: placeholderColor),
      errorStyle: TextStyle(color: errorBorderColor),
      errorMaxLines: 2,
    ),
    items: items.map((item) {
      return DropdownMenuItem<T>(
        value: item,
        child: text(itemLabel(item), fontWeight: fontWeight),
      );
    }).toList(),
  );
}
