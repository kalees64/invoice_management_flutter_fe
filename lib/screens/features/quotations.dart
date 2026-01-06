import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:invoice_management_flutter_fe/constants/colors.dart';
import 'package:invoice_management_flutter_fe/models/product_model.dart';
import 'package:invoice_management_flutter_fe/models/quotation_model.dart';
import 'package:invoice_management_flutter_fe/models/user_model.dart';
import 'package:invoice_management_flutter_fe/providers/quotation_provider.dart';
import 'package:invoice_management_flutter_fe/screens/features/pages/create_invoice.dart';
import 'package:invoice_management_flutter_fe/screens/features/pages/create_quotation.dart';
import 'package:invoice_management_flutter_fe/utils/toaster.dart';
import 'package:invoice_management_flutter_fe/widgets/button.dart';
import 'package:invoice_management_flutter_fe/widgets/data_table.dart';
import 'package:invoice_management_flutter_fe/widgets/heading_text.dart';
import 'package:provider/provider.dart';

class Quotations extends StatefulWidget {
  const Quotations({super.key});

  @override
  State<Quotations> createState() => _QuotationsState();
}

class _QuotationsState extends State<Quotations> {
  Color _getStatusColor(String status) {
    switch (status) {
      case 'DRAFT':
        return AppColors.warning;
      case 'SENT':
        return AppColors.info;
      case 'ACCEPTED':
        return AppColors.success;
      case 'REJECTED':
        return AppColors.danger;
      default:
        return AppColors.grey;
    }
  }

  List<TableColumnConfig> _buildColumns() {
    return [
      TableColumnConfig(
        fieldName: 'quotationNo',
        displayName: 'Quotation No',
        bold: true,
      ),
      TableColumnConfig(
        fieldName: 'revisionNo',
        displayName: 'Revision No',
        customWidget: (value, index, rowData) {
          return text('Rev. $value');
        },
      ),
      TableColumnConfig(
        fieldName: 'customer',
        displayName: 'Customer Name',
        customWidget: (value, index, rowData) {
          final customer = rowData['customer'] as Map<String, dynamic>?;
          return text(customer?['name'] ?? '-');
        },
      ),
      TableColumnConfig(fieldName: 'total', displayName: 'Amount'),
      TableColumnConfig(
        fieldName: 'status',
        displayName: 'Status',
        bold: true,
        customWidget: (value, index, rowData) {
          return text(value.toString(), color: _getStatusColor(value));
        },
      ),
      TableColumnConfig(
        fieldName: 'date',
        displayName: 'Date',
        customWidget: (value, index, rowData) {
          DateTime? date;

          // 🔹 Handle both DateTime & String safely
          if (rowData['date'] is DateTime) {
            date = rowData['date'];
          } else if (rowData['date'] is String) {
            date = DateTime.tryParse(rowData['date']);
          }

          final formattedDate = date != null
              ? DateFormat('dd MMM yyyy, hh:mm a').format(date)
              : '-';

          return Expanded(child: text(formattedDate));
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
              if (value == 'revision') {
                log('Create new revision ${rowData['quotationNo']}');
              } else if (value == 'delete') {
                log('Delete ${rowData['quotationNo']}');
              }
            },
            color: AppColors.white,
            itemBuilder: (context) => [
              if (rowData['status'] == 'DRAFT')
                PopupMenuItem(
                  value: 'send',
                  onTap: () {
                    final quotation = QuotationModel(
                      id: rowData['id'],
                      quotationNo: rowData['quotationNo'],
                      revisionNo: rowData['revisionNo'],
                      customer: UserModel.fromJson(rowData['customer']),
                      products: (rowData['products'] as List)
                          .map((e) => ProductModel.fromJson(e))
                          .toList(),
                      total: rowData['total'],
                      status: 'SENT',
                      date: DateTime.now(),
                    );

                    Provider.of<QuotationProvider>(
                      context,
                      listen: false,
                    ).updateQuotation(quotation);
                    Toaster.showSuccessToast(context, 'Quotation sent');
                  },
                  child: Row(
                    children: [
                      Icon(Icons.email_outlined, size: 18),
                      SizedBox(width: 8),
                      text('Sent via Email'),
                    ],
                  ),
                ),
              if (rowData['status'] == 'ACCEPTED')
                PopupMenuItem(
                  value: 'createInvoice',
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return Container(
                          padding: EdgeInsets.all(20),
                          child: CreateInvoice(
                            quotation: QuotationModel.fromJson(rowData),
                          ),
                        );
                      },
                    );
                  },
                  child: Row(
                    children: [
                      Icon(Icons.receipt_long_outlined, size: 18),
                      SizedBox(width: 8),
                      text('Create Invoice'),
                    ],
                  ),
                ),
              if (rowData['status'] == 'SENT' ||
                  // rowData['status'] == 'DRAFT' ||
                  rowData['status'] == 'REJECTED')
                PopupMenuItem(
                  value: 'revision',
                  onTap: () {
                    log('Create new revision $rowData');
                    final quotation = QuotationModel.fromJson(rowData);
                    showDialog(
                      context: context,
                      builder: (_) => Container(
                        padding: EdgeInsets.all(20),
                        child: CreateQuotation(quotation: quotation),
                      ),
                    );
                  },
                  child: Row(
                    children: [
                      Icon(Icons.history, size: 18),
                      SizedBox(width: 8),
                      text('Create New Revision'),
                    ],
                  ),
                ),
              if (rowData['status'] == 'SENT')
                PopupMenuItem(
                  value: 'markAccepted',
                  onTap: () {
                    var quotation = QuotationModel.fromJson(rowData);
                    quotation.status = 'ACCEPTED';
                    log(quotation.toJson().toString());
                    Provider.of<QuotationProvider>(
                      context,
                      listen: false,
                    ).updateQuotation(quotation);
                    Toaster.showSuccessToast(context, 'Quotation accepted');
                  },
                  child: Row(
                    children: [
                      Icon(
                        Icons.task_outlined,
                        size: 18,
                        color: AppColors.success,
                      ),
                      SizedBox(width: 8),
                      text('Mark as Accepted', color: AppColors.success),
                    ],
                  ),
                ),
              if (rowData['status'] == 'SENT')
                PopupMenuItem(
                  value: 'markRejected',
                  onTap: () {
                    var quotation = QuotationModel.fromJson(rowData);
                    quotation.status = 'REJECTED';
                    Provider.of<QuotationProvider>(
                      context,
                      listen: false,
                    ).updateQuotation(quotation);
                    Toaster.showSuccessToast(context, 'Quotation rejected');
                  },
                  child: Row(
                    children: [
                      Icon(
                        Icons.warning_amber,
                        size: 18,
                        color: AppColors.danger,
                      ),
                      SizedBox(width: 8),
                      text('Mark as Rejected', color: AppColors.danger),
                    ],
                  ),
                ),
              if (rowData['status'] == 'DRAFT')
                PopupMenuItem(
                  value: 'delete',
                  onTap: () {
                    Provider.of<QuotationProvider>(
                      context,
                      listen: false,
                    ).deleteQuotation(rowData['id']);
                    Toaster.showSuccessToast(context, 'Quotation deleted');
                  },
                  child: Row(
                    children: [
                      Icon(
                        Icons.delete_outline,
                        size: 18,
                        color: AppColors.danger,
                      ),
                      SizedBox(width: 8),
                      text('Delete', color: AppColors.danger),
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
  void initState() {
    super.initState();
    Provider.of<QuotationProvider>(context, listen: false).getQuotations();
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
                children: [
                  h1("Quotations List"),
                  button(
                    "Create Quotation",
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (_) => Container(
                          padding: EdgeInsets.all(20),
                          child: CreateQuotation(),
                        ),
                      );
                    },
                    width: 160,
                    height: 35,
                    paddingY: 0,
                    paddingX: 5,
                    fontSize: 14,
                    icon: Icons.add,
                  ),
                ],
              ),

              SizedBox(height: 20),

              ReusableDataTable(
                columns: _buildColumns(),
                data: Provider.of<QuotationProvider>(
                  context,
                ).quotations.map((e) => e.toJson()).toList(),
                showSerialNumber: true,
                serialNumberColumnName: 'S.No',
                rowsPerPage: 10,
                showSearch: true,
                searchHint: 'Search quotations...',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
