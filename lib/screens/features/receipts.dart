import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:invoice_management_flutter_fe/constants/colors.dart';
import 'package:invoice_management_flutter_fe/models/receipt_model.dart';
import 'package:invoice_management_flutter_fe/providers/receipt_provider.dart';
import 'package:invoice_management_flutter_fe/widgets/data_table.dart';
import 'package:invoice_management_flutter_fe/widgets/heading_text.dart';
import 'package:provider/provider.dart';

class RecriptsPage extends StatefulWidget {
  const RecriptsPage({super.key});

  @override
  State<RecriptsPage> createState() => _RecriptsPageState();
}

class _RecriptsPageState extends State<RecriptsPage> {
  @override
  void initState() {
    super.initState();
    Provider.of<ReceiptProvider>(context, listen: false).getReceipts();
  }

  List<TableColumnConfig> _buildColumns() {
    return [
      TableColumnConfig(
        fieldName: 'receiptNo',
        displayName: 'Receipt No',
        bold: true,
      ),
      TableColumnConfig(
        fieldName: 'invoiceNo',
        displayName: 'Invoice No',
        bold: true,
        customWidget: (value, index, rowData) {
          final receipt = ReceiptModel.fromJson(rowData);
          return text(receipt.invoice.invoiceNo, fontWeight: FontWeight.bold);
        },
      ),
      TableColumnConfig(
        fieldName: 'customer',
        displayName: 'Customer',
        customWidget: (value, index, rowData) {
          final receipt = ReceiptModel.fromJson(rowData);
          return text(receipt.invoice.customer.name);
        },
      ),
      TableColumnConfig(fieldName: 'paidAmount', displayName: 'Paid Amount'),
      TableColumnConfig(
        fieldName: 'paymentMethod',
        displayName: 'Payment Method',
      ),
      TableColumnConfig(
        fieldName: 'receiptDate',
        displayName: 'Receipt Date',
        customWidget: (value, index, rowData) {
          final receipt = ReceiptModel.fromJson(rowData);
          return text(DateFormat('dd MMM yyyy').format(receipt.receiptDate));
        },
      ),
      TableColumnConfig(
        fieldName: 'actions',
        displayName: 'Actions',
        customWidget: (value, index, rowData) {
          return PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, size: 18, color: AppColors.info),
            tooltip: 'Actions',
            onSelected: (value) {
              if (value == 'sentviaemail') {
                log('Delete ${rowData['receiptNo']}');
              }
            },
            color: AppColors.white,
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'sentviaemail',
                child: Row(
                  children: [
                    Icon(Icons.email_outlined, size: 18),
                    SizedBox(width: 8),
                    text('Send via Email'),
                  ],
                ),
              ),
            ],
          );
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
                children: [h1("Receipts List")],
              ),

              SizedBox(height: 20),

              ReusableDataTable(
                columns: _buildColumns(),
                data: Provider.of<ReceiptProvider>(
                  context,
                ).receipts.map((e) => e.toJson()).toList(),
                showSerialNumber: true,
                serialNumberColumnName: 'S.No',
                rowsPerPage: 10,
                showSearch: true,
                searchHint: 'Search invoices...',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
