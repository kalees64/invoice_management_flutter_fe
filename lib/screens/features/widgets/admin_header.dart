import 'package:flutter/material.dart';
import 'package:invoice_management_flutter_fe/constants/colors.dart';
import 'package:invoice_management_flutter_fe/screens/auth/login_screen.dart';
import 'package:invoice_management_flutter_fe/utils/navigator.dart';
import 'package:invoice_management_flutter_fe/widgets/heading_text.dart';

class AdminHeader extends StatelessWidget {
  const AdminHeader({super.key});

  void _handleLogout(BuildContext context) {
    replacePage(context, LoginScreen());
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
      width: width,
      height: height * 0.09,
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          h1("Invoice Management", color: AppColors.success, fontSize: 22),
          Spacer(),
          Row(
            spacing: 10,
            children: [
              Icon(Icons.person, color: AppColors.primary),
              InkWell(
                onTap: () {
                  _handleLogout(context);
                },
                child: Icon(Icons.logout, color: AppColors.danger),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
