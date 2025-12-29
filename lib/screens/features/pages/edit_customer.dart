import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:invoice_management_flutter_fe/constants/colors.dart';
import 'package:invoice_management_flutter_fe/models/user_model.dart';
import 'package:invoice_management_flutter_fe/store/user/user_bloc.dart';
import 'package:invoice_management_flutter_fe/store/user/user_event.dart';
import 'package:invoice_management_flutter_fe/utils/navigator.dart';
import 'package:invoice_management_flutter_fe/widgets/button.dart';
import 'package:invoice_management_flutter_fe/widgets/heading_text.dart';
import 'package:invoice_management_flutter_fe/widgets/input.dart';

class EditCustomer extends StatefulWidget {
  final UserModel user;
  const EditCustomer({super.key, required this.user});

  @override
  State<EditCustomer> createState() => _EditCustomerState();
}

class _EditCustomerState extends State<EditCustomer> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _countryController = TextEditingController();
  final _pincodeController = TextEditingController();
  bool _isLoading = false;

  void _onSave(BuildContext context) {
    startLoading();
    if (_formKey.currentState!.validate()) {
      UserModel user = UserModel(
        id: widget.user.id,
        name: _nameController.text,
        email: _emailController.text,
        phone: _phoneController.text,
        address: _addressController.text,
        city: _cityController.text,
        state: _stateController.text,
        country: _countryController.text,
        pincode: _pincodeController.text,
      );

      log(user.toJson().toString());
      BlocProvider.of<UserBloc>(
        context,
      ).add(UpdateUserEvent(user.id!, user.toJson()));
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
    _nameController.text = widget.user.name;
    _emailController.text = widget.user.email;
    _phoneController.text = widget.user.phone;
    _addressController.text = widget.user.address;
    _cityController.text = widget.user.city;
    _stateController.text = widget.user.state;
    _countryController.text = widget.user.country;
    _pincodeController.text = widget.user.pincode;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _countryController.dispose();
    _pincodeController.dispose();
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
                          label("Address", required: true),
                          input(
                            placeholder: "Enter address",
                            prefixIcon: Icon(
                              Icons.location_on,
                              color: AppColors.primary,
                            ),
                            hideBorder: true,
                            controller: _addressController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Address is required';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),

                    // Pincode
                    Expanded(
                      flex: 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          label("Pincode", required: true),
                          input(
                            placeholder: "Enter pincode",
                            prefixIcon: Icon(
                              Icons.location_on,
                              color: AppColors.primary,
                            ),
                            hideBorder: true,
                            controller: _pincodeController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Pincode is required';
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
                    // City
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          label("City", required: true),
                          input(
                            placeholder: "Enter city",
                            prefixIcon: Icon(
                              Icons.location_city,
                              color: AppColors.primary,
                            ),
                            hideBorder: true,
                            controller: _cityController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'City is required';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),

                    // State
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          label("State", required: true),
                          input(
                            placeholder: "Enter state",
                            prefixIcon: Icon(
                              Icons.flag,
                              color: AppColors.primary,
                            ),
                            hideBorder: true,
                            controller: _stateController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'State is required';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),

                    // Country
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          label("Country", required: true),
                          input(
                            placeholder: "Enter country",
                            prefixIcon: Icon(
                              Icons.flag,
                              color: AppColors.primary,
                            ),
                            hideBorder: true,
                            controller: _countryController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Country is required';
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
