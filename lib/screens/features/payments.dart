import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:invoice_management_flutter_fe/constants/colors.dart';
import 'package:invoice_management_flutter_fe/models/payment_model.dart';
import 'package:invoice_management_flutter_fe/providers/payment_provider.dart';
import 'package:invoice_management_flutter_fe/widgets/data_table.dart';
import 'package:invoice_management_flutter_fe/widgets/heading_text.dart';
import 'package:provider/provider.dart';

class PaymentsPage extends StatefulWidget {
  const PaymentsPage({super.key});

  @override
  State<PaymentsPage> createState() => _PaymentsPageState();
}

class _PaymentsPageState extends State<PaymentsPage> {
  @override
  void initState() {
    super.initState();
    Provider.of<PaymentProvider>(context, listen: false).getPayments();
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'PAID':
        return AppColors.success;
      case 'PARTIAL':
        return AppColors.warning;
      case 'OVERDUE':
        return AppColors.danger;
      default:
        return AppColors.grey;
    }
  }

  List<TableColumnConfig> _buildColumns() {
    return [
      TableColumnConfig(
        fieldName: 'paymentNo',
        displayName: 'Payment No',
        bold: true,
      ),
      TableColumnConfig(
        fieldName: 'invoiceNo',
        displayName: 'Invoice No',
        bold: true,
      ),
      TableColumnConfig(fieldName: 'amount', displayName: 'Amount'),
      TableColumnConfig(fieldName: 'paymentMode', displayName: 'Payment Mode'),
      TableColumnConfig(
        fieldName: 'date',
        displayName: 'Date',
        customWidget: (value, index, rowData) {
          final payment = PaymentModel.fromJson(rowData);
          return text(DateFormat('dd MMM yyyy').format(payment.date));
        },
      ),
      TableColumnConfig(
        fieldName: 'paymentStatus',
        displayName: 'Status',
        bold: true,
        customWidget: (value, index, rowData) {
          return text(value.toString(), color: _getStatusColor(value));
        },
      ),
    ];
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
                children: [h1("Payments List")],
              ),

              SizedBox(height: 20),

              ReusableDataTable(
                columns: _buildColumns(),
                data: Provider.of<PaymentProvider>(
                  context,
                ).payments.map((e) => e.toJson()).toList(),
                showSerialNumber: true,
                serialNumberColumnName: 'S.No',
                rowsPerPage: 10,
                showSearch: true,
                searchHint: 'Search payments...',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
