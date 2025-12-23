import 'package:flutter/material.dart';
import 'package:invoice_management_flutter_fe/constants/colors.dart';
import 'package:invoice_management_flutter_fe/screens/features/widgets/sidebar_menu_item.dart';
import 'package:invoice_management_flutter_fe/utils/helper.dart';
import 'package:invoice_management_flutter_fe/widgets/heading_text.dart';

class AdminSidebar extends StatelessWidget {
  final Map<String, Map<String, Object>> sidebarItems;
  final Map<String, Map<String, Object>> settingsMenus;
  final String activeItem;
  final Function(String) onItemTap;

  const AdminSidebar({
    super.key,
    required this.sidebarItems,
    required this.settingsMenus,
    required this.activeItem,
    required this.onItemTap,
  });

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Container(
      width: double.infinity,
      color: AppColors.transparent,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // App Name and Logo
          Container(
            padding: EdgeInsets.symmetric(vertical: 0, horizontal: 15),
            height: height * 0.09,
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: AppColors.sidebarMenuHighlight,
                  width: 2,
                ),
              ),
            ),
            child: Row(
              spacing: 10,
              children: [
                Container(
                  width: 30,
                  height: 30,
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Image.asset(
                    'assets/images/invoice-landing-logo.png',
                    width: 25,
                    height: 25,
                  ),
                ),
                h2("INVOICE MT", color: AppColors.white),
              ],
            ),
          ),

          // Sidebar Items
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: ListView(
                children: sidebarItems.entries
                    .where((entry) => entry.value['visible'] == true)
                    .map(
                      (entry) => sidebarMenuItem(
                        label: Helper.capitalizeFirstLetter(entry.key),
                        icon: entry.value['icon'] as IconData,
                        onTap: () => onItemTap(entry.key),
                        isActive: activeItem == entry.key,
                      ),
                    )
                    .toList(),
              ),
            ),
          ),

          // Settings
          Container(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: h3("Settings", color: AppColors.sidebarMenuColor),
                ),
                const SizedBox(height: 10),
                // Settings
                ...settingsMenus.entries.map(
                  (entry) => sidebarMenuItem(
                    label: Helper.capitalizeFirstLetter(entry.key),
                    icon: entry.value['icon'] as IconData,
                    isActive: activeItem == entry.key,
                    onTap: () => onItemTap(entry.key),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
