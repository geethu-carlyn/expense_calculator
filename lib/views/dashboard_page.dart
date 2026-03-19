import 'package:flutter/material.dart';
import '../controllers/expense_controller.dart';
import '../utils/theme.dart';
import 'widgets/expense_list_item.dart';
import 'widgets/add_expense_dialog.dart';
import 'history_page.dart';
import 'package:intl/intl.dart';
import 'dart:math' as math;

class DashboardPage extends StatefulWidget {
  final ExpenseController controller;

  const DashboardPage({Key? key, required this.controller}) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  late List<Color> _dashboardGradient;

  final List<List<Color>> _gradientOptions = [
    [AppTheme.primaryColor, AppTheme.primaryLight],
    [Colors.blue.shade800, Colors.blue.shade400],
    [Colors.teal.shade800, Colors.teal.shade400],
    [Colors.orange.shade800, Colors.orange.shade400],
    [Colors.pink.shade800, Colors.pink.shade400],
    [Colors.indigo.shade800, Colors.indigo.shade400],
    [Colors.green.shade800, Colors.green.shade400],
  ];

  @override
  void initState() {
    super.initState();
    final random = math.Random();
    _dashboardGradient = _gradientOptions[random.nextInt(_gradientOptions.length)];
  }

  void _startAddNewExpense(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      isScrollControlled: true, // Allows the sheet to take up full screen height if needed
      backgroundColor: Colors.transparent, // To show the custom rounded corners of the dialogue
      builder: (_) {
        return AddExpenseDialog(
          onAddExpense: (expense) {
            widget.controller.addExpense(expense);
          },
        );
      },
    );
  }

  void _showAddMoneyDialog(BuildContext ctx) {
    final amountController = TextEditingController();
    showDialog(
      context: ctx,
      builder: (context) => AlertDialog(
        title: const Text('Add Money in Hand'),
        content: TextField(
          controller: amountController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: const InputDecoration(labelText: 'Amount', prefixText: '₹'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final amount = double.tryParse(amountController.text) ?? 0.0;
              if (amount > 0) {
                widget.controller.addTotalMoneyInHand(amount);
              }
              Navigator.of(context).pop();
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true, // Allow gradient to flow under the appbar
      appBar: AppBar(
        title: const Text('Dashboard'),
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => HistoryPage(controller: widget.controller)),
              );
            },
          ),
        ],
      ),
      body: SizedBox.expand(
        child: Stack(
        children: [
          // Background Gradient
          Container(
            height: 300,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: _dashboardGradient,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40),
              ),
            ),
          ),
          Positioned.fill(
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                const SizedBox(height: 10),
                Center(
                  child: Text(
                    DateFormat('MMMM yyyy').format(DateTime.now()),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.white70,
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                // Balance Card
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: AnimatedBuilder(
                    animation: widget.controller,
                    builder: (context, child) {
                      if (widget.controller.isLoading) {
                        return Card(
                         shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          elevation: 10,
                          child: Padding(
                            padding: const EdgeInsets.all(32),
                            child: const Center(child: CircularProgressIndicator()),
                          )
                        );
                      }
                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 10,
                        shadowColor: Colors.black26,
                        child: Padding(
                          padding: const EdgeInsets.all(32),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Money in Hand',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: AppTheme.textSecondary,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Row(
                                        children: [
                                          Text(
                                            '₹${widget.controller.totalMoneyInHand.toStringAsFixed(2)}',
                                            style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: AppTheme.textPrimary,
                                            ),
                                          ),
                                          IconButton(
                                            icon: const Icon(Icons.add_circle, size: 24, color: AppTheme.primaryColor),
                                            onPressed: () => _showAddMoneyDialog(context),
                                            padding: const EdgeInsets.only(left: 4),
                                            constraints: const BoxConstraints(),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      const Text(
                                        'Total Expense',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: AppTheme.textSecondary,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        '₹${widget.controller.totalExpense.toStringAsFixed(2)}',
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: AppTheme.errorColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              const Text(
                                'Remaining Balance',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: AppTheme.textSecondary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '₹${widget.controller.remainingBalance.toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontSize: 40,
                                  fontWeight: FontWeight.bold,
                                  color: widget.controller.remainingBalance >= 0 
                                      ? AppTheme.primaryColor 
                                      : AppTheme.errorColor,
                                  letterSpacing: -1,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 30),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    'Recent Expenses',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                // Expense List
                Expanded(
                  child: AnimatedBuilder(
                    animation: widget.controller,
                    builder: (context, child) {
                      if (widget.controller.isLoading) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      final expenses = widget.controller.expenses;
                      if (expenses.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.receipt_long, size: 80, color: Colors.grey.shade400),
                              const SizedBox(height: 16),
                              Text(
                                'No expenses yet!',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey.shade600,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                      
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          if (widget.controller.lastAddedExpense != null)
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                              child: Text(
                                'Last Added:',
                                style: TextStyle(
                                  color: AppTheme.primaryColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          Expanded(
                            child: ListView.builder(
                              padding: const EdgeInsets.only(bottom: 80, top: 0), // Space for FAB
                              itemCount: expenses.length,
                              itemBuilder: (ctx, index) {
                                final expense = expenses[index];
                                return ExpenseListItem(
                                  key: ValueKey(expense.id),
                                  expense: expense,
                                  onDelete: () {
                                    widget.controller.removeExpense(expense.id);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Expense deleted'),
                                        duration: Duration(seconds: 2),
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          ),
        ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _startAddNewExpense(context),
        child: const Icon(Icons.add, size: 28),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

