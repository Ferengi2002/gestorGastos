import 'package:exprense_tracker/services/database_helper.dart';
import 'package:flutter/material.dart';
import 'package:exprense_tracker/models/transaction.dart';

class TransactionProvider with ChangeNotifier {
  List<Transaction> _transactions = [];
  final DatabaseHelper _dbHelper = DatabaseHelper();

  List<Transaction> get transactions => _transactions;

  Future<void> loadTransactions() async {
    _transactions = await _dbHelper.getTransactions();
    notifyListeners();
  }

  Future<void> addTransaction(Transaction transaction) async {
    _transactions.add(transaction);
    await _dbHelper.insertTransaction(transaction);
    notifyListeners();
  }

  Future<void> deleteTransaction(String id) async {
    _transactions.removeWhere((t) => t.id == id);
    await _dbHelper.deleteTransaction(id);
    notifyListeners();
  }

  Future<void> updateTransaction(Transaction transaction) async {
    final index = _transactions.indexWhere((t) => t.id == transaction.id);
    if (index != -1) {
      _transactions[index] = transaction;
      await _dbHelper.updateTransactions(transaction);
      notifyListeners();
    }
  }
}
