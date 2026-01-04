import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:invoice_management_flutter_fe/constants/colors.dart';
import 'package:invoice_management_flutter_fe/models/product_model.dart';
import 'package:invoice_management_flutter_fe/models/quotation_model.dart';
import 'package:invoice_management_flutter_fe/models/user_model.dart';
import 'package:invoice_management_flutter_fe/providers/product_provider.dart';
import 'package:invoice_management_flutter_fe/providers/quotation_provider.dart';
import 'package:invoice_management_flutter_fe/providers/user_provider.dart';
import 'package:invoice_management_flutter_fe/utils/navigator.dart';
import 'package:invoice_management_flutter_fe/widgets/button.dart';
import 'package:invoice_management_flutter_fe/widgets/data_table.dart';
import 'package:invoice_management_flutter_fe/widgets/dropdown.dart';
import 'package:invoice_management_flutter_fe/widgets/heading_text.dart';
import 'package:invoice_management_flutter_fe/widgets/input.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class QuotationProduct {
  final ProductModel product;
  int quantity;
  double get total => product.sellingPrice * quantity;

  QuotationProduct({required this.product, required this.quantity});

  Map<String, dynamic> toJson() {
    return {'product': product.toJson(), 'quantity': quantity};
  }
}

class CreateQuotation extends StatefulWidget {
  const CreateQuotation({super.key});

  @override
  State<CreateQuotation> createState() => _CreateQuotationState();
}

class _CreateQuotationState extends State<CreateQuotation> {
  UserModel? selectedCustomer;
  List<QuotationProduct> quotationProducts = [];
  var uuid = const Uuid();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<UserProvider>(context, listen: false).getUsers();
      Provider.of<ProductProvider>(context, listen: false).getProducts();
    });
  }

  double get subtotal =>
      quotationProducts.fold(0, (sum, item) => sum + item.total);
  double get tax => subtotal * 0.18; // 18% tax
  double get grandTotal => subtotal + tax;

  void _showCustomerSearchDialog() {
    showDialog(
      context: context,
      builder: (context) => _CustomerSearchDialog(
        onCustomerSelected: (customer) {
          setState(() {
            selectedCustomer = customer;
          });
        },
      ),
    );
  }

  void _showNewCustomerDialog() {
    showDialog(
      context: context,
      builder: (context) => _NewCustomerDialog(
        onCustomerCreated: (customer) {
          setState(() {
            selectedCustomer = customer;
          });
        },
      ),
    );
  }

  void _showAddProductDialog() {
    showDialog(
      context: context,
      builder: (context) => _AddProductDialog(
        onProductAdded: (product, quantity) {
          setState(() {
            quotationProducts.add(
              QuotationProduct(product: product, quantity: quantity),
            );
          });
        },
      ),
    );
  }

  void _editProduct(int index) {
    showDialog(
      context: context,
      builder: (context) => _EditProductDialog(
        quotationProduct: quotationProducts[index],
        onQuantityChanged: (newQuantity) {
          setState(() {
            quotationProducts[index].quantity = newQuantity;
          });
        },
      ),
    );
  }

  void _deleteProduct(int index) {
    setState(() {
      quotationProducts.removeAt(index);
    });
  }

  void _saveQuotationAsDraft(BuildContext context) {
    final quotation = QuotationModel(
      id: uuid.v4(),
      quotationNo:
          'QTN-${context.read<QuotationProvider>().quotations.length + 1}',
      revisionNo: 1,
      customer: selectedCustomer!,
      products: quotationProducts.map((e) => e.product).toList(),
      total: grandTotal,
      status: 'DRAFT',
      date: DateTime.now(),
    );

    log(quotation.toJson().toString());
    Provider.of<QuotationProvider>(
      context,
      listen: false,
    ).addQuotation(quotation);
    popPage(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  h1("Create Quotation"),
                  button(
                    "Close",
                    onPressed: () => popPage(context),
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
              SizedBox(height: 10),

              // Customer Section
              h2("Customer Information"),
              SizedBox(height: 15),

              if (selectedCustomer == null) ...[
                Row(
                  children: [
                    Expanded(
                      child: button(
                        "Add Existing Customer",
                        onPressed: _showCustomerSearchDialog,
                        icon: Icons.search,
                        btnColor: AppColors.primary,
                      ),
                    ),
                    SizedBox(width: 15),
                    Expanded(
                      child: button(
                        "New Customer",
                        onPressed: _showNewCustomerDialog,
                        icon: Icons.person_add,
                        btnColor: AppColors.success,
                      ),
                    ),
                  ],
                ),
              ] else ...[
                Container(
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            h2(selectedCustomer!.name),
                            SizedBox(height: 5),
                            text(selectedCustomer!.email),
                            text(selectedCustomer!.phone),
                            text(
                              "${selectedCustomer!.address}, ${selectedCustomer!.city}",
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.edit, color: AppColors.primary),
                        onPressed: () {
                          setState(() {
                            selectedCustomer = null;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ],

              SizedBox(height: 30),

              // Products Section
              if (selectedCustomer != null) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    h2("Products"),
                    button(
                      "Add Product",
                      onPressed: _showAddProductDialog,
                      icon: Icons.add,
                      btnColor: AppColors.success,
                      width: 150,
                      height: 35,
                      paddingY: 0,
                      fontSize: 14,
                    ),
                  ],
                ),
                SizedBox(height: 15),

                if (quotationProducts.isEmpty)
                  Container(
                    padding: EdgeInsets.all(30),
                    alignment: Alignment.center,
                    child: h3("No products added yet", color: AppColors.grey),
                  )
                else
                  _buildProductsTable(),

                SizedBox(height: 30),

                // Totals Section
                if (quotationProducts.isNotEmpty) _buildTotalsSection(),

                SizedBox(height: 30),

                // Action Buttons
                if (quotationProducts.isNotEmpty)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SizedBox(width: 15),
                      button(
                        "Save As Draft",
                        onPressed: () {
                          _saveQuotationAsDraft(context);
                        },
                        btnColor: AppColors.primary,
                        width: 180,
                      ),
                    ],
                  ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProductsTable() {
    List<TableColumnConfig> columns = [
      TableColumnConfig(
        fieldName: 'name',
        displayName: 'Name',
        bold: true,
        customWidget: (value, index, rowData) {
          final product = rowData['product'] as Map<String, dynamic>;
          return text(product['name'] ?? '-');
        },
      ),
      TableColumnConfig(fieldName: 'quantity', displayName: 'Quantity'),
      TableColumnConfig(
        fieldName: 'price',
        displayName: 'Price',
        customWidget: (value, index, rowData) {
          final product = rowData['product'] as Map<String, dynamic>;
          return text('₹${product['sellingPrice']}');
        },
      ),
      TableColumnConfig(
        fieldName: 'total',
        displayName: 'Total',
        customWidget: (value, index, rowData) {
          final product = rowData['product'] as Map<String, dynamic>;
          final quantity = rowData['quantity'] as int;
          return text('₹${product['sellingPrice'] * quantity}');
        },
      ),
      TableColumnConfig(
        fieldName: 'actions',
        displayName: 'Actions',
        customWidget: (value, index, rowData) => Row(
          children: [
            IconButton(
              icon: Icon(Icons.edit, size: 18, color: AppColors.info),
              onPressed: () {
                _editProduct(index);
              },
              tooltip: 'Edit',
            ),
            IconButton(
              icon: Icon(Icons.delete, size: 18, color: AppColors.danger),
              onPressed: () {
                _deleteProduct(index);
              },
              tooltip: 'Delete',
            ),
          ],
        ),
      ),
    ];

    return ReusableDataTable(
      columns: columns,
      data: quotationProducts.map((QuotationProduct e) => e.toJson()).toList(),
      showSerialNumber: true,
      serialNumberColumnName: 'S.No',
      rowsPerPage: 10,
      showSearch: false,
      showPagination: false,
    );
  }

  Widget _buildTotalsSection() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        children: [
          _buildTotalRow("Subtotal", subtotal),
          SizedBox(height: 10),
          _buildTotalRow("Tax (18%)", tax),
          Divider(thickness: 2),
          _buildTotalRow("Grand Total", grandTotal, isBold: true, fontSize: 18),
        ],
      ),
    );
  }

  Widget _buildTotalRow(
    String label,
    double amount, {
    bool isBold = false,
    double fontSize = 16,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [h3(label), h3("₹${amount.toStringAsFixed(2)}")],
    );
  }
}

// Customer Search Dialog
class _CustomerSearchDialog extends StatefulWidget {
  final Function(UserModel) onCustomerSelected;

  const _CustomerSearchDialog({required this.onCustomerSelected});

  @override
  State<_CustomerSearchDialog> createState() => _CustomerSearchDialogState();
}

class _CustomerSearchDialogState extends State<_CustomerSearchDialog> {
  String searchQuery = "";

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: 600,
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            h2("Select Customer"),
            SizedBox(height: 20),
            // TextField(
            //   decoration: InputDecoration(
            //     hintText: "Search customer...",
            //     prefixIcon: Icon(Icons.search),
            //     border: OutlineInputBorder(
            //       borderRadius: BorderRadius.circular(8),
            //     ),
            //   ),
            //   onChanged: (value) {
            //     setState(() {
            //       searchQuery = value.toLowerCase();
            //     });
            //   },
            // ),
            input(
              placeholder: "Search customer...",
              prefixIcon: Icon(Icons.search),
              hideBorder: true,
              onChanged: (value) {
                setState(() {
                  searchQuery = value.toLowerCase();
                });
              },
            ),
            SizedBox(height: 15),
            Consumer<UserProvider>(
              builder: (context, userProvider, child) {
                final filteredUsers = userProvider.users
                    .where(
                      (user) =>
                          user.name.toLowerCase().contains(searchQuery) ||
                          user.email.toLowerCase().contains(searchQuery) ||
                          user.phone.contains(searchQuery),
                    )
                    .toList();

                if (filteredUsers.isEmpty) {
                  return Container(
                    constraints: BoxConstraints(maxHeight: 400),
                    child: Column(
                      children: [
                        h3("No customers found"),
                        SizedBox(height: 10),
                        button(
                          "Add Customer",
                          onPressed: () {
                            Navigator.pop(context);
                            showDialog(
                              context: context,
                              builder: (context) => _NewCustomerDialog(
                                onCustomerCreated: (customer) {
                                  widget.onCustomerSelected(customer);
                                  Navigator.pop(context);
                                },
                              ),
                            );
                          },
                          width: 150,
                          height: 35,
                          paddingY: 0,
                          paddingX: 5,
                          fontSize: 14,
                          icon: Icons.add,
                        ),
                      ],
                    ),
                  );
                }

                return Container(
                  constraints: BoxConstraints(maxHeight: 400),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: filteredUsers.length,
                    itemBuilder: (context, index) {
                      final user = filteredUsers[index];
                      return ListTile(
                        title: h3(user.name),
                        subtitle: text("${user.email} | ${user.phone}"),
                        onTap: () {
                          widget.onCustomerSelected(user);
                          Navigator.pop(context);
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        hoverColor: AppColors.light,
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

// New Customer Dialog
class _NewCustomerDialog extends StatefulWidget {
  final Function(UserModel) onCustomerCreated;

  const _NewCustomerDialog({required this.onCustomerCreated});

  @override
  State<_NewCustomerDialog> createState() => _NewCustomerDialogState();
}

class _NewCustomerDialogState extends State<_NewCustomerDialog> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  final cityController = TextEditingController();
  final stateController = TextEditingController();
  final countryController = TextEditingController();
  final pincodeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: 600,
        padding: EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                h2("Create New Customer"),
                SizedBox(height: 20),
                input(
                  placeholder: "Enter name",
                  prefixIcon: Icon(Icons.person, color: AppColors.primary),
                  hideBorder: true,
                  controller: nameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Name is required';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 15),
                input(
                  placeholder: "Enter email",
                  prefixIcon: Icon(Icons.email, color: AppColors.primary),
                  hideBorder: true,
                  controller: emailController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Email is required';
                    }
                    if (!value.contains('@')) {
                      return 'Please enter a valid email address';
                    }
                    if (!value.contains('.')) {
                      return 'Please enter a valid email address';
                    }
                    if (value.length < 5) {
                      return 'Please enter a valid email address';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 15),
                input(
                  placeholder: "Enter phone",
                  prefixIcon: Icon(Icons.phone, color: AppColors.primary),
                  hideBorder: true,
                  controller: phoneController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Phone is required';
                    }
                    if (value.length < 10) {
                      return 'Phone number should be 10 digits';
                    }
                    if (value.length > 10) {
                      return 'Phone number should be 10 digits';
                    }
                    if (value.startsWith('0')) {
                      return 'Phone number should not start with 0';
                    }
                    if (!value.contains(RegExp(r'[0-9]'))) {
                      return 'Do not use any special characters';
                    }
                    if (value.contains(RegExp(r'[a-zA-Z]'))) {
                      return 'Do not use any alphabets';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 15),
                input(
                  placeholder: "Enter address",
                  prefixIcon: Icon(Icons.location_on, color: AppColors.primary),
                  hideBorder: true,
                  controller: addressController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Address is required';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 15),
                Row(
                  children: [
                    Expanded(
                      child: input(
                        placeholder: "Enter city",
                        prefixIcon: Icon(
                          Icons.location_city,
                          color: AppColors.primary,
                        ),
                        hideBorder: true,
                        controller: cityController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'City is required';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(width: 15),
                    Expanded(
                      child: input(
                        placeholder: "Enter state",
                        prefixIcon: Icon(Icons.flag, color: AppColors.primary),
                        hideBorder: true,
                        controller: stateController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'State is required';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 15),
                Row(
                  children: [
                    Expanded(
                      child: input(
                        placeholder: "Enter country",
                        prefixIcon: Icon(Icons.flag, color: AppColors.primary),
                        hideBorder: true,
                        controller: countryController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Country is required';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(width: 15),
                    Expanded(
                      child: input(
                        placeholder: "Enter pincode",
                        prefixIcon: Icon(
                          Icons.location_on,
                          color: AppColors.primary,
                        ),
                        hideBorder: true,
                        controller: pincodeController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Pincode is required';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 25),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: text("Cancel"),
                    ),
                    SizedBox(width: 10),

                    Flexible(
                      child: button(
                        "Create Customer",
                        width: 150,
                        btnColor: AppColors.success,
                        paddingY: 10,
                        height: 40,
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            final newCustomer = UserModel(
                              name: nameController.text,
                              email: emailController.text,
                              phone: phoneController.text,
                              address: addressController.text,
                              city: cityController.text,
                              state: stateController.text,
                              country: countryController.text,
                              pincode: pincodeController.text,
                            );
                            Provider.of<UserProvider>(
                              context,
                              listen: false,
                            ).addUser(newCustomer);
                            widget.onCustomerCreated(newCustomer);
                            Navigator.pop(context);
                          }
                        },
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

// Add Product Dialog
class _AddProductDialog extends StatefulWidget {
  final Function(ProductModel, int) onProductAdded;

  const _AddProductDialog({required this.onProductAdded});

  @override
  State<_AddProductDialog> createState() => _AddProductDialogState();
}

class _AddProductDialogState extends State<_AddProductDialog> {
  ProductModel? selectedProduct;
  final quantityController = TextEditingController(text: "1");

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: 500,
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            h2("Add Product"),
            SizedBox(height: 20),
            Consumer<ProductProvider>(
              builder: (context, productProvider, child) {
                // return DropdownButtonFormField<ProductModel>(
                //   decoration: InputDecoration(
                //     labelText: "Select Product",
                //     border: OutlineInputBorder(
                //       borderRadius: BorderRadius.circular(8),
                //     ),
                //   ),
                //   value: selectedProduct,
                //   items: productProvider.products
                //       .map(
                //         (product) => DropdownMenuItem(
                //           value: product,
                //           child: Text(product.name),
                //         ),
                //       )
                //       .toList(),
                //   onChanged: (value) {
                //     setState(() {
                //       selectedProduct = value;
                //     });
                //   },
                // );
                return dropdownInput(
                  items: productProvider.products,
                  itemLabel: (ProductModel item) {
                    return item.name;
                  },
                  initialValue: selectedProduct,
                  placeholder: "Select product",
                  prefixIcon: Icon(
                    Icons.production_quantity_limits,
                    color: AppColors.primary,
                  ),
                  onChanged: (value) {
                    if (value == null) return;
                    setState(() {
                      selectedProduct = value;
                    });
                  },
                  hideBorder: true,
                );
              },
            ),
            SizedBox(height: 15),
            input(
              placeholder: "Enter quantity",
              prefixIcon: Icon(Icons.inventory_2, color: AppColors.primary),
              hideBorder: true,
              controller: quantityController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Quantity is required';
                }
                return null;
              },
            ),
            SizedBox(height: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: text("Cancel"),
                ),
                SizedBox(width: 10),
                button(
                  "Add Product",
                  onPressed: () {
                    if (selectedProduct != null &&
                        quantityController.text.isNotEmpty) {
                      widget.onProductAdded(
                        selectedProduct!,
                        int.parse(quantityController.text),
                      );
                      Navigator.pop(context);
                    }
                  },
                  width: 150,
                  btnColor: AppColors.success,
                  paddingY: 10,
                  height: 40,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Edit Product Dialog
class _EditProductDialog extends StatefulWidget {
  final QuotationProduct quotationProduct;
  final Function(int) onQuantityChanged;

  const _EditProductDialog({
    required this.quotationProduct,
    required this.onQuantityChanged,
  });

  @override
  State<_EditProductDialog> createState() => _EditProductDialogState();
}

class _EditProductDialogState extends State<_EditProductDialog> {
  late TextEditingController quantityController;

  @override
  void initState() {
    super.initState();
    quantityController = TextEditingController(
      text: widget.quotationProduct.quantity.toString(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: 400,
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            h2("Edit Quantity"),
            SizedBox(height: 20),
            h3("Product: ${widget.quotationProduct.product.name}"),
            SizedBox(height: 15),
            input(
              placeholder: "Enter quantity",
              prefixIcon: Icon(Icons.inventory_2, color: AppColors.primary),
              hideBorder: true,
              controller: quantityController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Quantity is required';
                }
                return null;
              },
            ),
            SizedBox(height: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: text("Cancel"),
                ),
                SizedBox(width: 10),
                button(
                  "Update",
                  onPressed: () {
                    if (quantityController.text.isNotEmpty) {
                      widget.onQuantityChanged(
                        int.parse(quantityController.text),
                      );
                      Navigator.pop(context);
                    }
                  },
                  width: 100,
                  btnColor: AppColors.success,
                  paddingY: 10,
                  height: 40,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
