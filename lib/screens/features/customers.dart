import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:invoice_management_flutter_fe/constants/colors.dart';
import 'package:invoice_management_flutter_fe/models/user_model.dart';
import 'package:invoice_management_flutter_fe/providers/user_provider.dart';
import 'package:invoice_management_flutter_fe/screens/features/layouts/admin_layout.dart';
import 'package:invoice_management_flutter_fe/utils/navigator.dart';
import 'package:invoice_management_flutter_fe/utils/toaster.dart';
import 'package:invoice_management_flutter_fe/widgets/button.dart';
import 'package:invoice_management_flutter_fe/widgets/data_table.dart';
import 'package:invoice_management_flutter_fe/widgets/heading_text.dart';
import 'package:provider/provider.dart';

class Customers extends StatefulWidget {
  const Customers({super.key});

  @override
  State<Customers> createState() => _CustomersState();
}

class _CustomersState extends State<Customers> {
  void _navigateToAddCustomerPage() {
    pushToPage(context, AdminLayout(initialPage: 'add_customer'));
  }

  List<TableColumnConfig> _buildColumns() {
    return [
      TableColumnConfig(fieldName: 'name', displayName: 'Name', bold: true),
      TableColumnConfig(fieldName: 'email', displayName: 'Email'),
      TableColumnConfig(fieldName: 'phone', displayName: 'Phone'),
      TableColumnConfig(
        fieldName: 'actions',
        displayName: 'Actions',
        customWidget: (value, index, rowData) {
          return _actionCell(value, index, rowData, context);
        },
      ),
    ];
  }

  @override
  void initState() {
    super.initState();
    Provider.of<UserProvider>(context, listen: false).getUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsetsGeometry.all(20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                h1("Customers List"),
                button(
                  "Add Customer",
                  onPressed: _navigateToAddCustomerPage,
                  width: 160,
                  height: 35,
                  paddingY: 0,
                  paddingX: 5,
                  fontSize: 14,
                  icon: Icons.add,
                ),
              ],
            ),

            SizedBox(height: 20),

            ReusableDataTable(
              columns: _buildColumns(),
              data: Provider.of<UserProvider>(
                context,
                listen: true,
              ).users.map((e) => e.toJson()).toList(),
              showSerialNumber: true,
              serialNumberColumnName: 'S.No',
              rowsPerPage: 10,
              showSearch: true,
              searchHint: 'Search customers...',
            ),
          ],
        ),
      ),
    );
  }

  Widget _actionCell(
    dynamic value,
    int index,
    Map<String, dynamic> rowData,
    BuildContext context,
  ) {
    return Row(
      children: [
        IconButton(
          icon: Icon(Icons.edit, size: 20, color: AppColors.success),
          onPressed: () {
            pushToPage(
              context,
              AdminLayout(
                initialPage: 'edit_customer',
                editUser: UserModel.fromJson(rowData),
              ),
            );
          },
        ),
        IconButton(
          icon: Icon(Icons.delete, size: 20, color: AppColors.danger),
          onPressed: () {
            log("User Id :  ${rowData["id"]}");
            Provider.of<UserProvider>(
              context,
              listen: false,
            ).deleteUser(rowData["id"]);
            Toaster.showSuccessToast(context, 'User deleted');
          },
        ),
      ],
    );
  }
}
