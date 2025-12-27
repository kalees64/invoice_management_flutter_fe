import 'package:flutter/material.dart';
import 'package:invoice_management_flutter_fe/constants/colors.dart';

class Invoice {
  final String id;
  final String customer;
  final double amount;
  final String status;
  final DateTime date;

  Invoice({
    required this.id,
    required this.customer,
    required this.amount,
    required this.status,
    required this.date,
  });
}

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final List<Invoice> recentInvoices = [
    Invoice(
      id: 'INV-001',
      customer: 'Acme Corporation',
      amount: 2500.00,
      status: 'Paid',
      date: DateTime.now().subtract(const Duration(days: 2)),
    ),
    Invoice(
      id: 'INV-002',
      customer: 'TechStart Inc',
      amount: 1850.50,
      status: 'Pending',
      date: DateTime.now().subtract(const Duration(days: 5)),
    ),
    Invoice(
      id: 'INV-003',
      customer: 'Global Solutions',
      amount: 3200.00,
      status: 'Paid',
      date: DateTime.now().subtract(const Duration(days: 7)),
    ),
    Invoice(
      id: 'INV-004',
      customer: 'Digital Ventures',
      amount: 980.00,
      status: 'Overdue',
      date: DateTime.now().subtract(const Duration(days: 35)),
    ),
    Invoice(
      id: 'INV-005',
      customer: 'Cloud Systems Ltd',
      amount: 4500.00,
      status: 'Pending',
      date: DateTime.now().subtract(const Duration(days: 10)),
    ),
  ];

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Paid':
        return AppColors.success;
      case 'Pending':
        return AppColors.warning;
      case 'Overdue':
        return AppColors.danger;
      default:
        return AppColors.grey;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
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
                      '\$45,230',
                      Icons.attach_money,
                      AppColors.primary,
                      '+12.5%',
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildStatCard(
                      'Paid Invoices',
                      '156',
                      Icons.check_circle,
                      AppColors.success,
                      '+8.2%',
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildStatCard(
                      'Pending',
                      '23',
                      Icons.schedule,
                      AppColors.warning,
                      '-3.1%',
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildStatCard(
                      'Overdue',
                      '8',
                      Icons.warning,
                      AppColors.danger,
                      '+2',
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
                            color: AppColors.black.withOpacity(0.05),
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Recent Invoices',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.dark,
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {},
                                  child: Text(
                                    'View All',
                                    style: TextStyle(color: AppColors.primary),
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
                                      _buildTableHeader('Invoice', flex: 2),
                                      _buildTableHeader('Customer', flex: 3),
                                      _buildTableHeader('Amount', flex: 2),
                                      _buildTableHeader('Status', flex: 2),
                                      _buildTableHeader('Date', flex: 2),
                                    ],
                                  ),
                                ),
                                ...recentInvoices.map((invoice) {
                                  return Container(
                                    decoration: BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(
                                          color: AppColors.light,
                                        ),
                                      ),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 16,
                                    ),
                                    child: Row(
                                      children: [
                                        _buildTableCell(invoice.id, flex: 2),
                                        _buildTableCell(
                                          invoice.customer,
                                          flex: 3,
                                        ),
                                        _buildTableCell(
                                          '\$${invoice.amount.toStringAsFixed(2)}',
                                          flex: 2,
                                        ),
                                        _buildStatusBadge(
                                          invoice.status,
                                          flex: 2,
                                        ),
                                        _buildTableCell(
                                          _formatDate(invoice.date),
                                          flex: 2,
                                        ),
                                      ],
                                    ),
                                  );
                                }).toList(),
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
                        // Quick Actions
                        Container(
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.black.withOpacity(0.05),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Quick Actions',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.dark,
                                ),
                              ),
                              const SizedBox(height: 16),
                              _buildQuickActionButton(
                                'Create Invoice',
                                Icons.add_circle_outline,
                                AppColors.primary,
                              ),
                              const SizedBox(height: 12),
                              _buildQuickActionButton(
                                'Add Customer',
                                Icons.person_add_outlined,
                                AppColors.success,
                              ),
                              const SizedBox(height: 12),
                              _buildQuickActionButton(
                                'View Reports',
                                Icons.bar_chart,
                                AppColors.info,
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
                                color: AppColors.black.withOpacity(0.05),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Payment Summary',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.dark,
                                ),
                              ),
                              const SizedBox(height: 20),
                              _buildPaymentRow(
                                'Paid',
                                '\$28,450',
                                AppColors.success,
                              ),
                              const SizedBox(height: 16),
                              _buildPaymentRow(
                                'Pending',
                                '\$12,300',
                                AppColors.warning,
                              ),
                              const SizedBox(height: 16),
                              _buildPaymentRow(
                                'Overdue',
                                '\$4,480',
                                AppColors.danger,
                              ),
                              const SizedBox(height: 20),
                              Divider(color: AppColors.light),
                              const SizedBox(height: 12),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Total',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.dark,
                                      fontSize: 16,
                                    ),
                                  ),
                                  Text(
                                    '\$45,230',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.dark,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
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
            color: AppColors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: change.startsWith('+')
                      ? AppColors.success.withOpacity(0.1)
                      : AppColors.danger.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  change,
                  style: TextStyle(
                    color: change.startsWith('+')
                        ? AppColors.success
                        : AppColors.danger,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(title, style: TextStyle(color: AppColors.grey, fontSize: 14)),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              color: AppColors.dark,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
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
        ),
      ),
    );
  }

  Widget _buildTableCell(String text, {required int flex}) {
    return Expanded(
      flex: flex,
      child: Text(text, style: TextStyle(color: AppColors.dark, fontSize: 14)),
    );
  }

  Widget _buildStatusBadge(String status, {required int flex}) {
    return Expanded(
      flex: flex,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: _getStatusColor(status).withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          status,
          style: TextStyle(
            color: _getStatusColor(status),
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildQuickActionButton(String label, IconData icon, Color color) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () {},
        icon: Icon(icon, size: 20),
        label: Text(label),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: AppColors.white,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
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
            Text(label, style: TextStyle(color: AppColors.dark, fontSize: 14)),
          ],
        ),
        Text(
          amount,
          style: TextStyle(
            color: AppColors.dark,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
