import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:invoice_management_flutter_fe/constants/colors.dart';
import 'package:invoice_management_flutter_fe/models/invoice_model.dart';
import 'package:invoice_management_flutter_fe/providers/invoice_provider.dart';
import 'package:invoice_management_flutter_fe/widgets/data_table.dart';
import 'package:invoice_management_flutter_fe/widgets/heading_text.dart';
import 'package:provider/provider.dart';

class InvoicePage extends StatefulWidget {
  const InvoicePage({super.key});

  @override
  State<InvoicePage> createState() => _InvoicePageState();
}

class _InvoicePageState extends State<InvoicePage> {
  Color _getStatusColor(String status) {
    switch (status) {
      case 'SENT':
        return AppColors.info;
      case 'PAID':
        return AppColors.success;
      case 'OVERDUE':
        return AppColors.danger;
      default:
        return AppColors.grey;
    }
  }

  List<TableColumnConfig> _buildColumns() {
    return [
      TableColumnConfig(
        fieldName: 'invoiceNo',
        displayName: 'Invoice',
        bold: true,
      ),
      TableColumnConfig(
        fieldName: 'quotationNo',
        displayName: 'Quotation',
        bold: true,
      ),
      TableColumnConfig(
        fieldName: 'customer',
        displayName: 'Customer',
        customWidget: (value, index, rowData) {
          final customer = rowData['customer'] as Map<String, dynamic>?;
          return text(customer?['name'] ?? '-');
        },
      ),
      TableColumnConfig(
        fieldName: 'installmentNo',
        displayName: 'Installment',
        customWidget: (value, index, rowData) {
          final InvoiceModel invoice = InvoiceModel.fromJson(rowData);
          return text(
            '${invoice.installmentNo} / ${invoice.totalInstallments}',
          );
        },
      ),

      TableColumnConfig(fieldName: 'installmentAmount', displayName: 'Amount'),
      TableColumnConfig(fieldName: 'balanceAmount', displayName: 'Balance'),
      TableColumnConfig(
        fieldName: 'totalQuotationAmount',
        displayName: 'Total',
      ),
      TableColumnConfig(fieldName: 'paidAmount', displayName: 'Paid'),

      // TableColumnConfig(
      //   fieldName: 'invoiceDate',
      //   displayName: 'Invoice Date',
      //   customWidget: (value, index, rowData) {
      //     final InvoiceModel invoice = InvoiceModel.fromJson(rowData);
      //     return text(DateFormat('dd MMM yyyy').format(invoice.invoiceDate));
      //   },
      // ),
      TableColumnConfig(
        fieldName: 'dueDate',
        displayName: 'Due Date',
        customWidget: (value, index, rowData) {
          final InvoiceModel invoice = InvoiceModel.fromJson(rowData);
          return text(DateFormat('dd MMM yyyy').format(invoice.dueDate));
        },
      ),

      TableColumnConfig(
        fieldName: 'status',
        displayName: 'Status',
        bold: true,
        customWidget: (value, index, rowData) {
          return text(value.toString(), color: _getStatusColor(value));
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
              if (value == 'markPaid') {
                log('Mark as paid ${rowData['invoiceNo']}');
              } else if (value == 'markOverdue') {
                log('Mark as overdue ${rowData['invoiceNo']}');
              }
            },
            color: AppColors.white,
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'view',
                child: Row(
                  children: [
                    Icon(Icons.visibility_outlined, size: 18),
                    SizedBox(width: 8),
                    text('View Invoice'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'sentemail',
                child: Row(
                  children: [
                    Icon(Icons.email_outlined, size: 18),
                    SizedBox(width: 8),
                    text('Send via Email'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'createinstallment',
                child: Row(
                  children: [
                    Icon(Icons.task_outlined, size: 18),
                    SizedBox(width: 8),
                    text('Create Installment Invoice'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'markPaid',
                child: Row(
                  children: [
                    Icon(
                      Icons.task_outlined,
                      size: 18,
                      color: AppColors.success,
                    ),
                    SizedBox(width: 8),
                    text('Mark as Paid', color: AppColors.success),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'markOverdue',
                child: Row(
                  children: [
                    Icon(
                      Icons.warning_amber,
                      size: 18,
                      color: AppColors.danger,
                    ),
                    SizedBox(width: 8),
                    text('Mark as Overdue', color: AppColors.danger),
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
    Provider.of<InvoiceProvider>(context, listen: false).getInvoices();
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
                children: [h1("Invoices List")],
              ),

              SizedBox(height: 20),

              ReusableDataTable(
                columns: _buildColumns(),
                data: Provider.of<InvoiceProvider>(
                  context,
                ).invoices.map((e) => e.toJson()).toList(),
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
