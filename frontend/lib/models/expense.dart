import 'package:flutter/material.dart';
// ignore: unnecessary_import
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

// Expense categories enum for type safety
enum ExpenseCategory {
  food,
  transport,
  entertainment,
  shopping,
  utilities,
  health,
  education,
  other,
}

// Extension to get display name and icon for each category
extension ExpenseCategoryExtension on ExpenseCategory {
  String get displayName {
    switch (this) {
      case ExpenseCategory.food:
        return 'Food';
      case ExpenseCategory.transport:
        return 'Transport';
      case ExpenseCategory.entertainment:
        return 'Entertainment';
      case ExpenseCategory.shopping:
        return 'Shopping';
      case ExpenseCategory.utilities:
        return 'Utilities';
      case ExpenseCategory.health:
        return 'Health';
      case ExpenseCategory.education:
        return 'Education';
      case ExpenseCategory.other:
        return 'Other';
    }
  }

  IconData get icon {
    switch (this) {
      case ExpenseCategory.food:
        return Icons.restaurant;
      case ExpenseCategory.transport:
        return Icons.directions_car;
      case ExpenseCategory.entertainment:
        return Icons.movie;
      case ExpenseCategory.shopping:
        return Icons.shopping_bag;
      case ExpenseCategory.utilities:
        return Icons.power;
      case ExpenseCategory.health:
        return Icons.medical_services;
      case ExpenseCategory.education:
        return Icons.school;
      case ExpenseCategory.other:
        return Icons.category;
    }
  }

  // Get color associated with category
  Color get color {
    switch (this) {
      case ExpenseCategory.food:
        return Colors.orange;
      case ExpenseCategory.transport:
        return Colors.blue;
      case ExpenseCategory.entertainment:
        return Colors.purple;
      case ExpenseCategory.shopping:
        return Colors.pink;
      case ExpenseCategory.utilities:
        return Colors.teal;
      case ExpenseCategory.health:
        return Colors.red;
      case ExpenseCategory.education:
        return Colors.green;
      case ExpenseCategory.other:
        return Colors.grey;
    }
  }
}

// Helper to convert string to ExpenseCategory
ExpenseCategory categoryFromString(String category) {
  return ExpenseCategory.values.firstWhere(
    (e) => e.toString().split('.').last == category.toLowerCase(),
    orElse: () => ExpenseCategory.other,
  );
}

// Expense model representing a single expense entry
class Expense {
  final int? id; // Nullable for new expenses
  final int userId;
  final double amount;
  final ExpenseCategory category;
  final DateTime date;
  final String? notes; // Optional notes

  // Constructor with named parameters
  Expense({
    this.id,
    required this.userId,
    required this.amount,
    required this.category,
    required this.date,
    this.notes,
  });

  // Factory constructor to create an Expense from JSON data
  factory Expense.fromJson(Map<String, dynamic> json) {
    return Expense(
      id: json['id'],
      userId: json['user_id'],
      amount: json['amount'].toDouble(),
      category: categoryFromString(json['category']),
      date: DateTime.parse(json['date']),
      notes: json['notes'],
    );
  }

  // Convert Expense object to JSON for API requests
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'user_id': userId,
      'amount': amount,
      'category': category.toString().split('.').last,
      'date': DateFormat('yyyy-MM-dd').format(date),
      'notes': notes,
    };
  }

  // Create a copy of this expense with modified fields
  Expense copyWith({
    int? id,
    int? userId,
    double? amount,
    ExpenseCategory? category,
    DateTime? date,
    String? notes,
  }) {
    return Expense(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      amount: amount ?? this.amount,
      category: category ?? this.category,
      date: date ?? this.date,
      notes: notes ?? this.notes,
    );
  }
}
