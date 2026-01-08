import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:invoice_management_flutter_fe/constants/colors.dart';
import 'package:invoice_management_flutter_fe/models/product_model.dart';
import 'package:invoice_management_flutter_fe/providers/product_provider.dart';
import 'package:invoice_management_flutter_fe/screens/features/layouts/admin_layout.dart';
import 'package:invoice_management_flutter_fe/screens/features/pages/edit_product.dart';
import 'package:invoice_management_flutter_fe/utils/navigator.dart';
import 'package:invoice_management_flutter_fe/utils/toaster.dart';
import 'package:invoice_management_flutter_fe/widgets/button.dart';
import 'package:invoice_management_flutter_fe/widgets/data_table.dart';
import 'package:invoice_management_flutter_fe/widgets/heading_text.dart';
import 'package:provider/provider.dart';

class Inventory extends StatefulWidget {
  const Inventory({super.key});

  @override
  State<Inventory> createState() => _InventoryState();
}

class _InventoryState extends State<Inventory> {
  void _navigateToAddProductPage() {
    pushToPage(context, AdminLayout(initialPage: 'add_product'));
  }

  List<TableColumnConfig> _buildColumns() {
    return [
      TableColumnConfig(fieldName: 'name', displayName: 'Name', bold: true),
      TableColumnConfig(fieldName: 'category', displayName: 'Category'),
      TableColumnConfig(fieldName: 'unitOfMeasurement', displayName: 'Unit'),
      TableColumnConfig(fieldName: 'openingStock', displayName: 'Stock'),
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
  void initState() {
    super.initState();
    Provider.of<ProductProvider>(context, listen: false).getProducts();
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
                  h1("Product List"),
                  button(
                    "Add Product",
                    onPressed: _navigateToAddProductPage,
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
                data: Provider.of<ProductProvider>(
                  context,
                ).products.map((e) => e.toJson()).toList(),
                showSerialNumber: true,
                serialNumberColumnName: 'S.No',
                rowsPerPage: 10,
                showSearch: true,
                searchHint: 'Search customers...',
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
            log("Edit ${rowData['id']}");
            showDialog(
              context: context,
              builder: (context) {
                return Dialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Container(
                    padding: EdgeInsets.all(5),
                    child: EditProduct(product: ProductModel.fromJson(rowData)),
                  ),
                );
              },
            );
          },
        ),
        IconButton(
          icon: Icon(Icons.delete, size: 20, color: AppColors.danger),
          onPressed: () {
            log('Delete ${rowData['id']}');
            Provider.of<ProductProvider>(
              context,
              listen: false,
            ).deleteProduct(rowData['id']);
            Toaster.showSuccessToast(context, "Product deleted successfully");
          },
        ),
      ],
    );
  }
}
