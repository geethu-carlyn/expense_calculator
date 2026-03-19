import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/expense.dart';
import '../models/income.dart';

class StorageService {
  static const String _expensesKey = 'expenses_data';
  static const String _incomesKey = 'incomes_data';

  // Save expenses list
  static Future<void> saveExpenses(List<Expense> expenses) async {
    final prefs = await SharedPreferences.getInstance();
    final String encodedData = json.encode(
      expenses.map((expense) => expense.toJson()).toList(),
    );
    await prefs.setString(_expensesKey, encodedData);
  }

  // Load expenses list
  static Future<List<Expense>> loadExpenses() async {
    final prefs = await SharedPreferences.getInstance();
    final String? expensesString = prefs.getString(_expensesKey);
    
    if (expensesString != null) {
      final List<dynamic> decodedData = json.decode(expensesString);
      return decodedData.map((item) => Expense.fromJson(item)).toList();
    }
    return [];
  }

  // Save incomes list
  static Future<void> saveIncomes(List<Income> incomes) async {
    final prefs = await SharedPreferences.getInstance();
    final String encodedData = json.encode(
      incomes.map((income) => income.toJson()).toList(),
    );
    await prefs.setString(_incomesKey, encodedData);
  }

  // Load incomes list
  static Future<List<Income>> loadIncomes() async {
    final prefs = await SharedPreferences.getInstance();
    final String? incomesString = prefs.getString(_incomesKey);
    
    if (incomesString != null) {
      final List<dynamic> decodedData = json.decode(incomesString);
      return decodedData.map((item) => Income.fromJson(item)).toList();
    }
    return [];
  }
}
