import 'package:flutter/material.dart';
import 'package:invoice_management_flutter_fe/constants/colors.dart';
import 'package:invoice_management_flutter_fe/widgets/heading_text.dart';

Widget sidebarMenuItem({
  required String label,
  required IconData icon,
  required VoidCallback onTap,
  bool isActive = false,
}) {
  return InkWell(
    onTap: onTap,
    child: Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: isActive
            ? AppColors.sidebarMenuHighlight
            : AppColors.transparent,
      ),
      child: Row(
        spacing: 10,
        children: [
          Icon(
            icon,
            color: isActive ? AppColors.white : AppColors.sidebarMenuColor,
            size: 20,
          ),
          h3(
            label,
            color: isActive ? AppColors.white : AppColors.sidebarMenuColor,
          ),
        ],
      ),
    ),
  );
}
