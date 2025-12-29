import 'package:flutter/material.dart';
import 'package:invoice_management_flutter_fe/constants/colors.dart';
import 'package:invoice_management_flutter_fe/widgets/dropdown.dart';
import 'package:invoice_management_flutter_fe/widgets/heading_text.dart';
import 'package:invoice_management_flutter_fe/widgets/input.dart';

/// Column configuration for the table
class TableColumnConfig {
  final String fieldName;
  final String displayName;
  final Widget Function(dynamic value, int index, Map<String, dynamic> rowData)?
  customWidget;
  bool bold;
  Color color;

  TableColumnConfig({
    required this.fieldName,
    required this.displayName,
    this.customWidget,
    this.bold = false,
    this.color = AppColors.black,
  });
}

/// Main reusable table widget
class ReusableDataTable extends StatefulWidget {
  final List<TableColumnConfig> columns;
  final List<Map<String, dynamic>> data;
  final bool showSerialNumber;
  final String serialNumberColumnName;
  final int rowsPerPage;
  final bool showSearch;
  final String searchHint;
  final Color? headerColor;
  final Color? evenRowColor;
  final Color? oddRowColor;

  const ReusableDataTable({
    super.key,
    required this.columns,
    required this.data,
    this.showSerialNumber = true,
    this.serialNumberColumnName = 'S.No',
    this.rowsPerPage = 10,
    this.showSearch = true,
    this.searchHint = 'Search...',
    this.headerColor,
    this.evenRowColor,
    this.oddRowColor,
  });

  @override
  State<ReusableDataTable> createState() => _ReusableDataTableState();
}

class _ReusableDataTableState extends State<ReusableDataTable> {
  late List<Map<String, dynamic>> filteredData;
  int currentPage = 0;
  late int _rowsPerPage;
  String searchQuery = '';
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    filteredData = widget.data;
    _rowsPerPage = widget.rowsPerPage;
  }

  @override
  void didUpdateWidget(ReusableDataTable oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.data != widget.data) {
      _applySearch(searchQuery);
    }
  }

  void _applySearch(String query) {
    setState(() {
      searchQuery = query.toLowerCase();
      if (searchQuery.isEmpty) {
        filteredData = widget.data;
      } else {
        filteredData = widget.data.where((row) {
          return widget.columns.any((column) {
            final value = row[column.fieldName];
            return value.toString().toLowerCase().contains(searchQuery);
          });
        }).toList();
      }
      currentPage = 0;
    });
  }

  int get totalPages => (filteredData.length / _rowsPerPage).ceil();

  List<Map<String, dynamic>> get paginatedData {
    final start = currentPage * _rowsPerPage;
    final end = (start + _rowsPerPage).clamp(0, filteredData.length);
    return filteredData.sublist(start, end);
  }

  Widget _buildCell(
    dynamic value,
    int index,
    Map<String, dynamic> rowData,
    TableColumnConfig? column,
  ) {
    if (column?.customWidget != null) {
      return column!.customWidget!(value, index, rowData);
    }

    return text(
      value?.toString() ?? '',
      fontSize: 14,
      fontWeight: column?.bold == true ? FontWeight.bold : FontWeight.normal,
      color: column?.color ?? AppColors.black,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (widget.showSearch) _buildSearchBar(),
        const SizedBox(height: 16),
        _buildTable(),
        const SizedBox(height: 16),
        _buildPagination(),
      ],
    );
  }

  Widget _buildSearchBar() {
    return input(
      placeholder: widget.searchHint,
      prefixIcon: const Icon(Icons.search, color: AppColors.primary),
      controller: searchController,
      onChanged: _applySearch,
      sufficIcon: searchQuery.isNotEmpty
          ? IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                searchController.clear();
                _applySearch('');
              },
            )
          : null,
    );
  }

  Widget _buildTable() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SizedBox(
              width: constraints.maxWidth, // 🔥 KEY FIX
              child: DataTable(
                columnSpacing: 0, // helps even distribution
                headingRowColor: WidgetStateProperty.all(
                  widget.headerColor ?? Colors.blue.shade50,
                ),
                columns: [
                  if (widget.showSerialNumber)
                    DataColumn(
                      label: SizedBox(
                        width: 60,
                        child: text(
                          widget.serialNumberColumnName,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ...widget.columns.map((column) {
                    return DataColumn(
                      label: Expanded(
                        child: text(
                          column.displayName,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  }),
                ],
                rows: paginatedData.asMap().entries.map((entry) {
                  final index = entry.key;
                  final row = entry.value;
                  final actualIndex = currentPage * _rowsPerPage + index;

                  return DataRow(
                    color: WidgetStateProperty.all(
                      index % 2 == 0
                          ? (widget.evenRowColor ?? Colors.white)
                          : (widget.oddRowColor ?? Colors.grey.shade50),
                    ),
                    cells: [
                      if (widget.showSerialNumber)
                        DataCell(
                          SizedBox(
                            width: 60,
                            child: text('${actualIndex + 1}'),
                          ),
                        ),
                      ...widget.columns.map((column) {
                        final value = row[column.fieldName];
                        return DataCell(
                          SizedBox(
                            width:
                                (constraints.maxWidth / widget.columns.length) -
                                10,
                            child: _buildCell(value, actualIndex, row, column),
                          ),
                        );
                      }),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildPagination() {
    if (filteredData.isEmpty) {
      return Center(child: text('No data available'));
    }

    final start = currentPage * _rowsPerPage + 1;
    final end = ((currentPage + 1) * _rowsPerPage).clamp(
      0,
      filteredData.length,
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        /// 🔹 LEFT SIDE (Rows per page + count)
        Row(
          children: [
            text('Rows per page', fontSize: 14),
            const SizedBox(width: 8),
            SizedBox(
              width: 130,
              child: dropdownInput<int>(
                items: [5, 10, 20, 50, 100],
                itemLabel: (value) => value.toString(),
                initialValue: _rowsPerPage,
                onChanged: (value) {
                  if (value == null) return;
                  setState(() {
                    _rowsPerPage = value;
                    currentPage = 0;
                  });
                },
                hideBorder: true,
              ),
            ),

            const SizedBox(width: 16),
            text('Showing $start-$end of ${filteredData.length}', fontSize: 14),
          ],
        ),

        /// 🔹 RIGHT SIDE (Pagination buttons)
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.first_page),
              onPressed: currentPage > 0
                  ? () => setState(() => currentPage = 0)
                  : null,
            ),
            IconButton(
              icon: const Icon(Icons.chevron_left),
              onPressed: currentPage > 0
                  ? () => setState(() => currentPage--)
                  : null,
            ),
            text('Page ${currentPage + 1} of $totalPages', fontSize: 14),
            IconButton(
              icon: const Icon(Icons.chevron_right),
              onPressed: currentPage < totalPages - 1
                  ? () => setState(() => currentPage++)
                  : null,
            ),
            IconButton(
              icon: const Icon(Icons.last_page),
              onPressed: currentPage < totalPages - 1
                  ? () => setState(() => currentPage = totalPages - 1)
                  : null,
            ),
          ],
        ),
      ],
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}

// Example usage:
/*
ReusableDataTable(
  showSerialNumber: true,
  serialNumberColumnName: 'No.',
  columns: [
    TableColumnConfig(
      fieldName: 'name',
      displayName: 'Name',
    ),
    TableColumnConfig(
      fieldName: 'email',
      displayName: 'Email',
    ),
    TableColumnConfig(
      fieldName: 'status',
      displayName: 'Status',
      customWidget: (value, index, rowData) {
        return Chip(
          label: Text(value.toString()),
          backgroundColor: value == 'Active' ? Colors.green : Colors.red,
        );
      },
    ),
    TableColumnConfig(
      fieldName: 'actions',
      displayName: 'Actions',
      customWidget: (value, index, rowData) {
        return Row(
          children: [
            IconButton(
              icon: const Icon(Icons.edit, size: 20),
              onPressed: () {
                print('Edit ${rowData['name']}');
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete, size: 20),
              onPressed: () {
                print('Delete ${rowData['name']}');
              },
            ),
          ],
        );
      },
    ),
  ],
  data: [
    {
      'name': 'John Doe',
      'email': 'john@example.com',
      'status': 'Active',
      'actions': null,
    },
    {
      'name': 'Jane Smith',
      'email': 'jane@example.com',
      'status': 'Inactive',
      'actions': null,
    },
  ],
  rowsPerPage: 10,
  showSearch: true,
  searchHint: 'Search users...',
)
*/
