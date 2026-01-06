import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:invoice_management_flutter_fe/constants/colors.dart';
import 'package:invoice_management_flutter_fe/models/invoice_model.dart';
import 'package:invoice_management_flutter_fe/models/quotation_model.dart';
import 'package:invoice_management_flutter_fe/providers/invoice_provider.dart';
import 'package:invoice_management_flutter_fe/screens/features/layouts/admin_layout.dart';
import 'package:invoice_management_flutter_fe/utils/navigator.dart';
import 'package:invoice_management_flutter_fe/utils/toaster.dart';
import 'package:invoice_management_flutter_fe/widgets/button.dart';
import 'package:invoice_management_flutter_fe/widgets/heading_text.dart';
import 'package:invoice_management_flutter_fe/widgets/input.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class CreateInvoice extends StatefulWidget {
  const CreateInvoice({super.key, required this.quotation});
  final QuotationModel quotation;

  @override
  State<CreateInvoice> createState() => _CreateInvoiceState();
}

class _CreateInvoiceState extends State<CreateInvoice> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController installmentNoController;
  late TextEditingController totalInstallmentsController;
  late TextEditingController installmentAmountController;
  late TextEditingController dueDateController;
  DateTime? selectedDueDate;
  var uuid = const Uuid();
  bool _isLoading = false;

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
    installmentNoController = .new();
    totalInstallmentsController = .new();
    installmentAmountController = .new();
    dueDateController = .new();
  }

  @override
  void dispose() {
    installmentNoController.dispose();
    totalInstallmentsController.dispose();
    installmentAmountController.dispose();
    dueDateController.dispose();
    super.dispose();
  }

  void _createInvoice(BuildContext context, String status) {
    startLoading();
    if (_formKey.currentState!.validate()) {
      final totalInvoices = context.read<InvoiceProvider>().invoices.length;

      final InvoiceModel invoice = InvoiceModel(
        id: uuid.v4(),
        invoiceNo: 'INV-${totalInvoices + 1}',
        quotationId: widget.quotation.id!,
        quotationNo: widget.quotation.quotationNo,
        installmentNo: int.parse(installmentNoController.text),
        totalInstallments: int.parse(totalInstallmentsController.text),
        installmentAmount: double.parse(installmentAmountController.text),
        customer: widget.quotation.customer,
        totalQuotationAmount: widget.quotation.total,
        paidAmount: 0,
        balanceAmount: widget.quotation.total,
        status: status,
        invoiceDate: DateTime.now(),
        dueDate: selectedDueDate!,
        paidDate: null,
      );
      log(invoice.toJson().toString());
      Provider.of<InvoiceProvider>(context, listen: false).addInvoice(invoice);
      pushToPage(context, AdminLayout(initialPage: 'invoices'));
      Toaster.showSuccessToast(context, "Invoice Created Successfully");
      stopLoading();
    } else {
      stopLoading();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  h1("Create Invoice for ${widget.quotation.quotationNo}"),
                  button(
                    "Close",
                    onPressed: () => popPage(context),
                    width: 100,
                    height: 35,
                    paddingY: 0,
                    paddingX: 5,
                    fontSize: 14,
                    btnColor: AppColors.danger,
                    icon: Icons.close,
                  ),
                ],
              ),
              Divider(),
              SizedBox(height: 10),

              // Quotation Details
              h2("Quotation Details"),
              Divider(),
              SizedBox(height: 10),
              Row(
                spacing: 10,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          text('Revision : ${widget.quotation.revisionNo}'),
                          text(
                            'Total Products : ${widget.quotation.products.length}',
                          ),
                          text(
                            'Total Cost : ${widget.quotation.total.toString()}',
                            fontWeight: FontWeight.bold,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          h3(widget.quotation.customer.name),
                          text(
                            '${widget.quotation.customer.email}, ${widget.quotation.customer.phone}',
                          ),
                          text(
                            '${widget.quotation.customer.address}, ${widget.quotation.customer.city}, ${widget.quotation.customer.state}, ${widget.quotation.customer.country} - ${widget.quotation.customer.pincode}',
                            maxLines: 2,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          h3(
                            '${widget.quotation.status} By ${widget.quotation.customer.name}',
                          ),
                          text(
                            'Quotation Date: ${DateFormat('dd MMM yyyy').format(widget.quotation.date)}',
                          ),
                          text(
                            'Total Quantity: ${widget.quotation.products.fold<int>(0, (sum, product) => sum + (product.quantity ?? 0))}',
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),

              // Invoice Details
              h2("Invoice Details"),
              Divider(),
              SizedBox(height: 20),
              Form(
                key: _formKey,
                child: Row(
                  spacing: 15,
                  children: [
                    // Installment No.
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: [
                          label("Installment No", required: true),
                          input(
                            placeholder: "Enter installment no.",
                            hideBorder: true,
                            controller: installmentNoController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Installment no. is required';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),

                    // Total Installments
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          label("Total Installments", required: true),
                          input(
                            placeholder: "Enter total installments",
                            hideBorder: true,
                            controller: totalInstallmentsController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Total installments is required';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),

                    // Installment Amount
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          label("Installment Amount", required: true),
                          input(
                            placeholder: "Enter installment amount",
                            hideBorder: true,
                            controller: installmentAmountController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Installment amount is required';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),

                    // Due Date
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          label("Due Date", required: true),
                          input(
                            placeholder: "Enter due date",
                            hideBorder: true,
                            isDatePicker: true,
                            context: context,
                            initialDate: selectedDueDate,
                            controller: dueDateController,
                            onDateSelected: (date) {
                              setState(() {
                                selectedDueDate = date;
                              });
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Due date is required';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 25),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                spacing: 10,
                children: [
                  button(
                    "Create Draft Invoice",
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _createInvoice(context, 'DRAFT');
                      }
                    },
                    width: 250,
                    btnColor: AppColors.primary,
                  ),
                  button(
                    "Create Invoice & Send Email",
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _createInvoice(context, 'SENT');
                      }
                    },
                    width: 250,
                    btnColor: AppColors.success,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
