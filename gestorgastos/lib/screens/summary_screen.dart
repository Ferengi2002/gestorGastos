import 'package:flutter/material.dart';
import 'package:gestorgastos/models/expense_data.dart';
import 'package:gestorgastos/screens/transaction_form_screen.dart';
import 'package:gestorgastos/widgets/expense_chart.dart';

class SummaryScreen extends StatelessWidget {
  const SummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final List<ExpenseData> expensesData = [
      ExpenseData(
        category: 'Comida',
        amount: 150.0,
        date: DateTime.now(),
      ),
      ExpenseData(
        category: 'Transporte',
        amount: 50.0,
        date: DateTime.now(),
      ),
      ExpenseData(
        category: 'Salud',
        amount: 100.0,
        date: DateTime.now(),
      ),
      // Agrega más datos de ejemplo si es necesario
    ];


    return Scaffold(
      appBar: AppBar(
        title: const Text('Resumen de Gastos'),
        centerTitle: true,
      ),
      body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Resumen de Gastos',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  )),
              const SizedBox(height: 20.0),
              Card(
                child: ListTile(
                  leading:
                      Icon(Icons.arrow_upward_outlined, color: Colors.green),
                  title: const Text('Ingresos'),
                  subtitle: Text('\$0.0'),
                ),
              ),
              const SizedBox(height: 20.0),
              Card(
                child: ListTile(
                  leading:
                      Icon(Icons.arrow_downward_outlined, color: Colors.red),
                  title: const Text('Gastos'),
                  subtitle: Text('\$0.0'),
                ),
              ),
              SizedBox(height: 20.0),
              ExpenseChart(
                data: expensesData, expenses: expensesData,
              ),
              SizedBox(height: 20.0),
              Center(
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TransactionFormScreen(),
                      ),
                    );
                  },
                  icon: Icon(Icons.add),
                  label: Text('Agregar Transacción'),
                ),
              )
            ],
          )),
    );
  }
}
