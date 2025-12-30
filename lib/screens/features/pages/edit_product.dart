import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:invoice_management_flutter_fe/constants/colors.dart';
import 'package:invoice_management_flutter_fe/models/product_model.dart';
import 'package:invoice_management_flutter_fe/providers/product_provider.dart';
import 'package:invoice_management_flutter_fe/utils/data/product_constants.dart';
import 'package:invoice_management_flutter_fe/utils/navigator.dart';
import 'package:invoice_management_flutter_fe/widgets/button.dart';
import 'package:invoice_management_flutter_fe/widgets/dropdown.dart';
import 'package:invoice_management_flutter_fe/widgets/heading_text.dart';
import 'package:invoice_management_flutter_fe/widgets/input.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class EditProduct extends StatefulWidget {
  final ProductModel product;
  const EditProduct({super.key, required this.product});

  @override
  State<EditProduct> createState() => _EditProductState();
}

class _EditProductState extends State<EditProduct> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _openingStockController = TextEditingController();
  final _minimumStockLevelController = TextEditingController();
  final _costPriceController = TextEditingController();
  final _sellingPriceController = TextEditingController();

  String selectedCategory = ProductConstants.categories[0];
  String selectedUnitOfMeasurement = ProductConstants.units[0];
  String? selectedStatus = ProductConstants.status[0];
  var uuid = const Uuid();
  bool _isLoading = false;

  void _onSave(BuildContext context) {
    startLoading();
    if (_formKey.currentState!.validate()) {
      ProductModel product = ProductModel(
        id: widget.product.id,
        name: _nameController.text,
        category: selectedCategory,
        unitOfMeasurement: selectedUnitOfMeasurement,
        openingStock: int.parse(_openingStockController.text),
        minimumStockLevel: int.parse(_minimumStockLevelController.text),
        costPrice: double.parse(_costPriceController.text),
        sellingPrice: double.parse(_sellingPriceController.text),
        status: selectedStatus!,
      );

      log(product.toString());
      Provider.of<ProductProvider>(
        context,
        listen: false,
      ).updateProduct(product);
      popPage(context);
    }
    stopLoading();
  }

  void startLoading() {
    setState(() {
      _isLoading = true;
    });
  }

  void stopLoading() {
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.product.name;
    _openingStockController.text = widget.product.openingStock.toString();
    _minimumStockLevelController.text = widget.product.minimumStockLevel
        .toString();
    _costPriceController.text = widget.product.costPrice.toString();
    _sellingPriceController.text = widget.product.sellingPrice.toString();
    selectedCategory = widget.product.category;
    selectedUnitOfMeasurement = widget.product.unitOfMeasurement;
    selectedStatus = widget.product.status;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _openingStockController.dispose();
    _minimumStockLevelController.dispose();
    _costPriceController.dispose();
    _sellingPriceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Container(
        width: double.infinity,
        padding: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 20,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    h1("Update Product"),
                    button(
                      "Close",
                      onPressed: () {
                        popPage(context);
                      },
                      width: 100,
                      height: 35,
                      paddingY: 0,
                      paddingX: 5,
                      fontSize: 14,
                      btnColor: AppColors.danger,
                      icon: Icons.close,
                    ),
                  ],
                ),

                Divider(),
                Row(
                  spacing: 15,
                  children: [
                    // Product Name
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          label("Product Name", required: true),
                          input(
                            placeholder: "Enter product name",
                            prefixIcon: Icon(
                              Icons.production_quantity_limits,
                              color: AppColors.primary,
                            ),
                            hideBorder: true,
                            controller: _nameController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Product name is required';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),

                    // Category
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          label("Category", required: true),
                          dropdownInput<String>(
                            items: ProductConstants.categories,
                            initialValue: selectedCategory,
                            itemLabel: (String item) {
                              return item;
                            },
                            hideBorder: true,
                            placeholder: "Select category",
                            prefixIcon: Icon(
                              Icons.category,
                              color: AppColors.primary,
                            ),
                            onChanged: (value) {
                              setState(() {
                                selectedCategory = value!;
                              });
                            },
                            validator: (value) {
                              if (value == null) {
                                return 'Category is required';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),

                    // Unit of Measurement
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          label("Unit of Measurement", required: true),
                          dropdownInput<String>(
                            items: ProductConstants.units,
                            initialValue: selectedUnitOfMeasurement,
                            itemLabel: (String item) {
                              return item;
                            },
                            hideBorder: true,
                            placeholder: "Select unit of measurement",
                            prefixIcon: Icon(
                              Icons.line_weight,
                              color: AppColors.primary,
                            ),
                            onChanged: (value) {
                              setState(() {
                                selectedUnitOfMeasurement = value!;
                              });
                            },
                            validator: (value) {
                              if (value == null) {
                                return 'Unit of measurement is required';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                Row(
                  spacing: 15,
                  children: [
                    // Opening Stock
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          label("Opening Stock", required: true),
                          input(
                            placeholder: "Enter opening stock",
                            prefixIcon: Icon(
                              Icons.inventory_2,
                              color: AppColors.primary,
                            ),
                            hideBorder: true,
                            controller: _openingStockController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Opening stock is required';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),

                    // Minimum Stock Level
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          label("Minimum Stock Level", required: true),
                          input(
                            placeholder: "Enter minimum stock level",
                            prefixIcon: Icon(
                              Icons.warning_amber,
                              color: AppColors.primary,
                            ),
                            hideBorder: true,
                            controller: _minimumStockLevelController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Minimum stock level is required';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),

                    // Cost Price
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          label("Cost Price", required: true),
                          input(
                            placeholder: "Enter cost price",
                            prefixIcon: Icon(
                              Icons.attach_money,
                              color: AppColors.primary,
                            ),
                            hideBorder: true,
                            controller: _costPriceController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Cost price is required';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                Row(
                  spacing: 15,
                  children: [
                    // Selling Price
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          label("Selling Price", required: true),
                          input(
                            placeholder: "Enter selling price",
                            prefixIcon: Icon(
                              Icons.attach_money,
                              color: AppColors.primary,
                            ),
                            hideBorder: true,
                            controller: _sellingPriceController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Selling price is required';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),

                    // Status
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          label("Status", required: true),
                          dropdownInput<String>(
                            items: ProductConstants.status,
                            initialValue: selectedStatus,
                            itemLabel: (String item) {
                              return item;
                            },
                            hideBorder: true,
                            placeholder: "Select status",
                            prefixIcon: Icon(
                              Icons.warning_amber,
                              color: AppColors.primary,
                            ),
                            onChanged: (value) {
                              setState(() {
                                selectedStatus = value!;
                              });
                            },
                            validator: (value) {
                              if (value == null) {
                                return 'Status is required';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),

                    Expanded(child: SizedBox()),
                  ],
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Flexible(
                      child: button(
                        "Save",
                        onPressed: () {
                          _onSave(context);
                        },
                        width: 150,
                        paddingY: 10,
                        btnColor: AppColors.success,
                        isLoading: _isLoading,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
