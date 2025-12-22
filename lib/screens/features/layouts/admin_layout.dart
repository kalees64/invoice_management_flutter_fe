import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:invoice_management_flutter_fe/constants/colors.dart';
import 'package:invoice_management_flutter_fe/screens/features/dashboard.dart';
import 'package:invoice_management_flutter_fe/screens/features/inventory.dart';
import 'package:invoice_management_flutter_fe/screens/features/widgets/admin_header.dart';
import 'package:invoice_management_flutter_fe/screens/features/widgets/admin_sidebar.dart';

// ignore: must_be_immutable
class AdminLayout extends StatefulWidget {
  AdminLayout({super.key, required this.initialPage});
  String initialPage = 'dashboard';

  @override
  State<AdminLayout> createState() => _AdminLayoutState();
}

class _AdminLayoutState extends State<AdminLayout> {
  final Map<String, Widget> _pages = {
    'dashboard': Dashboard(),
    'inventory': Inventory(),
  };

  late Widget _currentPage;
  late String _activeItem;

  void _handleSidebarItemTap(String item) {
    log("Clicked Menu : $item");
    setState(() {
      _currentPage = _pages[item]!;
      _activeItem = item;
    });
  }

  @override
  void initState() {
    super.initState();
    _currentPage = _pages[widget.initialPage]!;
    _activeItem = widget.initialPage;
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        width: width,
        height: height,
        color: AppColors.white,
        child: Column(
          children: [
            AdminHeader(),
            Container(
              height: height - (height * 0.09),
              color: AppColors.white,
              child: Row(
                children: [
                  Container(
                    width: width * 0.2,
                    color: AppColors.white,
                    child: AdminSidebar(
                      sidebarItems: _pages.keys.toList(),
                      activeItem: _activeItem,
                      onItemTap: _handleSidebarItemTap,
                    ),
                  ),
                  Expanded(child: _currentPage),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
