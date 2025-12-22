import 'package:flutter/material.dart';
import 'package:invoice_management_flutter_fe/constants/colors.dart';
import 'package:invoice_management_flutter_fe/widgets/heading_text.dart';

class Product {
  final String id;
  final String name;
  final String category;
  final int quantity;
  final double price;
  final String status;

  Product({
    required this.id,
    required this.name,
    required this.category,
    required this.quantity,
    required this.price,
    required this.status,
  });
}

class Inventory extends StatefulWidget {
  const Inventory({super.key});

  @override
  State<Inventory> createState() => _InventoryState();
}

class _InventoryState extends State<Inventory> {
  final List<Product> products = [
    Product(
      id: 'PRD001',
      name: 'Laptop Dell XPS 15',
      category: 'Electronics',
      quantity: 45,
      price: 1299.99,
      status: 'In Stock',
    ),
    Product(
      id: 'PRD002',
      name: 'Office Chair Ergonomic',
      category: 'Furniture',
      quantity: 8,
      price: 249.50,
      status: 'Low Stock',
    ),
    Product(
      id: 'PRD003',
      name: 'Wireless Mouse',
      category: 'Accessories',
      quantity: 150,
      price: 29.99,
      status: 'In Stock',
    ),
    Product(
      id: 'PRD004',
      name: 'Monitor 27" 4K',
      category: 'Electronics',
      quantity: 0,
      price: 449.00,
      status: 'Out of Stock',
    ),
    Product(
      id: 'PRD005',
      name: 'Desk Lamp LED',
      category: 'Accessories',
      quantity: 32,
      price: 39.99,
      status: 'In Stock',
    ),
    Product(
      id: 'PRD006',
      name: 'Keyboard Mechanical',
      category: 'Accessories',
      quantity: 5,
      price: 89.99,
      status: 'Low Stock',
    ),
  ];

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

  void _showAddProductDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add New Product'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Product Name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Category',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Quantity',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Price',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Product added successfully!')),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.white,
              ),
              child: const Text('Add Product'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                h1("Inventory"),
                ElevatedButton.icon(
                  onPressed: _showAddProductDialog,
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
                        itemCount: products.length,
                        itemBuilder: (context, index) {
                          final product = products[index];
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
                                _buildDataCell('${product.quantity}', flex: 1),
                                _buildDataCell(
                                  '\$${product.price.toStringAsFixed(2)}',
                                  flex: 1,
                                ),
                                _buildStatusCell(product.status, flex: 1),
                                _buildActionsCell(flex: 1),
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
          color: _getStatusColor(status).withOpacity(0.1),
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

  Widget _buildActionsCell({required int flex}) {
    return Expanded(
      flex: flex,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(Icons.edit, size: 18, color: AppColors.info),
            onPressed: () {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('Edit product')));
            },
            tooltip: 'Edit',
          ),
          IconButton(
            icon: Icon(Icons.delete, size: 18, color: AppColors.danger),
            onPressed: () {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('Delete product')));
            },
            tooltip: 'Delete',
          ),
        ],
      ),
    );
  }
}
