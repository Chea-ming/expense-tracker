import 'package:flutter/foundation.dart';
import 'package:frontend/models/expense.dart';
import 'package:frontend/services/api_client.dart';

// Service for managing expenses
class ExpenseService extends ChangeNotifier {
  List<Expense> _expenses = [];
  bool _isLoading = false;
  String? _error;
  
  // Getters
  List<Expense> get expenses => _expenses;
  bool get isLoading => _isLoading;
  String? get error => _error;
  
  // Fetch all expenses for the current user
  Future<void> fetchExpenses() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    try {
      final response = await ApiClient().get('/expenses');

      // Parse response data
      final Map<String, dynamic> responseData = response.data;
      final List<dynamic> expensesJson = responseData['expenses'] ?? [];

      // Map JSON data to Expense objects
      _expenses = expensesJson.map((json) => Expense.fromJson(json)).toList();
      
      // Sort expenses by date (newest first)
      _expenses.sort((a, b) => b.date.compareTo(a.date));
    } catch (e) {
      _error = 'Failed to fetch expenses';
      if (kDebugMode) {
        print('Fetch expenses error: $e');
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  // Add a new expense
  Future<bool> addExpense(Expense expense) async {
    _isLoading = true;
    _error = null;
    dynamic newExpense1;
    notifyListeners();
    
    try {
      final response = await ApiClient().post('/expenses', data: expense.toJson());

      _expenses.insert(0, expense); // Add to beginning of list
      newExpense1 = response.data;
      
      return true;
    } catch (e) {
      _error = 'Failed to add expense';
      if (kDebugMode) {
        print('New expense: $newExpense1');
        print('Add expense error: $e');
      }
      return false;
    } finally {
      _isLoading = false;
      await fetchExpenses();
      notifyListeners();
    }
  }
  
  // Update an existing expense
  Future<bool> updateExpense(Expense expense) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    try {
      await ApiClient().put('/expenses/${expense.id}', data: expense.toJson());
      
      // Update expense in list
      final index = _expenses.indexWhere((e) => e.id == expense.id);
      if (index != -1) {
        _expenses[index] = expense;
      }
      
      return true;
    } catch (e) {
      _error = 'Failed to update expense';
      if (kDebugMode) {
        print('Update expense error: $e');
      }
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  // Delete an expense
  Future<bool> deleteExpense(int id) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    try {
      await ApiClient().delete('/expenses/$id');
      
      // Remove expense from list
      _expenses.removeWhere((e) => e.id == id);
      
      return true;
    } catch (e) {
      _error = 'Failed to delete expense';
      if (kDebugMode) {
        print('Delete expense error: $e');
      }
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  // Get expenses for a specific month
  List<Expense> getExpensesForMonth(DateTime month) {
    return _expenses.where((expense) => 
      expense.date.year == month.year && 
      expense.date.month == month.month
    ).toList();
  }
  
  // Get total amount spent in a specific month
  double getTotalForMonth(DateTime month) {
    return getExpensesForMonth(month).fold(
      0, (total, expense) => total + expense.amount
    );
  }
  
  // Get expenses grouped by day for a specific month
  Map<int, List<Expense>> getExpensesByDayForMonth(DateTime month) {
    final expensesForMonth = getExpensesForMonth(month);
    final Map<int, List<Expense>> result = {};
    
    for (final expense in expensesForMonth) {
      final day = expense.date.day;
      if (!result.containsKey(day)) {
        result[day] = [];
      }
      result[day]!.add(expense);
    }
    
    return result;
  }
  
  // Get daily totals for a specific month
  Map<int, double> getDailyTotalsForMonth(DateTime month) {
    final expensesByDay = getExpensesByDayForMonth(month);
    final Map<int, double> result = {};
    
    expensesByDay.forEach((day, expenses) {
      result[day] = expenses.fold(
        0, (total, expense) => total + expense.amount
      );
    });
    
    return result;
  }
  
  // Get expenses by category for a specific month
  Map<ExpenseCategory, double> getExpensesByCategoryForMonth(DateTime month) {
    final expensesForMonth = getExpensesForMonth(month);
    final Map<ExpenseCategory, double> result = {};
    
    for (final expense in expensesForMonth) {
      if (!result.containsKey(expense.category)) {
        result[expense.category] = 0;
      }
      result[expense.category] = result[expense.category]! + expense.amount;
    }
    
    return result;
  }
}
