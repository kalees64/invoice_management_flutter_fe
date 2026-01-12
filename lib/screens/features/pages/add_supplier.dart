import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:invoice_management_flutter_fe/constants/colors.dart';
import 'package:invoice_management_flutter_fe/models/supplier_model.dart';
import 'package:invoice_management_flutter_fe/providers/supplier_provider.dart';
import 'package:invoice_management_flutter_fe/utils/navigator.dart';
import 'package:invoice_management_flutter_fe/widgets/button.dart';
import 'package:invoice_management_flutter_fe/widgets/heading_text.dart';
import 'package:invoice_management_flutter_fe/widgets/input.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

//ignore: must_be_immutable
class AddSupplier extends StatefulWidget {
  AddSupplier({super.key, required this.isUpdate, this.supplier});
  bool isUpdate = false;
  SupplierModel? supplier;

  @override
  State<AddSupplier> createState() => _AddSupplierState();
}

class _AddSupplierState extends State<AddSupplier> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _gstNoController = TextEditingController();
  final _panNoController = TextEditingController();
  bool _isLoading = false;
  var uuid = const Uuid();

  void _onSave(BuildContext context) {
    startLoading();
    if (_formKey.currentState!.validate()) {
      SupplierModel user = SupplierModel(
        id: widget.supplier?.id ?? uuid.v4(),
        name: _nameController.text,
        email: _emailController.text,
        phone: _phoneController.text,
        address: _addressController.text,
        gstin: _gstNoController.text,
        pan: _panNoController.text,
      );

      log(user.toJson().toString());

      if (widget.isUpdate) {
        Provider.of<SupplierProvider>(
          context,
          listen: false,
        ).updateSupplier(user);
      } else {
        Provider.of<SupplierProvider>(context, listen: false).addSupplier(user);
      }
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
    if (widget.isUpdate) {
      _nameController.text = widget.supplier!.name;
      _emailController.text = widget.supplier!.email;
      _phoneController.text = widget.supplier!.phone;
      _addressController.text = widget.supplier!.address;
      _gstNoController.text = widget.supplier!.gstin;
      _panNoController.text = widget.supplier!.pan;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _gstNoController.dispose();
    _panNoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Container(
        width: double.infinity,
        padding: EdgeInsetsGeometry.all(20),
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
                    h1("Add Supplier"),
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

                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 15,
                  children: [
                    // Name
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          label("Name", required: true),
                          input(
                            placeholder: "Enter name",
                            prefixIcon: Icon(
                              Icons.person,
                              color: AppColors.primary,
                            ),
                            hideBorder: true,
                            controller: _nameController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Name is required';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),

                    // Email
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          label("Email", required: true),
                          input(
                            placeholder: "Enter email",
                            prefixIcon: Icon(
                              Icons.email,
                              color: AppColors.primary,
                            ),
                            hideBorder: true,
                            controller: _emailController,
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
                        ],
                      ),
                    ),

                    // Phone
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          label("Phone", required: true),
                          input(
                            placeholder: "Enter phone",
                            prefixIcon: Icon(
                              Icons.phone,
                              color: AppColors.primary,
                            ),
                            hideBorder: true,
                            controller: _phoneController,
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
                        ],
                      ),
                    ),
                  ],
                ),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 15,
                  children: [
                    // Address
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          label("Address"),
                          input(
                            placeholder: "Enter address",
                            prefixIcon: Icon(
                              Icons.location_on,
                              color: AppColors.primary,
                            ),
                            hideBorder: true,
                            controller: _addressController,
                          ),
                        ],
                      ),
                    ),

                    // Pan
                    Expanded(
                      flex: 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          label("PAN No."),
                          input(
                            placeholder: "Enter PAN No.",
                            prefixIcon: Icon(
                              Icons.location_on,
                              color: AppColors.primary,
                            ),
                            hideBorder: true,
                            controller: _panNoController,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 15,
                  children: [
                    // GSTIN
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          label("GSTIN"),
                          input(
                            placeholder: "Enter GSTIN",
                            prefixIcon: Icon(
                              Icons.flag,
                              color: AppColors.primary,
                            ),
                            hideBorder: true,
                            controller: _gstNoController,
                          ),
                        ],
                      ),
                    ),
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
