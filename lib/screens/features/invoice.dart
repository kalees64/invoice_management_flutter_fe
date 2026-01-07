import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:invoice_management_flutter_fe/constants/colors.dart';
import 'package:invoice_management_flutter_fe/models/invoice_model.dart';
import 'package:invoice_management_flutter_fe/models/payment_model.dart';
import 'package:invoice_management_flutter_fe/models/receipt_model.dart';
import 'package:invoice_management_flutter_fe/providers/invoice_provider.dart';
import 'package:invoice_management_flutter_fe/providers/payment_provider.dart';
import 'package:invoice_management_flutter_fe/providers/receipt_provider.dart';
import 'package:invoice_management_flutter_fe/utils/toaster.dart';
import 'package:invoice_management_flutter_fe/widgets/button.dart';
import 'package:invoice_management_flutter_fe/widgets/data_table.dart';
import 'package:invoice_management_flutter_fe/widgets/dropdown.dart';
import 'package:invoice_management_flutter_fe/widgets/heading_text.dart';
import 'package:invoice_management_flutter_fe/widgets/input.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class InvoicePage extends StatefulWidget {
  const InvoicePage({super.key});

  @override
  State<InvoicePage> createState() => _InvoicePageState();
}

class _InvoicePageState extends State<InvoicePage> {
  var uuid = const Uuid();
  final _formKey = GlobalKey<FormState>();

  String selectedPaymentMode = 'UPI';
  final TextEditingController transactionIdController = TextEditingController();

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

  void _openPaymentPopup(BuildContext context, Map<String, dynamic> rowData) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Container(
            width: 400,
            height: 275,
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  label('Payment Details', fontSize: 18),
                  const SizedBox(height: 15),

                  /// Payment Mode (Mandatory)
                  dropdownInput(
                    items: ['Cash', 'UPI', 'Card', 'Bank Transfer', 'Cheque'],
                    itemLabel: (String item) => item,
                    initialValue: selectedPaymentMode,
                    placeholder: "Select payment mode",
                    prefixIcon: Icon(Icons.payment, color: AppColors.primary),
                    hideBorder: true,
                    onChanged: (value) {
                      setState(() {
                        selectedPaymentMode = value!;
                      });
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'Payment mode is required';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 12),

                  /// Transaction ID (Optional)
                  input(
                    placeholder: "Enter transaction ID",
                    prefixIcon: Icon(
                      Icons.task_outlined,
                      color: AppColors.primary,
                    ),
                    hideBorder: true,
                    controller: transactionIdController,
                  ),

                  const SizedBox(height: 30),

                  /// Action Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: text('Cancel'),
                      ),
                      const SizedBox(width: 10),
                      button(
                        "Confirm Payment",
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _markInvoiceAsPaid(context, rowData);
                          }
                        },
                        width: 150,
                        btnColor: AppColors.success,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _markInvoiceAsPaid(BuildContext context, Map<String, dynamic> rowData) {
    final invoice = InvoiceModel.fromJson(rowData);
    invoice.status = 'PAID';
    invoice.paidDate = DateTime.now();
    invoice.paidAmount = invoice.partAmount;
    invoice.balanceAmount = invoice.balanceAmount - invoice.partAmount;
    Provider.of<InvoiceProvider>(context, listen: false).updateInvoice(invoice);

    final payment = PaymentModel(
      id: uuid.v4(),
      invoiceId: invoice.id,
      invoiceNo: invoice.invoiceNo,
      paymentNo:
          'PAY-${Provider.of<PaymentProvider>(context, listen: false).payments.length + 1}',
      amount: invoice.partAmount,
      date: DateTime.now(),
      transactionId: transactionIdController.text.isEmpty
          ? null
          : transactionIdController.text,
      paymentStatus: 'PAID',
      paymentMode: selectedPaymentMode,
    );
    Provider.of<PaymentProvider>(context, listen: false).addPayment(payment);

    Toaster.showSuccessToast(context, 'Invoice marked as paid');
    Navigator.pop(context);
  }

  void _createReceipt(BuildContext context, InvoiceModel invoice) {
    final receipt = ReceiptModel(
      id: uuid.v4(),
      receiptNo:
          'RCPT-${Provider.of<ReceiptProvider>(context, listen: false).receipts.length + 1}',
      invoice: invoice,
      customer: invoice.customer,
      invoiceTotal: invoice.totalQuotationAmount,
      paidAmount: invoice.paidAmount,
      balanceAmount: invoice.balanceAmount,
      paymentMethod: selectedPaymentMode,
      transactionId: transactionIdController.text.isEmpty
          ? null
          : transactionIdController.text,
      paymentStatus: 'PAID',
      receiptDate: DateTime.now(),
    );

    log(receipt.toJson().toString());

    Provider.of<ReceiptProvider>(context, listen: false).addReceipt(receipt);

    Toaster.showSuccessToast(context, 'Receipt created');
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
      TableColumnConfig(fieldName: 'partAmount', displayName: 'Part Amount'),
      TableColumnConfig(fieldName: 'paidAmount', displayName: 'Paid'),
      TableColumnConfig(fieldName: 'balanceAmount', displayName: 'Balance'),
      TableColumnConfig(
        fieldName: 'totalQuotationAmount',
        displayName: 'Total',
      ),

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
              // PopupMenuItem(
              //   value: 'view',
              //   child: Row(
              //     children: [
              //       Icon(Icons.visibility_outlined, size: 18),
              //       SizedBox(width: 8),
              //       text('View Invoice'),
              //     ],
              //   ),
              // ),
              if (rowData['status'] == 'DRAFT')
                PopupMenuItem(
                  value: 'sentemail',
                  onTap: () {
                    final invoice = InvoiceModel.fromJson(rowData);
                    invoice.status = 'SENT';
                    Provider.of<InvoiceProvider>(
                      context,
                      listen: false,
                    ).updateInvoice(invoice);
                    Toaster.showSuccessToast(context, 'Invoice sent via email');
                  },
                  child: Row(
                    children: [
                      Icon(Icons.email_outlined, size: 18),
                      SizedBox(width: 8),
                      text('Send via Email'),
                    ],
                  ),
                ),
              if (rowData['status'] == 'PAID')
                PopupMenuItem(
                  value: 'createreceipt',
                  onTap: () {
                    _createReceipt(context, InvoiceModel.fromJson(rowData));
                  },
                  child: Row(
                    children: [
                      Icon(Icons.task_outlined, size: 18),
                      SizedBox(width: 8),
                      text('Create Receipt'),
                    ],
                  ),
                ),
              if (rowData['status'] == 'SENT' || rowData['status'] == 'OVERDUE')
                PopupMenuItem(
                  value: 'markPaid',
                  onTap: () {
                    _openPaymentPopup(context, rowData);
                  },
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
              if (rowData['status'] == 'SENT')
                PopupMenuItem(
                  value: 'markOverdue',
                  onTap: () {
                    final invoice = InvoiceModel.fromJson(rowData);
                    invoice.status = 'OVERDUE';
                    Provider.of<InvoiceProvider>(
                      context,
                      listen: false,
                    ).updateInvoice(invoice);
                    Toaster.showSuccessToast(
                      context,
                      'Invoice marked as overdue',
                    );
                  },
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
