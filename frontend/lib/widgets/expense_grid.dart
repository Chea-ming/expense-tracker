import 'package:flutter/material.dart';

class ExpenseGrid extends StatelessWidget {
  final DateTime month;
  final Map<int, double> dailyTotals;
  
  const ExpenseGrid({
    super.key,
    required this.month,
    required this.dailyTotals,
  });

  @override
  Widget build(BuildContext context) {
    // Get number of days in month
    final daysInMonth = DateTime(
      month.year,
      month.month + 1,
      0,
    ).day;
    
    // Get first day of month
    final firstDay = DateTime(month.year, month.month, 1);
    final firstDayOfWeek = firstDay.weekday % 7; // 0 = Sunday, 6 = Saturday
    
    // Calculate grid dimensions
    final numRows = ((daysInMonth + firstDayOfWeek) / 7).ceil();
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Weekday headers
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: const [
                Text('S', style: TextStyle(fontWeight: FontWeight.bold)),
                Text('M', style: TextStyle(fontWeight: FontWeight.bold)),
                Text('T', style: TextStyle(fontWeight: FontWeight.bold)),
                Text('W', style: TextStyle(fontWeight: FontWeight.bold)),
                Text('T', style: TextStyle(fontWeight: FontWeight.bold)),
                Text('F', style: TextStyle(fontWeight: FontWeight.bold)),
                Text('S', style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 8),
            
            // Calendar grid
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                childAspectRatio: 1,
              ),
              itemCount: numRows * 7,
              itemBuilder: (context, index) {
                // Calculate day number
                final dayIndex = index - firstDayOfWeek;
                final day = dayIndex + 1;
                
                // Skip days before the month starts or after it ends
                if (dayIndex < 0 || day > daysInMonth) {
                  return const SizedBox.shrink();
                }
                
                // Get expense amount for this day
                final amount = dailyTotals[day] ?? 0;
                
                // Calculate color intensity based on amount
                final maxAmount = dailyTotals.values.fold<double>(
                  0, (max, value) => value > max ? value : max
                );
                final intensity = maxAmount > 0 ? (amount / maxAmount) : 0;
                
                return Container(
                  margin: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary.withOpacity(
                      amount > 0 ? 0.1 + (intensity * 0.5) : 0,
                    ),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Stack(
                    children: [
                      // Day number
                      Positioned(
                        top: 2,
                        left: 2,
                        child: Text(
                          day.toString(),
                          style: TextStyle(
                            fontSize: 10,
                            color: amount > 0
                                ? Theme.of(context).colorScheme.primary
                                : Colors.grey[600],
                          ),
                        ),
                      ),
                      // Amount (if any)
                      if (amount > 0)
                        Center(
                          child: Text(
                            '\$${amount.toStringAsFixed(0)}',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
