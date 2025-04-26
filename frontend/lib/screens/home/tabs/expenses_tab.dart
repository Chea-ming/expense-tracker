import 'package:flutter/material.dart';
import 'package:frontend/models/expense.dart';
import 'package:frontend/screens/expense/expense_detail_screen.dart';
import 'package:frontend/services/expense_service.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class ExpensesTab extends StatefulWidget {
  const ExpensesTab({super.key});

  @override
  State<ExpensesTab> createState() => _ExpensesTabState();
}

class _ExpensesTabState extends State<ExpensesTab> {
  // Selected filter category
  ExpenseCategory? _selectedCategory;
  
  // Date formatters
  final DateFormat _dateFormat = DateFormat('MMM dd, yyyy');
  // ignore: unused_field
  final DateFormat _monthFormat = DateFormat('MMMM yyyy');
  
  // Group expenses by date
  Map<String, List<Expense>> _groupExpensesByDate(List<Expense> expenses) {
    final Map<String, List<Expense>> grouped = {};
    
    for (final expense in expenses) {
      final dateKey = _dateFormat.format(expense.date);
      if (!grouped.containsKey(dateKey)) {
        grouped[dateKey] = [];
      }
      grouped[dateKey]!.add(expense);
    }
    
    return grouped;
  }
  
  // Filter expenses by category
  List<Expense> _filterExpenses(List<Expense> expenses) {
    if (_selectedCategory == null) {
      return expenses;
    }
    return expenses.where((e) => e.category == _selectedCategory).toList();
  }

  @override
  Widget build(BuildContext context) {
    final expenseService = Provider.of<ExpenseService>(context);
    final allExpenses = expenseService.expenses;
    final filteredExpenses = _filterExpenses(allExpenses);
    final groupedExpenses = _groupExpensesByDate(filteredExpenses);
    
    return Scaffold(
      body: Column(
        children: [
          // Category filter chips
          Padding(
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  // All categories chip
                  FilterChip(
                    label: const Text('All'),
                    selected: _selectedCategory == null,
                    onSelected: (selected) {
                      setState(() {
                        _selectedCategory = null;
                      });
                    },
                  ),
                  const SizedBox(width: 8),
                  
                  // Category chips
                  ...ExpenseCategory.values.map((category) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: FilterChip(
                        label: Text(category.displayName),
                        selected: _selectedCategory == category,
                        avatar: Icon(
                          category.icon,
                          size: 16,
                          color: _selectedCategory == category
                              ? Colors.white
                              : category.color,
                        ),
                        onSelected: (selected) {
                          setState(() {
                            _selectedCategory = selected ? category : null;
                          });
                        },
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
          
          // Expenses list
          Expanded(
            child: expenseService.isLoading
                ? const Center(child: CircularProgressIndicator())
                : filteredExpenses.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.receipt_long,
                              size: 64,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No expenses found',
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: Colors.grey[600],
                              ),
                            ),
                            if (_selectedCategory != null)
                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    _selectedCategory = null;
                                  });
                                },
                                child: const Text('Clear filter'),
                              ),
                          ],
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: () => expenseService.fetchExpenses(),
                        child: ListView.builder(
                          padding: const EdgeInsets.only(bottom: 80),
                          itemCount: groupedExpenses.length,
                          itemBuilder: (context, index) {
                            final dateKey = groupedExpenses.keys.elementAt(index);
                            final expenses = groupedExpenses[dateKey]!;
                            
                            // Calculate total for this date
                            final total = expenses.fold<double>(
                              0, (sum, expense) => sum + expense.amount
                            );
                            
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Date header
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        dateKey,
                                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        '\$${total.toStringAsFixed(2)}',
                                        style: Theme.of(context).textTheme.titleSmall,
                                      ),
                                    ],
                                  ),
                                ),
                                
                                // Expenses for this date
                                ...expenses.map((expense) {
                                  return ListTile(
                                    leading: CircleAvatar(
                                      backgroundColor: expense.category.color.withOpacity(0.2),
                                      child: Icon(
                                        expense.category.icon,
                                        color: expense.category.color,
                                        size: 20,
                                      ),
                                    ),
                                    title: Text(expense.category.displayName),
                                    subtitle: expense.notes != null && expense.notes!.isNotEmpty
                                        ? Text(
                                            expense.notes!,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          )
                                        : null,
                                    trailing: Text(
                                      '\$${expense.amount.toStringAsFixed(2)}',
                                      style: Theme.of(context).textTheme.titleMedium,
                                    ),
                                    onTap: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (_) => ExpenseDetailScreen(expense: expense),
                                        ),
                                      );
                                    },
                                  );
                                }),
                                
                                // Divider between dates
                                const Divider(),
                              ],
                            );
                          },
                        ),
                      ),
          ),
        ],
      ),
    );
  }
}
