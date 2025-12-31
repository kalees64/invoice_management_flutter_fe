import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:invoice_management_flutter_fe/constants/colors.dart';
import 'package:invoice_management_flutter_fe/models/user_model.dart';
import 'package:invoice_management_flutter_fe/screens/features/customers.dart';
import 'package:invoice_management_flutter_fe/screens/features/dashboard.dart';
import 'package:invoice_management_flutter_fe/screens/features/inventory.dart';
import 'package:invoice_management_flutter_fe/screens/features/pages/add_customer.dart';
import 'package:invoice_management_flutter_fe/screens/features/pages/add_product.dart';
import 'package:invoice_management_flutter_fe/screens/features/pages/edit_customer.dart';
import 'package:invoice_management_flutter_fe/screens/features/quotations.dart';
import 'package:invoice_management_flutter_fe/screens/features/widgets/admin_header.dart';
import 'package:invoice_management_flutter_fe/screens/features/widgets/admin_sidebar.dart';

// ignore: must_be_immutable
class AdminLayout extends StatefulWidget {
  AdminLayout({super.key, required this.initialPage, this.editUser});
  String initialPage = 'dashboard';
  UserModel? editUser;

  @override
  State<AdminLayout> createState() => _AdminLayoutState();
}

class _AdminLayoutState extends State<AdminLayout> {
  late Map<String, Map<String, Object>> _pages;
  late UserModel? editUser;

  final Map<String, Map<String, Object>> settingsMenus = {
    'settings': {
      'widget': Placeholder(),
      'icon': Icons.settings,
      'visible': true,
      'backButton': false,
    },
    'logout': {
      'widget': Placeholder(),
      'icon': Icons.logout,
      'visible': true,
      'backButton': false,
    },
  };

  late Widget _currentPage;
  late String _activeItem;

  void _handleSidebarItemTap(String item) {
    log("Clicked Menu : $item");
    setState(() {
      _currentPage = _pages[item]!['widget'] as Widget;
      _activeItem = item;
    });
  }

  @override
  void initState() {
    super.initState();
    editUser =
        widget.editUser ??
        UserModel(
          id: '',
          name: '',
          email: '',
          phone: '',
          address: '',
          city: '',
          state: '',
          country: '',
          pincode: '',
        );
    _pages = {
      'dashboard': {
        'widget': Dashboard(),
        'icon': Icons.dashboard,
        'visible': true,
        'backButton': false,
      },

      'customers': {
        'widget': Customers(),
        'icon': Icons.people,
        'visible': true,
        'backButton': false,
      },

      // INVENTORY FLOW
      'inventory': {
        'widget': Inventory(),
        'icon': Icons.inventory_2,
        'visible': true,
        'backButton': false,
      },

      // SALES FLOW
      'quotations': {
        'widget': Quotations(),
        'icon': Icons.request_quote,
        'visible': true,
        'backButton': false,
      },
      'invoices': {
        'widget': Placeholder(),
        'icon': Icons.receipt_long,
        'visible': true,
        'backButton': false,
      },
      'payments': {
        'widget': Placeholder(),
        'icon': Icons.payments,
        'visible': true,
        'backButton': false,
      },

      // SETTINGS
      'settings': {
        'widget': Placeholder(),
        'icon': Icons.settings,
        'visible': false,
        'backButton': false,
      },
      'logout': {
        'widget': Placeholder(),
        'icon': Icons.logout,
        'visible': false,
        'backButton': false,
      },

      // Add Procuct Page
      'add_product': {
        'widget': AddProduct(),
        'icon': Icons.add_box,
        'visible': false,
        'backButton': true,
      },

      // Add Customer Page
      'add_customer': {
        'widget': AddCustomer(),
        'icon': Icons.add_box,
        'visible': false,
        'backButton': true,
      },

      // Edit Customer Page
      'edit_customer': {
        'widget': EditCustomer(user: editUser!),
        'icon': Icons.edit,
        'visible': false,
        'backButton': true,
      },
    };

    _currentPage = _pages[widget.initialPage]!['widget'] as Widget;
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
        color: AppColors.transparent,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: width * 0.2,
              height: height,
              color: AppColors.sidebarBackground,
              child: AdminSidebar(
                sidebarItems: _pages,
                settingsMenus: settingsMenus,
                activeItem: _activeItem,
                onItemTap: _handleSidebarItemTap,
              ),
            ),
            Expanded(
              child: Container(
                color: AppColors.white,
                child: Column(
                  children: [
                    AdminHeader(
                      activePage: _activeItem,
                      backButton: _pages[_activeItem]!['backButton'] as bool,
                    ),
                    Expanded(child: _currentPage),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
