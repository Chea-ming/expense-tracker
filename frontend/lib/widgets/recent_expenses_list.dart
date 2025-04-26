import 'package:flutter/material.dart';
import 'package:frontend/models/expense.dart';
import 'package:frontend/screens/expense/expense_detail_screen.dart';
import 'package:intl/intl.dart';

class RecentExpensesList extends StatelessWidget {
  final List<Expense> expenses;
  
  const RecentExpensesList({
    super.key,
    required this.expenses,
  });
  
  // Format date
  String _formatDate(DateTime date) {
    return DateFormat('MMM dd').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: expenses.isEmpty
          ? const Padding(
              padding: EdgeInsets.all(16),
              child: Center(
                child: Text('No expenses this month'),
              ),
            )
          : ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: expenses.length,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final expense = expenses[index];
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
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '\$${expense.amount.toStringAsFixed(2)}',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text(
                        _formatDate(expense.date),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => ExpenseDetailScreen(expense: expense),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
