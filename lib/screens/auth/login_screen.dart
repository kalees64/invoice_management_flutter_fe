import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:invoice_management_flutter_fe/constants/colors.dart';
import 'package:invoice_management_flutter_fe/screens/features/dashboard.dart';
import 'package:invoice_management_flutter_fe/utils/navigator.dart';
import 'package:invoice_management_flutter_fe/utils/toaster.dart';
import 'package:invoice_management_flutter_fe/widgets/button.dart';
import 'package:invoice_management_flutter_fe/widgets/heading_text.dart';
import 'package:invoice_management_flutter_fe/widgets/input.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _loginFormKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isLoading = false;

  void _handleFormSubmit() {
    setState(() {
      _isLoading = true;
    });
    if (_loginFormKey.currentState!.validate()) {
      // Form is valid, perform login
      final String email = _emailController.text;
      final String password = _passwordController.text;
      log("Email : $email Password : $password");

      if (email == 'admin@gmail.com' && password == 'admin123') {
        log("Login Success");
        pushToPage(context, Dashboard());
      } else {
        log("Login Failed");
        Toaster.showErrorToast(context, "Invalid credentials");
      }

      _stopLoading();
      return;
    }
    _stopLoading(seconds: 1);
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    if (!value.contains('@')) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  void _togglePasswordVisibility() {
    setState(() {
      _isPasswordVisible = !_isPasswordVisible;
    });
  }

  void _stopLoading({int seconds = 2}) {
    Future.delayed(Duration(seconds: seconds), () {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        width: width,
        height: height,
        color: Colors.white,
        child: Row(
          children: [
            Container(
              width: width * 0.5,
              height: height,
              decoration: BoxDecoration(
                color: Colors.blue,
                image: DecorationImage(
                  image: AssetImage(
                    'assets/images/login_page_illustration.png',
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
              width: width * 0.5,
              height: height * 0.8,
              color: Colors.white,
              child: Padding(
                padding: EdgeInsetsGeometry.all(20),
                child: Container(
                  padding: EdgeInsets.all(40),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      h1("Welcome Back!", fontSize: 40),
                      SizedBox(height: 10),
                      text(
                        "Log in to manage invoices, quotations, inventory, and payments seamlessly.",
                        color: Colors.blueGrey,
                      ),

                      SizedBox(height: 40),
                      Form(
                        key: _loginFormKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          spacing: 10,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                label("Email", required: true),
                                input(
                                  controller: _emailController,
                                  placeholder: "abc@gmail.com",
                                  prefixIcon: Icon(
                                    Icons.email,
                                    color: AppColors.primary,
                                  ),
                                  hideBorder: true,
                                  validator: _validateEmail,
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                label("Password", required: true),
                                input(
                                  controller: _passwordController,
                                  placeholder: "Enter your password",
                                  prefixIcon: Icon(
                                    Icons.lock,
                                    color: AppColors.primary,
                                  ),
                                  sufficIcon: InkWell(
                                    onTap: _togglePasswordVisibility,
                                    child: Icon(
                                      _isPasswordVisible
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                  obscureText: !_isPasswordVisible,
                                  hideBorder: true,
                                  validator: _validatePassword,
                                ),
                              ],
                            ),

                            SizedBox(height: 20),
                            button(
                              "Login",
                              onPressed: _handleFormSubmit,
                              btnRadious: 5,
                              isLoading: _isLoading,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
