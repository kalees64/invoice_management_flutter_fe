import 'package:flutter/material.dart';
import 'package:invoice_management_flutter_fe/constants/colors.dart';
import 'package:invoice_management_flutter_fe/widgets/heading_text.dart';

class AdminSidebar extends StatelessWidget {
  final List<String> sidebarItems;
  final String activeItem;
  final Function(String) onItemTap;

  const AdminSidebar({
    super.key,
    required this.sidebarItems,
    required this.activeItem,
    required this.onItemTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: sidebarItems.map((item) {
        final bool isActive = item == activeItem;

        return Container(
          color: isActive ? AppColors.secondary : AppColors.white,
          child: ListTile(
            title: h3(
              item.toUpperCase(),
              color: isActive ? AppColors.white : AppColors.black,
            ),
            onTap: () {
              onItemTap(item);
            },
          ),
        );
      }).toList(),
    );
  }
}
