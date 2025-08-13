import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:exprense_tracker/models/transaction.dart' as my_transaction;
// ignore: depend_on_referenced_packages
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final path = join(await getDatabasesPath(), 'transactions.db');
    if (kDebugMode) print('Ruta de la base de datos: $path');
    return await openDatabase(
      path,
      version: 2,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE transactions (
      id TEXT PRIMARY KEY,
      category TEXT,
      description TEXT,
      amount REAL,
      type TEXT,
      date TEXT
    )
  ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('ALTER TABLE transactions ADD COLUMN description TEXT;');
    }
  }

  Future<void> insertTransaction(my_transaction.Transaction t) async {
    final db = await database;
    await db.insert('transactions', t.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<my_transaction.Transaction>> getTransactions() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('transactions');
    return List.generate(maps.length, (i) {
      return my_transaction.Transaction(
        id: maps[i]['id'] as String,
        category: maps[i]['category'] as String,
        description: (maps[i]['description'] ?? '') as String,
        amount: (maps[i]['amount'] as num).toDouble(),
        type: (maps[i]['type'] == 'income')
            ? my_transaction.TransactionType.income
            : my_transaction.TransactionType.expense,
        date: DateTime.parse(maps[i]['date'] as String),
      );
    });
  }

  Future<void> deleteTransaction(String id) async {
    final db = await database;
    await db.delete('transactions', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> updateTransactions(my_transaction.Transaction t) async {
    final db = await database;
    await db
        .update('transactions', t.toMap(), where: 'id = ?', whereArgs: [t.id]);
  }
}
