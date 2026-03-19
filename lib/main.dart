import 'package:flutter/material.dart';
import 'views/dashboard_page.dart';
import 'controllers/expense_controller.dart';
import 'utils/theme.dart';

void main() {
  runApp(const ExpenseTrackerApp());
}

class ExpenseTrackerApp extends StatefulWidget {
  const ExpenseTrackerApp({Key? key}) : super(key: key);

  @override
  State<ExpenseTrackerApp> createState() => _ExpenseTrackerAppState();
}

class _ExpenseTrackerAppState extends State<ExpenseTrackerApp> {
  final ExpenseController _expenseController = ExpenseController();

  @override
  void initState() {
    super.initState();
    _expenseController.loadData();
  }

  @override
  void dispose() {
    _expenseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expense Tracker',
      theme: AppTheme.lightTheme,
      home: DashboardPage(controller: _expenseController),

      debugShowCheckedModeBanner: false,
    );
  }
}
