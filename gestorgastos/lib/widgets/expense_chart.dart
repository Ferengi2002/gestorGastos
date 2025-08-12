import 'package:flutter/material.dart';
import 'package:gestorgastos/models/expense_data.dart'; // Asegúrate de que este modelo esté bien definido
import 'package:fl_chart/fl_chart.dart'; // Importa fl_chart

class ExpenseChart extends StatelessWidget {
  final List<ExpenseData> expenses;
  const ExpenseChart({super.key, required this.expenses, required List<ExpenseData> data});

  @override
  Widget build(BuildContext context) {
    if (expenses.isEmpty) {
      return const Center(
        child: Text('No hay gastos registrados'),
      );
    }

    final Map<String, double> categoryTotals = {};
    for (var expense in expenses) {
      categoryTotals[expense.category] =
          (categoryTotals[expense.category] ?? 0) + expense.amount;
    }
    if (categoryTotals.isEmpty) {
      return const Center(
        child: Text('No hay gastos por categoría'),
      );
    }
    List<BarChartGroupData> chartData = categoryTotals.entries.map((entry) {
      return BarChartGroupData(
        x: categoryTotals.keys
            .toList()
            .indexOf(entry.key),
        barRods: [
          BarChartRodData(
            y: entry.value,
            colors: [Colors.blue],
            width: 15,
          ),
        ],
      );
    }).toList();

    return Container(
      padding: const EdgeInsets.all(16),
      height: 300,
      child: BarChart(
        BarChartData(
          barGroups: chartData,
          titlesData: FlTitlesData(
              show: true),
          borderData: FlBorderData(show: true),
          gridData: FlGridData(show: true),
        ),
      ),
    );
  }
}
