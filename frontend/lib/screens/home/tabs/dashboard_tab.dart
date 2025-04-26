import 'package:flutter/material.dart';
import 'package:frontend/models/expense.dart';
import 'package:frontend/services/expense_service.dart';
import 'package:frontend/widgets/expense_grid.dart';
import 'package:frontend/widgets/expense_summary_card.dart';
import 'package:frontend/widgets/recent_expenses_list.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class DashboardTab extends StatefulWidget {
  const DashboardTab({super.key});

  @override
  State<DashboardTab> createState() => _DashboardTabState();
}

class _DashboardTabState extends State<DashboardTab> {
  // Current month for filtering expenses
  DateTime _selectedMonth = DateTime.now();
  
  // Format for displaying month and year
  final DateFormat _monthYearFormat = DateFormat('MMMM yyyy');
  
  // Change selected month
  void _changeMonth(int months) {
    setState(() {
      _selectedMonth = DateTime(
        _selectedMonth.year,
        _selectedMonth.month + months,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final expenseService = Provider.of<ExpenseService>(context);
    final expenses = expenseService.getExpensesForMonth(_selectedMonth);
    final totalAmount = expenseService.getTotalForMonth(_selectedMonth);
    final expensesByCategory = expenseService.getExpensesByCategoryForMonth(_selectedMonth);
    
    // Get top 3 categories by amount
    final topCategories = expensesByCategory.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    
    return RefreshIndicator(
      onRefresh: () => expenseService.fetchExpenses(),
      child: expenseService.isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Month selector
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.chevron_left),
                        onPressed: () => _changeMonth(-1),
                      ),
                      Text(
                        _monthYearFormat.format(_selectedMonth),
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      IconButton(
                        icon: const Icon(Icons.chevron_right),
                        onPressed: () => _changeMonth(1),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  // Monthly summary
                  ExpenseSummaryCard(
                    title: 'Monthly Expenses',
                    amount: totalAmount,
                    expenseCount: expenses.length,
                  ),
                  const SizedBox(height: 24),
                  
                  // Top categories section
                  Text(
                    'Top Categories',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  
                  // Top categories cards
                  SizedBox(
                    height: 100,
                    child: topCategories.isEmpty
                        ? const Center(
                            child: Text('No expenses this month'),
                          )
                        : ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: topCategories.length > 3 ? 3 : topCategories.length,
                            itemBuilder: (context, index) {
                              final category = topCategories[index].key;
                              final amount = topCategories[index].value;
                              return Card(
                                margin: const EdgeInsets.only(right: 8),
                                child: Container(
                                  width: 150,
                                  padding: const EdgeInsets.all(12),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(
                                            category.icon,
                                            color: category.color,
                                            size: 20,
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            category.displayName,
                                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const Spacer(),
                                      Text(
                                        '\$${amount.toStringAsFixed(2)}',
                                        style: Theme.of(context).textTheme.titleMedium,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Daily expenses grid
                  Text(
                    'Daily Expenses',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  
                  // Grid showing daily expenses
                  ExpenseGrid(
                    month: _selectedMonth,
                    dailyTotals: expenseService.getDailyTotalsForMonth(_selectedMonth),
                  ),
                  const SizedBox(height: 24),
                  
                  // Recent expenses section
                  Text(
                    'Recent Expenses',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  
                  // List of recent expenses
                  RecentExpensesList(
                    expenses: expenses.take(5).toList(),
                  ),
                ],
              ),
            ),
    );
  }
}
