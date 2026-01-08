import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:invoice_management_flutter_fe/constants/colors.dart';
import 'package:invoice_management_flutter_fe/constants/font.dart';
import 'package:invoice_management_flutter_fe/models/invoice_model.dart';
import 'package:invoice_management_flutter_fe/providers/invoice_provider.dart';
import 'package:invoice_management_flutter_fe/providers/payment_provider.dart';
import 'package:invoice_management_flutter_fe/providers/quotation_provider.dart';
import 'package:invoice_management_flutter_fe/providers/user_provider.dart';
import 'package:invoice_management_flutter_fe/widgets/heading_text.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  void _loadData() {
    context.read<InvoiceProvider>().getInvoices();
    context.read<PaymentProvider>().getPayments();
    context.read<QuotationProvider>().getQuotations();
    context.read<UserProvider>().getUsers();
  }

  Color _getStatusColor(String status) {
    switch (status.toUpperCase()) {
      case 'PAID':
        return AppColors.success;
      case 'SENT':
      case 'DRAFT':
        return AppColors.warning;
      case 'OVERDUE':
        return AppColors.danger;
      default:
        return AppColors.grey;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  double _calculateTotalRevenue(List<InvoiceModel> invoices) {
    return invoices.fold(0.0, (sum, invoice) => sum + invoice.paidAmount);
  }

  int _getPaidInvoicesCount(List<InvoiceModel> invoices) {
    return invoices.where((inv) => inv.status.toUpperCase() == 'PAID').length;
  }

  int _getPendingInvoicesCount(List<InvoiceModel> invoices) {
    return invoices.where((inv) => inv.status.toUpperCase() == 'SENT').length;
  }

  int _getOverdueInvoicesCount(List<InvoiceModel> invoices) {
    return invoices
        .where((inv) => inv.status.toUpperCase() == 'OVERDUE')
        .length;
  }

  double _getPaidAmount(List<InvoiceModel> invoices) {
    return invoices
        .where((inv) => inv.status.toUpperCase() == 'PAID')
        .fold(0.0, (sum, inv) => sum + inv.paidAmount);
  }

  double _getPendingAmount(List<InvoiceModel> invoices) {
    return invoices
        .where((inv) => inv.status.toUpperCase() == 'SENT')
        .fold(0.0, (sum, inv) => sum + inv.balanceAmount);
  }

  double _getOverdueAmount(List<InvoiceModel> invoices) {
    return invoices
        .where((inv) => inv.status.toUpperCase() == 'OVERDUE')
        .fold(0.0, (sum, inv) => sum + inv.balanceAmount);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Consumer4<InvoiceProvider, PaymentProvider, QuotationProvider, UserProvider>(
        builder:
            (
              context,
              invoiceProvider,
              paymentProvider,
              quotationProvider,
              userProvider,
              child,
            ) {
              final invoices = invoiceProvider.invoices;
              final recentInvoices = invoices.take(5).toList();

              final totalRevenue = _calculateTotalRevenue(invoices);
              final paidCount = _getPaidInvoicesCount(invoices);
              final pendingCount = _getPendingInvoicesCount(invoices);
              final overdueCount = _getOverdueInvoicesCount(invoices);

              final paidAmount = _getPaidAmount(invoices);
              final pendingAmount = _getPendingAmount(invoices);
              final overdueAmount = _getOverdueAmount(invoices);

              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Stats Cards Row
                      Row(
                        children: [
                          Expanded(
                            child: _buildStatCard(
                              'Total Revenue',
                              '\$${totalRevenue.toStringAsFixed(2)}',
                              Icons.attach_money,
                              AppColors.primary,
                              invoices.isEmpty ? '0%' : '+12.5%',
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildStatCard(
                              'Paid Invoices',
                              '$paidCount',
                              Icons.check_circle,
                              AppColors.success,
                              invoices.isEmpty ? '0%' : '+8.2%',
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildStatCard(
                              'Pending',
                              '$pendingCount',
                              Icons.schedule,
                              AppColors.warning,
                              invoices.isEmpty ? '0%' : '-3.1%',
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildStatCard(
                              'Overdue',
                              '$overdueCount',
                              Icons.warning,
                              AppColors.danger,
                              invoices.isEmpty ? '0' : '+2',
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Recent Invoices Table
                          Expanded(
                            flex: 2,
                            child: Container(
                              decoration: BoxDecoration(
                                color: AppColors.white,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.black.withValues(
                                      alpha: 0.05,
                                    ),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        h2('Recent Invoices'),
                                        TextButton(
                                          onPressed: () {},
                                          child: text(
                                            'View All',

                                            color: AppColors.primary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      border: Border(
                                        top: BorderSide(color: AppColors.light),
                                      ),
                                    ),
                                    child: Column(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 20,
                                            vertical: 12,
                                          ),
                                          color: AppColors.light,
                                          child: Row(
                                            children: [
                                              _buildTableHeader(
                                                'Invoice',
                                                flex: 2,
                                              ),
                                              _buildTableHeader(
                                                'Customer',
                                                flex: 3,
                                              ),
                                              _buildTableHeader(
                                                'Amount',
                                                flex: 2,
                                              ),
                                              _buildTableHeader(
                                                'Status',
                                                flex: 2,
                                              ),
                                              _buildTableHeader(
                                                'Date',
                                                flex: 2,
                                              ),
                                            ],
                                          ),
                                        ),
                                        if (recentInvoices.isEmpty)
                                          Padding(
                                            padding: const EdgeInsets.all(40.0),
                                            child: Center(
                                              child: text(
                                                'No invoices found',
                                                color: AppColors.grey,
                                              ),
                                            ),
                                          )
                                        else
                                          ...recentInvoices.map((invoice) {
                                            return Container(
                                              decoration: BoxDecoration(
                                                border: Border(
                                                  bottom: BorderSide(
                                                    color: AppColors.light,
                                                  ),
                                                ),
                                              ),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 20,
                                                    vertical: 16,
                                                  ),
                                              child: Row(
                                                children: [
                                                  _buildTableCell(
                                                    invoice.invoiceNo,
                                                    flex: 2,
                                                  ),
                                                  _buildTableCell(
                                                    invoice.customer.name,
                                                    flex: 3,
                                                  ),
                                                  _buildTableCell(
                                                    '\$${invoice.partAmount.toStringAsFixed(2)}',
                                                    flex: 2,
                                                  ),
                                                  _buildStatusBadge(
                                                    invoice.status,
                                                    flex: 2,
                                                  ),
                                                  _buildTableCell(
                                                    _formatDate(
                                                      invoice.invoiceDate,
                                                    ),
                                                    flex: 2,
                                                  ),
                                                ],
                                              ),
                                            );
                                          }),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(width: 16),

                          // Right Side Panel
                          Expanded(
                            flex: 1,
                            child: Column(
                              children: [
                                // Revenue Chart
                                Container(
                                  decoration: BoxDecoration(
                                    color: AppColors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppColors.black.withValues(
                                          alpha: 0.05,
                                        ),
                                        blurRadius: 10,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  padding: const EdgeInsets.all(20),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      h2('Payment Distribution'),
                                      const SizedBox(height: 20),
                                      if (invoices.isEmpty)
                                        Center(
                                          child: Padding(
                                            padding: const EdgeInsets.all(40.0),
                                            child: text(
                                              'No data available',
                                              color: AppColors.grey,
                                            ),
                                          ),
                                        )
                                      else
                                        SizedBox(
                                          height: 200,
                                          child: PieChart(
                                            PieChartData(
                                              sections: [
                                                PieChartSectionData(
                                                  value: paidAmount,
                                                  title:
                                                      '${((paidAmount / totalRevenue) * 100).toStringAsFixed(0)}%',
                                                  color: AppColors.success,
                                                  radius: 60,
                                                  titleStyle: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white,
                                                    fontFamily:
                                                        AppFonts.poppins,
                                                  ),
                                                ),
                                                PieChartSectionData(
                                                  value: pendingAmount > 0
                                                      ? pendingAmount
                                                      : 0.1,
                                                  title: pendingAmount > 0
                                                      ? '${((pendingAmount / (totalRevenue + pendingAmount + overdueAmount)) * 100).toStringAsFixed(0)}%'
                                                      : '',
                                                  color: AppColors.warning,
                                                  radius: 60,
                                                  titleStyle: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white,
                                                    fontFamily:
                                                        AppFonts.poppins,
                                                  ),
                                                ),
                                                PieChartSectionData(
                                                  value: overdueAmount > 0
                                                      ? overdueAmount
                                                      : 0.1,
                                                  title: overdueAmount > 0
                                                      ? '${((overdueAmount / (totalRevenue + pendingAmount + overdueAmount)) * 100).toStringAsFixed(0)}%'
                                                      : '',
                                                  color: AppColors.danger,
                                                  radius: 60,
                                                  titleStyle: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white,
                                                    fontFamily:
                                                        GoogleFonts.poppins()
                                                            .fontFamily!,
                                                  ),
                                                ),
                                              ],
                                              sectionsSpace: 2,
                                              centerSpaceRadius: 40,
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),

                                const SizedBox(height: 16),

                                // Payment Status Summary
                                Container(
                                  decoration: BoxDecoration(
                                    color: AppColors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppColors.black.withValues(
                                          alpha: 0.05,
                                        ),
                                        blurRadius: 10,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  padding: const EdgeInsets.all(20),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      h2('Payment Summary'),
                                      const SizedBox(height: 20),
                                      _buildPaymentRow(
                                        'Paid',
                                        '\$${paidAmount.toStringAsFixed(2)}',
                                        AppColors.success,
                                      ),
                                      const SizedBox(height: 16),
                                      _buildPaymentRow(
                                        'Pending',
                                        '\$${pendingAmount.toStringAsFixed(2)}',
                                        AppColors.warning,
                                      ),
                                      const SizedBox(height: 16),
                                      _buildPaymentRow(
                                        'Overdue',
                                        '\$${overdueAmount.toStringAsFixed(2)}',
                                        AppColors.danger,
                                      ),
                                      const SizedBox(height: 20),
                                      Divider(color: AppColors.light),
                                      const SizedBox(height: 12),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          h3('Total'),
                                          h3(
                                            '\$${(paidAmount + pendingAmount + overdueAmount).toStringAsFixed(2)}',
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),

                                const SizedBox(height: 16),

                                // Quick Stats
                                Container(
                                  decoration: BoxDecoration(
                                    color: AppColors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppColors.black.withValues(
                                          alpha: 0.05,
                                        ),
                                        blurRadius: 10,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  padding: const EdgeInsets.all(20),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      h2('Quick Stats'),
                                      const SizedBox(height: 16),
                                      _buildQuickStat(
                                        'Total Customers',
                                        '${userProvider.users.length}',
                                        Icons.people,
                                        AppColors.info,
                                      ),
                                      const SizedBox(height: 12),
                                      _buildQuickStat(
                                        'Active Quotations',
                                        '${quotationProvider.quotations.where((q) => q.status != 'REJECTED').length}',
                                        Icons.description,
                                        AppColors.primary,
                                      ),
                                      const SizedBox(height: 12),
                                      _buildQuickStat(
                                        'Total Payments',
                                        '${paymentProvider.payments.length}',
                                        Icons.payment,
                                        AppColors.success,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
      ),
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
    String change,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            spacing: 10,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              text(title, color: AppColors.grey),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              h1(value),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: change.startsWith('+')
                      ? AppColors.success.withValues(alpha: 0.1)
                      : change == '0%' || change == '0'
                      ? AppColors.grey.withValues(alpha: 0.1)
                      : AppColors.danger.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: text(
                  change,
                  color: change.startsWith('+')
                      ? AppColors.success
                      : change == '0%' || change == '0'
                      ? AppColors.grey
                      : AppColors.danger,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTableHeader(String text, {required int flex}) {
    return Expanded(
      flex: flex,
      child: Text(
        text,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: AppColors.dark,
          fontSize: 14,
          fontFamily: AppFonts.poppins,
        ),
      ),
    );
  }

  Widget _buildTableCell(String text, {required int flex}) {
    return Expanded(
      flex: flex,
      child: Text(
        text,
        style: TextStyle(
          color: AppColors.dark,
          fontSize: 14,
          fontFamily: AppFonts.poppins,
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status, {required int flex}) {
    return Expanded(
      flex: flex,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: _getStatusColor(status).withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(16),
        ),
        child: text(
          status,
          color: _getStatusColor(status),
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildPaymentRow(String label, String amount, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
            const SizedBox(width: 8),
            text(label),
          ],
        ),
        text(amount),
      ],
    );
  }

  Widget _buildQuickStat(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(icon, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                text(label, color: AppColors.grey, fontSize: 12),
                const SizedBox(height: 2),
                h2(value),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
