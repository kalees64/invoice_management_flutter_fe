import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:invoice_management_flutter_fe/constants/colors.dart';
import 'package:invoice_management_flutter_fe/models/supplier_model.dart';
import 'package:invoice_management_flutter_fe/providers/supplier_provider.dart';
import 'package:invoice_management_flutter_fe/screens/features/pages/add_supplier.dart';
import 'package:invoice_management_flutter_fe/utils/toaster.dart';
import 'package:invoice_management_flutter_fe/widgets/button.dart';
import 'package:invoice_management_flutter_fe/widgets/data_table.dart';
import 'package:invoice_management_flutter_fe/widgets/heading_text.dart';
import 'package:provider/provider.dart';

class SuppliersPage extends StatefulWidget {
  const SuppliersPage({super.key});

  @override
  State<SuppliersPage> createState() => _SuppliersPageState();
}

class _SuppliersPageState extends State<SuppliersPage> {
  @override
  void initState() {
    super.initState();
    Provider.of<SupplierProvider>(context, listen: false).getSuppliers();
  }

  List<TableColumnConfig> _buildColumns() {
    return [
      TableColumnConfig(fieldName: 'name', displayName: 'Name', bold: true),
      TableColumnConfig(fieldName: 'email', displayName: 'Email'),
      TableColumnConfig(fieldName: 'phone', displayName: 'Phone'),
      TableColumnConfig(
        fieldName: 'action',
        displayName: 'Action',
        customWidget: (value, index, rowData) {
          return _actionCell(value, index, rowData, context);
        },
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Container(
        padding: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  h1("Suppliers List"),
                  button(
                    "Add Supplier",
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (_) => Dialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Container(
                            padding: EdgeInsets.all(5),
                            child: AddSupplier(isUpdate: false),
                          ),
                        ),
                      );
                    },
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
                data: Provider.of<SupplierProvider>(
                  context,
                ).suppliers.map((e) => e.toJson()).toList(),
                showSerialNumber: true,
                serialNumberColumnName: 'S.No',
                rowsPerPage: 10,
                showSearch: true,
                searchHint: 'Search suppliers...',
              ),
            ],
          ),
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
            showDialog(
              context: context,
              builder: (_) => Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Container(
                  padding: EdgeInsets.all(5),
                  child: AddSupplier(
                    isUpdate: true,
                    supplier: SupplierModel.fromJson(rowData),
                  ),
                ),
              ),
            );
          },
        ),
        IconButton(
          icon: Icon(Icons.delete, size: 20, color: AppColors.danger),
          onPressed: () {
            log("User Id :  ${rowData["id"]}");
            Provider.of<SupplierProvider>(
              context,
              listen: false,
            ).deleteSupplier(rowData["id"]);
            Toaster.showSuccessToast(context, 'User deleted');
          },
        ),
      ],
    );
  }
}
