import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:invoice_management_flutter_fe/constants/colors.dart';
import 'package:invoice_management_flutter_fe/models/supplier_product_model.dart';
import 'package:invoice_management_flutter_fe/providers/supplier_product_provider.dart';
import 'package:invoice_management_flutter_fe/providers/supplier_provider.dart';
import 'package:invoice_management_flutter_fe/screens/features/pages/add_supplier_product.dart';
import 'package:invoice_management_flutter_fe/utils/toaster.dart';
import 'package:invoice_management_flutter_fe/widgets/button.dart';
import 'package:invoice_management_flutter_fe/widgets/data_table.dart';
import 'package:invoice_management_flutter_fe/widgets/heading_text.dart';
import 'package:provider/provider.dart';

class SupplierProducts extends StatefulWidget {
  const SupplierProducts({super.key});

  @override
  State<SupplierProducts> createState() => _SupplierProductsState();
}

class _SupplierProductsState extends State<SupplierProducts> {
  @override
  void initState() {
    super.initState();
    Provider.of<SupplierProductProvider>(
      context,
      listen: false,
    ).getSupplierProducts();
    context.read<SupplierProvider>().getSuppliers();
  }

  List<TableColumnConfig> _buildColumns() {
    return [
      TableColumnConfig(fieldName: 'name', displayName: 'Name', bold: true),
      TableColumnConfig(
        fieldName: 'supplier',
        displayName: 'Supplier',
        customWidget: (value, index, rowData) {
          final supplier = rowData['supplier'] as Map<String, dynamic>;
          return text(supplier['name'] ?? '-');
        },
      ),
      TableColumnConfig(fieldName: 'category', displayName: 'Category'),

      TableColumnConfig(
        fieldName: 'openingStock',
        displayName: 'Opening Stock',
      ),
      TableColumnConfig(fieldName: 'costPrice', displayName: 'Cost Price'),
      TableColumnConfig(
        fieldName: 'sellingPrice',
        displayName: 'Selling Price',
      ),
      TableColumnConfig(fieldName: 'status', displayName: 'Status'),
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
                  h1("Supplier Products List"),
                  button(
                    "Add Supplier Product",
                    onPressed: () {
                      showDialog(
                        context: context,
                        useRootNavigator: false,
                        useSafeArea: true,
                        builder: (_) => Dialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Container(
                            padding: EdgeInsets.all(5),
                            child: AddSupplierProduct(isUpdate: false),
                          ),
                        ),
                      );
                    },
                    width: 200,
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
                data: Provider.of<SupplierProductProvider>(
                  context,
                ).supplierProducts.map((e) => e.toJson()).toList(),
                showSerialNumber: true,
                serialNumberColumnName: 'S.No',
                rowsPerPage: 10,
                showSearch: true,
                searchHint: 'Search supplier products...',
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
                  child: AddSupplierProduct(
                    isUpdate: true,
                    supplierProduct: SupplierProductModel.fromJson(rowData),
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
            Provider.of<SupplierProductProvider>(
              context,
              listen: false,
            ).deleteSupplierProduct(rowData["id"]);
            Toaster.showSuccessToast(context, 'User deleted');
          },
        ),
      ],
    );
  }
}
