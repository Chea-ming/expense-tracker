import 'package:flutter/material.dart';
import 'package:frontend/models/expense.dart';
import 'package:frontend/services/expense_service.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class ExpenseDetailScreen extends StatelessWidget {
  final Expense expense;
  
  const ExpenseDetailScreen({
    super.key,
    required this.expense,
  });
  
  // Format date
  String _formatDate(DateTime date) {
    return DateFormat('MMMM dd, yyyy').format(date);
  }
  
  // Delete expense
  Future<void> _deleteExpense(BuildContext context) async {
    // Show confirmation dialog
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Expense'),
        content: const Text('Are you sure you want to delete this expense?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    
    // Delete if confirmed
    if (confirm == true) {
      final expenseService = Provider.of<ExpenseService>(context, listen: false);
      final success = await expenseService.deleteExpense(expense.id!);
      
      if (success && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Expense deleted successfully'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Expense Details'),
        actions: [
          // Delete button
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => _deleteExpense(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Amount card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text(
                      'Amount',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '\$${expense.amount.toStringAsFixed(2)}',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            
            // Details list
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Category
                    ListTile(
                      leading: CircleAvatar(
                        backgroundColor: expense.category.color.withOpacity(0.2),
                        child: Icon(
                          expense.category.icon,
                          color: expense.category.color,
                        ),
                      ),
                      title: const Text('Category'),
                      subtitle: Text(expense.category.displayName),
                      contentPadding: EdgeInsets.zero,
                    ),
                    const Divider(),
                    
                    // Date
                    ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.blue.withOpacity(0.2),
                        child: const Icon(
                          Icons.calendar_today,
                          color: Colors.blue,
                        ),
                      ),
                      title: const Text('Date'),
                      subtitle: Text(_formatDate(expense.date)),
                      contentPadding: EdgeInsets.zero,
                    ),
                    
                    // Notes (if available)
                    if (expense.notes != null && expense.notes!.isNotEmpty) ...[
                      const Divider(),
                      ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.green.withOpacity(0.2),
                          child: const Icon(
                            Icons.note,
                            color: Colors.green,
                          ),
                        ),
                        title: const Text('Notes'),
                        subtitle: Text(expense.notes!),
                        contentPadding: EdgeInsets.zero,
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
