import 'package:flutter/material.dart';
import '../models/expense.dart';
import '../models/income.dart';
import '../services/storage_service.dart';
import 'package:intl/intl.dart';

class ExpenseController extends ChangeNotifier {
  List<Expense> _expenses = [];
  List<Income> _incomes = [];
  bool _isLoading = true;

  bool get isLoading => _isLoading;

  List<Expense> get expenses => List.unmodifiable(_expenses);
  List<Income> get incomes => List.unmodifiable(_incomes);
  
  Expense? get lastAddedExpense => _expenses.isNotEmpty ? _expenses.first : null;

  double get totalMoneyInHand => _incomes.fold(0.0, (sum, item) => sum + item.amount);

  double get totalExpense {
    return _expenses.fold(0.0, (sum, item) => sum + item.amount);
  }

  double get remainingBalance => totalMoneyInHand - totalExpense;

  Future<void> loadData() async {
    _isLoading = true;
    notifyListeners();
    
    _expenses = await StorageService.loadExpenses();
    _incomes = await StorageService.loadIncomes();
    
    _isLoading = false;
    notifyListeners();
  }

  void addTotalMoneyInHand(double amount) async {
    _incomes.add(Income(
      id: DateTime.now().toString(),
      amount: amount,
      date: DateTime.now(),
    ));
    notifyListeners();
    await StorageService.saveIncomes(_incomes);
  }

  void addExpense(Expense expense) async {
    _expenses.insert(0, expense); // Add to the top of the list
    notifyListeners();
    await StorageService.saveExpenses(_expenses);
  }

  void removeExpense(String id) async {
    _expenses.removeWhere((expense) => expense.id == id);
    notifyListeners();
    await StorageService.saveExpenses(_expenses);
  }

  Map<String, Map<String, double>> getMonthlySummary() {
    final Map<String, Map<String, double>> summary = {};

    for (var income in _incomes) {
      final monthKey = DateFormat('MMMM yyyy').format(income.date);
      summary.putIfAbsent(monthKey, () => {'salary': 0.0, 'expense': 0.0});
      summary[monthKey]!['salary'] = summary[monthKey]!['salary']! + income.amount;
    }

    for (var expense in _expenses) {
      final monthKey = DateFormat('MMMM yyyy').format(expense.date);
      summary.putIfAbsent(monthKey, () => {'salary': 0.0, 'expense': 0.0});
      summary[monthKey]!['expense'] = summary[monthKey]!['expense']! + expense.amount;
    }

    return summary;
  }
}
