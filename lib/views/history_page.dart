import 'package:flutter/material.dart';
import '../controllers/expense_controller.dart';
import '../utils/theme.dart';
import 'package:intl/intl.dart';

class HistoryPage extends StatelessWidget {
  final ExpenseController controller;

  const HistoryPage({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Monthly History'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: AnimatedBuilder(
        animation: controller,
        builder: (context, child) {
          final summary = controller.getMonthlySummary();
          final keys = summary.keys.toList()
            ..sort((a, b) {
              final dateA = DateFormat('MMMM yyyy').parse(a);
              final dateB = DateFormat('MMMM yyyy').parse(b);
              return dateB.compareTo(dateA); 
            });

          if (keys.isEmpty) {
            return const Center(
              child: Text(
                'No history available',
                style: TextStyle(fontSize: 18, color: AppTheme.textSecondary),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: keys.length,
            itemBuilder: (ctx, index) {
              final month = keys[index];
              final data = summary[month]!;
              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        month,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      const Divider(height: 24, thickness: 1),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Salary', style: TextStyle(color: AppTheme.textSecondary)),
                              const SizedBox(height: 4),
                              Text(
                                '₹${data['salary']!.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.primaryColor,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const Text('Expense', style: TextStyle(color: AppTheme.textSecondary)),
                              const SizedBox(height: 4),
                              Text(
                                '₹${data['expense']!.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.errorColor,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
