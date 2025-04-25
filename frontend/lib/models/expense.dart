import 'package:intl/intl.dart';

class Expense {
  final int? id;
  final int userId;
  final double amount;
  final String category;
  final DateTime date;
  final String? notes;

  Expense({
    this.id,
    required this.userId,
    required this.amount,
    required this.category,
    required this.date,
    this.notes,
  });

  factory Expense.fromJson(Map<String, dynamic> json) {
    // Validate required fields
    if (!json.containsKey('id') ||
        !json.containsKey('user_id') ||
        !json.containsKey('amount') ||
        !json.containsKey('category') ||
        !json.containsKey('date')) {
      throw Exception('Missing required fields in JSON');
    }

    return Expense(
      id: json['id'] is int
          ? json['id']
          : int.parse(json['id'].toString()), 
      userId: json['user_id'] is int
          ? json['user_id']
          : int.parse(json['user_id'].toString()),
      amount: json['amount'] is num
          ? json['amount'].toDouble()
          : double.parse(json['amount'].toString()),
      category: json['category'].toString(), 
      date: DateTime.tryParse(json['date']) ??
          (throw Exception('Invalid date format: ${json['date']}')),
      notes:
          json['notes']?.toString(), 
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'amount': amount,
      'category': category,
      'date': DateFormat('yyyy-MM-dd').format(date),
      'notes': notes,
    };
  }
}