import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/models/expense.dart';

void main() {
  test('Expense.fromJson parses valid JSON correctly', () {
    final json = {
      'id': 1,
      'user_id': 1,
      'amount': 10.5,
      'category': 'Food',
      'date': '2025-04-25',
      'notes': 'Lunch'
    };

    final expense = Expense.fromJson(json);

    expect(expense.id, 1);
    expect(expense.userId, 1);
    expect(expense.amount, 10.5);
    expect(expense.category, 'Food');
    expect(expense.date, DateTime(2025, 4, 25));
    expect(expense.notes, 'Lunch');
  });

  test('Expense.fromJson throws exception for missing fields', () {
    final json = {'id': 1, 'amount': 10.5}; // Missing user_id, category, date
    expect(() => Expense.fromJson(json), throwsException);
  });

  test('Expense.fromJson handles invalid date', () {
    final json = {
      'id': 1,
      'user_id': 1,
      'amount': 10.5,
      'category': 'Food',
      'date': 'invalid',
      'notes': null
    };
    expect(() => Expense.fromJson(json), throwsException);
  });
}
