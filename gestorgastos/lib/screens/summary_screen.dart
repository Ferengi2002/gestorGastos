import 'package:exprense_tracker/models/transaction.dart';
import 'package:exprense_tracker/providers/transaction_provider.dart';

import 'package:exprense_tracker/screens/transaction_form_screen.dart';
import 'package:exprense_tracker/screens/transaction_history_screen.dart';
import 'package:exprense_tracker/widgets/expense_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SummaryScreen extends StatefulWidget {
  const SummaryScreen({super.key});

  @override
  State<SummaryScreen> createState() => _SummaryScreenState();
}

class _SummaryScreenState extends State<SummaryScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<TransactionProvider>(context, listen: false).loadTransactions();
  }

  @override
  Widget build(BuildContext context) {
    final transactionProvider = Provider.of<TransactionProvider>(context);
    final transactions = transactionProvider.transactions;

    final totalIncome = transactions
        .where((transaction) => transaction.type == TransactionType.income)
        .fold(0.0, (sum, transaction) => sum + transaction.amount);

    final totalExpenses = transactions
        .where((transaction) => transaction.type == TransactionType.expense)
        .fold(0.0, (sum, transaction) => sum + transaction.amount);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Resumen de Gastos'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (expenseData) =>
                          const TransactionHistoryScreen()));
            },
            icon: const Icon(Icons.history),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Resumen del Mes',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Card(
                child: ListTile(
              leading:
                  const Icon(Icons.arrow_upward_outlined, color: Colors.green),
              title: const Text('Ingresos'),
              subtitle: Text('\$${totalIncome.toStringAsFixed(2)}'),
            )),
            const SizedBox(height: 20),
            Card(
              child: ListTile(
                leading: const Icon(Icons.arrow_downward_outlined,
                    color: Colors.red),
                title: const Text('Gastos'),
                subtitle: Text('\$${totalExpenses.toStringAsFixed(2)}'),
              ),
            ),
            const SizedBox(height: 20),
            const ExpenseChart(),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton.icon(
                onPressed: () async {
                  final created = await Navigator.push<bool>(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const TransactionFormScreen()),
                  );
                  if (created == true && context.mounted) {
                    await Provider.of<TransactionProvider>(context,
                            listen: false)
                        .loadTransactions();
                  }
                },
                icon: const Icon(Icons.add, color: Colors.white),
                label: const Text(
                  'Añadir Transaccion',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
