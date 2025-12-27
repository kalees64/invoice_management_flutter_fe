import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:invoice_management_flutter_fe/constants/colors.dart';
import 'package:invoice_management_flutter_fe/screens/features/layouts/admin_layout.dart';
import 'package:invoice_management_flutter_fe/store/products/product_bloc.dart';
import 'package:invoice_management_flutter_fe/store/products/product_event.dart';
import 'package:invoice_management_flutter_fe/store/products/product_state.dart';
import 'package:invoice_management_flutter_fe/utils/navigator.dart';
import 'package:invoice_management_flutter_fe/utils/toaster.dart';
import 'package:invoice_management_flutter_fe/widgets/heading_text.dart';

class Inventory extends StatefulWidget {
  const Inventory({super.key});

  @override
  State<Inventory> createState() => _InventoryState();
}

class _InventoryState extends State<Inventory> {
  Color _getStatusColor(String status) {
    switch (status) {
      case 'In Stock':
        return AppColors.success;
      case 'Low Stock':
        return AppColors.warning;
      case 'Out of Stock':
        return AppColors.danger;
      default:
        return AppColors.grey;
    }
  }

  void _openAddProductPage() {
    pushToPage(context, AdminLayout(initialPage: 'add_product'));
    // pushToPage(context, AddProduct());
  }

  void _onDeleteProduct(String productId) {
    BlocProvider.of<ProductBloc>(context).add(DeleteProductEvent(productId));
    Toaster.showSuccessToast(context, 'Product deleted');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: BlocBuilder<ProductBloc, AddProductState>(
        builder: (context, state) => Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  h1("Products List"),
                  ElevatedButton.icon(
                    onPressed: _openAddProductPage,
                    icon: const Icon(Icons.add),
                    label: const Text('Add Product'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.light,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(12),
                            topRight: Radius.circular(12),
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        child: Row(
                          children: [
                            _buildHeaderCell('Product ID', flex: 1),
                            _buildHeaderCell('Product Name', flex: 2),
                            _buildHeaderCell('Category', flex: 2),
                            _buildHeaderCell('Quantity', flex: 1),
                            _buildHeaderCell('Price', flex: 1),
                            _buildHeaderCell('Status', flex: 1),
                            _buildHeaderCell('Actions', flex: 1),
                          ],
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: state.products.length,
                          itemBuilder: (context, index) {
                            final product = state.products[index];
                            return Container(
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: AppColors.light,
                                    width: 1,
                                  ),
                                ),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 16,
                              ),
                              child: Row(
                                children: [
                                  _buildDataCell(product.id, flex: 1),
                                  _buildDataCell(product.name, flex: 2),
                                  _buildDataCell(product.category, flex: 2),
                                  _buildDataCell(
                                    '${product.openingStock}',
                                    flex: 1,
                                  ),
                                  _buildDataCell(
                                    '\$${product.costPrice.toStringAsFixed(2)}',
                                    flex: 1,
                                  ),
                                  _buildStatusCell(product.status, flex: 1),
                                  _buildActionsCell(
                                    flex: 1,
                                    productId: product.id,
                                    onDelete: () =>
                                        _onDeleteProduct(product.id),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderCell(String text, {required int flex}) {
    return Expanded(
      flex: flex,
      child: Text(
        text,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: AppColors.dark,
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _buildDataCell(String text, {required int flex}) {
    return Expanded(
      flex: flex,
      child: Text(text, style: TextStyle(color: AppColors.dark, fontSize: 14)),
    );
  }

  Widget _buildStatusCell(String status, {required int flex}) {
    return Expanded(
      flex: flex,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: _getStatusColor(status).withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          status,
          style: TextStyle(
            color: _getStatusColor(status),
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildActionsCell({
    required int flex,
    required String productId,
    required VoidCallback onDelete,
  }) {
    return Expanded(
      flex: flex,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // IconButton(
          //   icon: Icon(Icons.edit, size: 18, color: AppColors.info),
          //   onPressed: () {
          //     ScaffoldMessenger.of(
          //       context,
          //     ).showSnackBar(const SnackBar(content: Text('Edit product')));
          //   },
          //   tooltip: 'Edit',
          // ),
          IconButton(
            icon: Icon(Icons.delete, size: 18, color: AppColors.danger),
            onPressed: () {
              onDelete();
            },
            tooltip: 'Delete',
          ),
        ],
      ),
    );
  }
}
