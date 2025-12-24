import 'package:flutter/material.dart';
import 'package:invoice_management_flutter_fe/constants/colors.dart';
import 'package:invoice_management_flutter_fe/utils/helper.dart';
import 'package:invoice_management_flutter_fe/widgets/heading_text.dart';

// ignore: must_be_immutable
class AdminHeader extends StatelessWidget {
  String activePage = "dashboard";
  bool backButton = false;

  AdminHeader({super.key, required this.activePage, required this.backButton});

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
        border: Border(bottom: BorderSide(color: AppColors.light, width: 2)),
      ),
      child: Row(
        children: [
          Row(
            spacing: 10,
            children: [
              if (backButton) BackButton(color: AppColors.black),
              h2(Helper.makeWordAsTitle(activePage)),
            ],
          ),
          Spacer(),
          Row(
            spacing: 10,
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: AppColors.avatarBackground,
                child: Icon(Icons.person, color: AppColors.white),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
