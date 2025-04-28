import 'package:flutter/material.dart';
import 'package:frontend/models/expense.dart';
import 'package:frontend/services/auth_service.dart';
import 'package:frontend/services/expense_service.dart';
import 'package:frontend/widgets/custom_text_field.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class AddExpenseScreen extends StatefulWidget {
  const AddExpenseScreen({super.key});

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _notesController = TextEditingController();
  
  // Default values
  ExpenseCategory _selectedCategory = ExpenseCategory.food;
  DateTime _selectedDate = DateTime.now();
  
  // Date formatter
  final DateFormat _dateFormat = DateFormat('MMM dd, yyyy');
  
  @override
  void dispose() {
    // Clean up controllers when the widget is disposed
    _amountController.dispose();
    _notesController.dispose();
    super.dispose();
  }
  
  // Show date picker
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }
  
  // Save expense
  Future<void> _saveExpense() async {
    // Validate form
    if (_formKey.currentState!.validate()) {
      final authService = Provider.of<AuthService>(context, listen: false);
      final expenseService = Provider.of<ExpenseService>(context, listen: false);

      if (authService.currentUser == null || authService.currentUser!.id == 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('User not logged in. Please log in again.')),
        );
      }
    
      // Create expense object
      final expense = Expense(
        userId: authService.currentUser!.id,
        amount: double.parse(_amountController.text),
        category: _selectedCategory,
        date: _selectedDate,
        notes: _notesController.text.isNotEmpty ? _notesController.text : null,
      );
      
      // Add expense
      final success = await expenseService.addExpense(expense);
      
      // Show success message and close screen
      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Expense added successfully'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final expenseService = Provider.of<ExpenseService>(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Expense'),
        
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Amount field
            CustomTextField(
              controller: _amountController,
              labelText: 'Amount',
              prefixIcon: Icons.attach_money,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter an amount';
                }
                if (double.tryParse(value) == null) {
                  return 'Please enter a valid number';
                }
                if (double.parse(value) <= 0) {
                  return 'Amount must be greater than zero';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            
            // Category selector
            Text(
              'Category',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: ExpenseCategory.values.map((category) {
                return ChoiceChip(
                  label: Text(category.displayName),
                  selected: _selectedCategory == category,
                  avatar: Icon(
                    category.icon,
                    size: 18,
                    color: _selectedCategory == category
                        ? Colors.white
                        : category.color,
                  ),
                  onSelected: (selected) {
                    if (selected) {
                      setState(() {
                        _selectedCategory = category;
                      });
                    }
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            
            // Date picker
            Text(
              'Date',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            InkWell(
              onTap: () => _selectDate(context),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Color(0xFF1E1E1E),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.calendar_today),
                    const SizedBox(width: 8),
                    Text(_dateFormat.format(_selectedDate)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            
            // Notes field
            CustomTextField(
              controller: _notesController,
              labelText: 'Notes (Optional)',
              prefixIcon: Icons.note,
              maxLines: 3,
            ),
            const SizedBox(height: 24),
            
            // Save button
            ElevatedButton(
              onPressed: expenseService.isLoading ? null : _saveExpense,
              child: expenseService.isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Text('Save Expense'),
            ),
          ],
        ),
      ),
    );
  }
}
