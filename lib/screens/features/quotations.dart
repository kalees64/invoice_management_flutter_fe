import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:invoice_management_flutter_fe/constants/colors.dart';
import 'package:invoice_management_flutter_fe/providers/quotation_provider.dart';
import 'package:invoice_management_flutter_fe/screens/features/pages/create_quotation.dart';
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
              // if (rowData['status'] == 'DRAFT')
              PopupMenuItem(
                value: 'send',
                child: Row(
                  children: [
                    Icon(Icons.email_outlined, size: 18),
                    SizedBox(width: 8),
                    text('Sent via Email'),
                  ],
                ),
              ),
              // if (rowData['status'] == 'ACCEPTED')
              PopupMenuItem(
                value: 'createInvoice',
                child: Row(
                  children: [
                    Icon(Icons.receipt_long_outlined, size: 18),
                    SizedBox(width: 8),
                    text('Create Invoice'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'revision',
                child: Row(
                  children: [
                    Icon(Icons.history, size: 18),
                    SizedBox(width: 8),
                    text('Create New Revision'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'markAccepted',
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
              PopupMenuItem(
                value: 'markRejected',
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
              PopupMenuItem(
                value: 'delete',
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
