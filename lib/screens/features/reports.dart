import 'package:flutter/material.dart';
import 'package:invoice_management_flutter_fe/constants/colors.dart';
import 'package:invoice_management_flutter_fe/constants/font.dart';
import 'package:invoice_management_flutter_fe/models/invoice_model.dart';
import 'package:invoice_management_flutter_fe/models/payment_model.dart';
import 'package:invoice_management_flutter_fe/providers/invoice_provider.dart';
import 'package:invoice_management_flutter_fe/providers/payment_provider.dart';
import 'package:invoice_management_flutter_fe/providers/quotation_provider.dart';
import 'package:invoice_management_flutter_fe/providers/product_provider.dart';
import 'package:invoice_management_flutter_fe/providers/user_provider.dart';
import 'package:invoice_management_flutter_fe/widgets/heading_text.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

class ReportsPage extends StatefulWidget {
  const ReportsPage({super.key});

  @override
  State<ReportsPage> createState() => _ReportsPageState();
}

class _ReportsPageState extends State<ReportsPage> {
  String selectedPeriod = 'This Month';
  int selectedTabIndex = 0;

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
    context.read<ProductProvider>().getProducts();
  }

  List<InvoiceModel> _filterInvoicesByPeriod(
    List<InvoiceModel> invoices,
    String period,
  ) {
    final now = DateTime.now();
    switch (period) {
      case 'Today':
        return invoices.where((inv) {
          return inv.invoiceDate.year == now.year &&
              inv.invoiceDate.month == now.month &&
              inv.invoiceDate.day == now.day;
        }).toList();
      case 'This Week':
        final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
        return invoices.where((inv) {
          return inv.invoiceDate.isAfter(startOfWeek);
        }).toList();
      case 'This Month':
        return invoices.where((inv) {
          return inv.invoiceDate.year == now.year &&
              inv.invoiceDate.month == now.month;
        }).toList();
      case 'This Year':
        return invoices.where((inv) {
          return inv.invoiceDate.year == now.year;
        }).toList();
      default:
        return invoices;
    }
  }

  Map<String, double> _getRevenueByMonth(List<InvoiceModel> invoices) {
    final Map<String, double> revenueMap = {};
    final now = DateTime.now();

    for (int i = 5; i >= 0; i--) {
      final month = DateTime(now.year, now.month - i, 1);
      final monthKey = DateFormat('MMM').format(month);
      revenueMap[monthKey] = 0.0;
    }

    for (var invoice in invoices) {
      final monthKey = DateFormat('MMM').format(invoice.invoiceDate);
      if (revenueMap.containsKey(monthKey)) {
        revenueMap[monthKey] = revenueMap[monthKey]! + invoice.paidAmount;
      }
    }

    return revenueMap;
  }

  Map<String, int> _getInvoicesByStatus(List<InvoiceModel> invoices) {
    return {
      'PAID': invoices
          .where((inv) => inv.status.toUpperCase() == 'PAID')
          .length,
      'SENT': invoices
          .where((inv) => inv.status.toUpperCase() == 'SENT')
          .length,
      'OVERDUE': invoices
          .where((inv) => inv.status.toUpperCase() == 'OVERDUE')
          .length,
      'DRAFT': invoices
          .where((inv) => inv.status.toUpperCase() == 'DRAFT')
          .length,
    };
  }

  Map<String, int> _getPaymentsByMethod(List<PaymentModel> payments) {
    final Map<String, int> methodMap = {};
    for (var payment in payments) {
      methodMap[payment.paymentMode] =
          (methodMap[payment.paymentMode] ?? 0) + 1;
    }
    return methodMap;
  }

  List<Map<String, dynamic>> _getTopCustomers(List<InvoiceModel> invoices) {
    final Map<String, double> customerRevenue = {};

    for (var invoice in invoices) {
      final customerId = invoice.customer.id ?? invoice.customer.email;
      customerRevenue[customerId] =
          (customerRevenue[customerId] ?? 0) + invoice.paidAmount;
    }

    final sorted = customerRevenue.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return sorted.take(5).map((entry) {
      final invoice = invoices.firstWhere(
        (inv) => (inv.customer.id ?? inv.customer.email) == entry.key,
      );
      return {'name': invoice.customer.name, 'revenue': entry.value};
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body:
          Consumer5<
            InvoiceProvider,
            PaymentProvider,
            QuotationProvider,
            UserProvider,
            ProductProvider
          >(
            builder:
                (
                  context,
                  invoiceProvider,
                  paymentProvider,
                  quotationProvider,
                  userProvider,
                  productProvider,
                  child,
                ) {
                  final allInvoices = invoiceProvider.invoices;
                  final filteredInvoices = _filterInvoicesByPeriod(
                    allInvoices,
                    selectedPeriod,
                  );
                  final payments = paymentProvider.payments;
                  final quotations = quotationProvider.quotations;

                  final totalRevenue = filteredInvoices.fold(
                    0.0,
                    (sum, inv) => sum + inv.paidAmount,
                  );
                  final totalInvoices = filteredInvoices.length;
                  final avgInvoiceValue = totalInvoices > 0
                      ? totalRevenue / totalInvoices
                      : 0.0;
                  final collectionRate = allInvoices.isNotEmpty
                      ? (allInvoices
                                .where(
                                  (inv) => inv.status.toUpperCase() == 'PAID',
                                )
                                .length /
                            allInvoices.length *
                            100)
                      : 0.0;

                  final revenueByMonth = _getRevenueByMonth(allInvoices);
                  final invoicesByStatus = _getInvoicesByStatus(
                    filteredInvoices,
                  );
                  final paymentsByMethod = _getPaymentsByMethod(payments);
                  final topCustomers = _getTopCustomers(allInvoices);

                  return SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Header
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  h1('Reports & Analytics'),
                                  const SizedBox(height: 4),
                                  h3(
                                    'Comprehensive business insights and performance metrics',

                                    color: AppColors.grey,
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  // _buildPeriodSelector(),
                                  const SizedBox(width: 12),

                                  // ElevatedButton.icon(
                                  //   onPressed: () {
                                  //     // Export functionality
                                  //   },
                                  //   icon: const Icon(Icons.download, size: 18),
                                  //   label: text(
                                  //     'Export Report',
                                  //     color: AppColors.white,
                                  //   ),
                                  //   style: ElevatedButton.styleFrom(
                                  //     backgroundColor: AppColors.primary,
                                  //     foregroundColor: Colors.white,
                                  //     padding: const EdgeInsets.symmetric(
                                  //       horizontal: 20,
                                  //       vertical: 12,
                                  //     ),
                                  //     shape: RoundedRectangleBorder(
                                  //       borderRadius: BorderRadius.circular(8),
                                  //     ),
                                  //   ),
                                  // ),
                                ],
                              ),
                            ],
                          ),

                          const SizedBox(height: 24),

                          // Key Metrics Row
                          Row(
                            children: [
                              Expanded(
                                child: _buildMetricCard(
                                  'Total Revenue',
                                  '\$${totalRevenue.toStringAsFixed(2)}',
                                  Icons.trending_up,
                                  AppColors.success,
                                  '+12.5% from last period',
                                  true,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: _buildMetricCard(
                                  'Total Invoices',
                                  '$totalInvoices',
                                  Icons.receipt_long,
                                  AppColors.primary,
                                  '+8 from last period',
                                  true,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: _buildMetricCard(
                                  'Avg Invoice Value',
                                  '\$${avgInvoiceValue.toStringAsFixed(2)}',
                                  Icons.analytics,
                                  AppColors.info,
                                  '-2.3% from last period',
                                  false,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: _buildMetricCard(
                                  'Collection Rate',
                                  '${collectionRate.toStringAsFixed(1)}%',
                                  Icons.pie_chart,
                                  AppColors.warning,
                                  '+5.2% from last period',
                                  true,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 24),

                          // Charts Row
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Revenue Trend Chart
                              Expanded(
                                flex: 2,
                                child: _buildChartCard(
                                  'Revenue Trend (Last 6 Months)',
                                  SizedBox(
                                    height: 300,
                                    child:
                                        revenueByMonth.values.every(
                                          (v) => v == 0,
                                        )
                                        ? Center(
                                            child: text(
                                              'No revenue data available',
                                              color: AppColors.grey,
                                            ),
                                          )
                                        : Padding(
                                            padding: const EdgeInsets.only(
                                              right: 20,
                                              top: 20,
                                              bottom: 20,
                                            ),
                                            child: LineChart(
                                              LineChartData(
                                                gridData: FlGridData(
                                                  show: true,
                                                  drawVerticalLine: false,
                                                  horizontalInterval: 5000,
                                                  getDrawingHorizontalLine:
                                                      (value) {
                                                        return FlLine(
                                                          color:
                                                              AppColors.light,
                                                          strokeWidth: 1,
                                                        );
                                                      },
                                                ),
                                                titlesData: FlTitlesData(
                                                  leftTitles: AxisTitles(
                                                    sideTitles: SideTitles(
                                                      showTitles: true,
                                                      reservedSize: 60,
                                                      getTitlesWidget:
                                                          (value, meta) {
                                                            return text(
                                                              '\$${(value / 1000).toStringAsFixed(0)}K',
                                                              color: AppColors
                                                                  .grey,
                                                              fontSize: 12,
                                                            );
                                                          },
                                                    ),
                                                  ),
                                                  bottomTitles: AxisTitles(
                                                    sideTitles: SideTitles(
                                                      showTitles: true,
                                                      getTitlesWidget: (value, meta) {
                                                        final months =
                                                            revenueByMonth.keys
                                                                .toList();
                                                        if (value.toInt() >=
                                                                0 &&
                                                            value.toInt() <
                                                                months.length) {
                                                          return Padding(
                                                            padding:
                                                                const EdgeInsets.only(
                                                                  top: 8,
                                                                ),
                                                            child: text(
                                                              months[value
                                                                  .toInt()],
                                                              color: AppColors
                                                                  .grey,
                                                              fontSize: 12,
                                                            ),
                                                          );
                                                        }
                                                        return const SizedBox();
                                                      },
                                                    ),
                                                  ),
                                                  rightTitles: const AxisTitles(
                                                    sideTitles: SideTitles(
                                                      showTitles: false,
                                                    ),
                                                  ),
                                                  topTitles: const AxisTitles(
                                                    sideTitles: SideTitles(
                                                      showTitles: false,
                                                    ),
                                                  ),
                                                ),
                                                borderData: FlBorderData(
                                                  show: false,
                                                ),
                                                lineBarsData: [
                                                  LineChartBarData(
                                                    spots: revenueByMonth
                                                        .entries
                                                        .toList()
                                                        .asMap()
                                                        .entries
                                                        .map(
                                                          (entry) => FlSpot(
                                                            entry.key
                                                                .toDouble(),
                                                            entry.value.value,
                                                          ),
                                                        )
                                                        .toList(),
                                                    isCurved: true,
                                                    color: AppColors.primary,
                                                    barWidth: 3,
                                                    dotData: FlDotData(
                                                      show: true,
                                                      getDotPainter:
                                                          (
                                                            spot,
                                                            percent,
                                                            bar,
                                                            index,
                                                          ) {
                                                            return FlDotCirclePainter(
                                                              radius: 4,
                                                              color: AppColors
                                                                  .primary,
                                                              strokeWidth: 2,
                                                              strokeColor:
                                                                  Colors.white,
                                                            );
                                                          },
                                                    ),
                                                    belowBarData: BarAreaData(
                                                      show: true,
                                                      color: AppColors.primary
                                                          .withValues(
                                                            alpha: 0.1,
                                                          ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                  ),
                                ),
                              ),

                              const SizedBox(width: 16),

                              // Invoice Status Distribution
                              Expanded(
                                flex: 1,
                                child: _buildChartCard(
                                  'Invoice Status Distribution',
                                  SizedBox(
                                    height: 300,
                                    child:
                                        invoicesByStatus.values.every(
                                          (v) => v == 0,
                                        )
                                        ? Center(
                                            child: text(
                                              'No invoice data available',
                                              color: AppColors.grey,
                                            ),
                                          )
                                        : Column(
                                            children: [
                                              Expanded(
                                                child: PieChart(
                                                  PieChartData(
                                                    sections: [
                                                      if (invoicesByStatus['PAID']! >
                                                          0)
                                                        PieChartSectionData(
                                                          value:
                                                              invoicesByStatus['PAID']!
                                                                  .toDouble(),
                                                          title:
                                                              '${invoicesByStatus['PAID']}',
                                                          color:
                                                              AppColors.success,
                                                          radius: 80,
                                                          titleStyle: TextStyle(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Colors.white,
                                                            fontFamily: AppFonts
                                                                .poppins,
                                                          ),
                                                        ),
                                                      if (invoicesByStatus['SENT']! >
                                                          0)
                                                        PieChartSectionData(
                                                          value:
                                                              invoicesByStatus['SENT']!
                                                                  .toDouble(),
                                                          title:
                                                              '${invoicesByStatus['SENT']}',
                                                          color:
                                                              AppColors.warning,
                                                          radius: 80,
                                                          titleStyle: TextStyle(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Colors.white,
                                                            fontFamily: AppFonts
                                                                .poppins,
                                                          ),
                                                        ),
                                                      if (invoicesByStatus['OVERDUE']! >
                                                          0)
                                                        PieChartSectionData(
                                                          value:
                                                              invoicesByStatus['OVERDUE']!
                                                                  .toDouble(),
                                                          title:
                                                              '${invoicesByStatus['OVERDUE']}',
                                                          color:
                                                              AppColors.danger,
                                                          radius: 80,
                                                          titleStyle: TextStyle(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Colors.white,
                                                            fontFamily: AppFonts
                                                                .poppins,
                                                          ),
                                                        ),
                                                      if (invoicesByStatus['DRAFT']! >
                                                          0)
                                                        PieChartSectionData(
                                                          value:
                                                              invoicesByStatus['DRAFT']!
                                                                  .toDouble(),
                                                          title:
                                                              '${invoicesByStatus['DRAFT']}',
                                                          color: AppColors.grey,
                                                          radius: 80,
                                                          titleStyle: TextStyle(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Colors.white,
                                                            fontFamily: AppFonts
                                                                .poppins,
                                                          ),
                                                        ),
                                                    ],
                                                    sectionsSpace: 2,
                                                    centerSpaceRadius: 50,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(height: 20),
                                              Wrap(
                                                spacing: 16,
                                                runSpacing: 8,
                                                children: [
                                                  _buildLegendItem(
                                                    'Paid',
                                                    AppColors.success,
                                                  ),
                                                  _buildLegendItem(
                                                    'Sent',
                                                    AppColors.warning,
                                                  ),
                                                  _buildLegendItem(
                                                    'Overdue',
                                                    AppColors.danger,
                                                  ),
                                                  _buildLegendItem(
                                                    'Draft',
                                                    AppColors.grey,
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 24),

                          // Second Row of Charts
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Payment Methods
                              Expanded(
                                flex: 1,
                                child: _buildChartCard(
                                  'Payment Methods',
                                  SizedBox(
                                    height: 300,
                                    child: paymentsByMethod.isEmpty
                                        ? Center(
                                            child: text(
                                              'No payment data available',
                                              color: AppColors.grey,
                                            ),
                                          )
                                        : Padding(
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 20,
                                            ),
                                            child: BarChart(
                                              BarChartData(
                                                alignment: BarChartAlignment
                                                    .spaceAround,
                                                maxY:
                                                    paymentsByMethod
                                                        .values
                                                        .isEmpty
                                                    ? 10
                                                    : paymentsByMethod.values
                                                              .reduce(
                                                                (a, b) => a > b
                                                                    ? a
                                                                    : b,
                                                              )
                                                              .toDouble() +
                                                          5,
                                                barTouchData: BarTouchData(
                                                  enabled: true,
                                                ),
                                                titlesData: FlTitlesData(
                                                  leftTitles: AxisTitles(
                                                    sideTitles: SideTitles(
                                                      showTitles: true,
                                                      reservedSize: 40,
                                                      getTitlesWidget:
                                                          (value, meta) {
                                                            return text(
                                                              value
                                                                  .toInt()
                                                                  .toString(),
                                                              color: AppColors
                                                                  .grey,
                                                              fontSize: 12,
                                                            );
                                                          },
                                                    ),
                                                  ),
                                                  bottomTitles: AxisTitles(
                                                    sideTitles: SideTitles(
                                                      showTitles: true,
                                                      getTitlesWidget: (value, meta) {
                                                        final methods =
                                                            paymentsByMethod
                                                                .keys
                                                                .toList();
                                                        if (value.toInt() >=
                                                                0 &&
                                                            value.toInt() <
                                                                methods
                                                                    .length) {
                                                          return Padding(
                                                            padding:
                                                                const EdgeInsets.only(
                                                                  top: 8,
                                                                ),
                                                            child: text(
                                                              methods[value
                                                                  .toInt()],
                                                              color: AppColors
                                                                  .grey,
                                                              fontSize: 11,
                                                            ),
                                                          );
                                                        }
                                                        return const SizedBox();
                                                      },
                                                    ),
                                                  ),
                                                  rightTitles: const AxisTitles(
                                                    sideTitles: SideTitles(
                                                      showTitles: false,
                                                    ),
                                                  ),
                                                  topTitles: const AxisTitles(
                                                    sideTitles: SideTitles(
                                                      showTitles: false,
                                                    ),
                                                  ),
                                                ),
                                                gridData: FlGridData(
                                                  show: true,
                                                  drawVerticalLine: false,
                                                  horizontalInterval: 5,
                                                  getDrawingHorizontalLine:
                                                      (value) {
                                                        return FlLine(
                                                          color:
                                                              AppColors.light,
                                                          strokeWidth: 1,
                                                        );
                                                      },
                                                ),
                                                borderData: FlBorderData(
                                                  show: false,
                                                ),
                                                barGroups: paymentsByMethod
                                                    .entries
                                                    .toList()
                                                    .asMap()
                                                    .entries
                                                    .map((entry) {
                                                      return BarChartGroupData(
                                                        x: entry.key,
                                                        barRods: [
                                                          BarChartRodData(
                                                            toY: entry
                                                                .value
                                                                .value
                                                                .toDouble(),
                                                            color:
                                                                AppColors.info,
                                                            width: 30,
                                                            borderRadius:
                                                                const BorderRadius.only(
                                                                  topLeft:
                                                                      Radius.circular(
                                                                        6,
                                                                      ),
                                                                  topRight:
                                                                      Radius.circular(
                                                                        6,
                                                                      ),
                                                                ),
                                                          ),
                                                        ],
                                                      );
                                                    })
                                                    .toList(),
                                              ),
                                            ),
                                          ),
                                  ),
                                ),
                              ),

                              const SizedBox(width: 16),

                              // Top Customers
                              Expanded(
                                flex: 1,
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(20),
                                        child: h2('Top 5 Customers by Revenue'),
                                      ),
                                      if (topCustomers.isEmpty)
                                        Padding(
                                          padding: const EdgeInsets.all(40),
                                          child: Center(
                                            child: text(
                                              'No customer data available',
                                              color: AppColors.grey,
                                            ),
                                          ),
                                        )
                                      else
                                        ...topCustomers.asMap().entries.map((
                                          entry,
                                        ) {
                                          final index = entry.key;
                                          final customer = entry.value;
                                          return Container(
                                            decoration: BoxDecoration(
                                              border: Border(
                                                top: BorderSide(
                                                  color: AppColors.light,
                                                ),
                                              ),
                                            ),
                                            padding: const EdgeInsets.all(20),
                                            child: Row(
                                              children: [
                                                Container(
                                                  width: 40,
                                                  height: 40,
                                                  decoration: BoxDecoration(
                                                    color: AppColors.primary
                                                        .withValues(alpha: 0.1),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          8,
                                                        ),
                                                  ),
                                                  child: Center(
                                                    child: text(
                                                      '${index + 1}',
                                                      color: AppColors.primary,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(width: 16),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      text(
                                                        customer['name'],
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: AppColors.dark,
                                                        fontSize: 14,
                                                      ),
                                                      const SizedBox(height: 4),
                                                      text(
                                                        '\$${customer['revenue'].toStringAsFixed(2)}',
                                                        color: AppColors.grey,
                                                        fontSize: 13,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Icon(
                                                  Icons.arrow_forward_ios,
                                                  size: 16,
                                                  color: AppColors.grey,
                                                ),
                                              ],
                                            ),
                                          );
                                        }),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 24),

                          // Additional Insights Row
                          Row(
                            children: [
                              Expanded(
                                child: _buildInsightCard(
                                  'Active Quotations',
                                  '${quotations.where((q) => q.status != 'REJECTED').length}',
                                  Icons.description,
                                  AppColors.primary,
                                  'Pending conversion',
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: _buildInsightCard(
                                  'Total Customers',
                                  '${userProvider.users.length}',
                                  Icons.people,
                                  AppColors.info,
                                  'Active accounts',
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: _buildInsightCard(
                                  'Products in Stock',
                                  '${productProvider.products.where((p) => p.openingStock > 0).length}',
                                  Icons.inventory,
                                  AppColors.success,
                                  'Available items',
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: _buildInsightCard(
                                  'Low Stock Alerts',
                                  '${productProvider.products.where((p) => p.openingStock <= p.minimumStockLevel).length}',
                                  Icons.warning,
                                  AppColors.danger,
                                  'Need reorder',
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

  Widget _buildPeriodSelector() {
    return Container(
      // padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.light),
      ),
      child: DropdownButton<String>(
        value: selectedPeriod,
        underline: const SizedBox(),
        icon: Icon(Icons.arrow_drop_down, color: AppColors.dark),
        items: ['Today', 'This Week', 'This Month', 'This Year', 'All Time']
            .map(
              (period) => DropdownMenuItem(
                value: period,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: text(period, color: AppColors.dark, fontSize: 14),
                ),
              ),
            )
            .toList(),
        onChanged: (value) {
          setState(() {
            selectedPeriod = value!;
          });
        },
      ),
    );
  }

  Widget _buildMetricCard(
    String title,
    String value,
    IconData icon,
    Color color,
    String change,
    bool isPositive,
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              text(title, color: AppColors.grey, fontSize: 14),
              Icon(
                isPositive ? Icons.trending_up : Icons.trending_down,
                color: isPositive ? AppColors.success : AppColors.danger,
                size: 24,
              ),
            ],
          ),
          const SizedBox(height: 16),

          h1(value),
          const SizedBox(height: 8),
          text(
            change,
            color: isPositive ? AppColors.success : AppColors.danger,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ],
      ),
    );
  }

  Widget _buildChartCard(String title, Widget chart) {
    return Container(
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
          Padding(padding: const EdgeInsets.all(20), child: h2(title)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: chart,
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 6),
        text(label, color: AppColors.dark, fontSize: 12),
      ],
    );
  }

  Widget _buildInsightCard(
    String title,
    String value,
    IconData icon,
    Color color,
    String subtitle,
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
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                h2(value),
                const SizedBox(height: 4),
                text(title, color: AppColors.grey, fontSize: 13),
                text(subtitle, color: AppColors.grey, fontSize: 11),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
