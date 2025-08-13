import 'dart:math' as math;
import 'package:exprense_tracker/models/transaction.dart';
import 'package:exprense_tracker/providers/transaction_provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ExpenseChart extends StatelessWidget {
  const ExpenseChart({super.key});

  @override
  Widget build(BuildContext context) {
    final transactionProvider = Provider.of<TransactionProvider>(context);
    final transactions = transactionProvider.transactions;

    final expenses =
        transactions.where((t) => t.type == TransactionType.expense).toList();

    if (expenses.isEmpty) {
      return const SizedBox(
        height: 300,
        child: Center(child: Text('Sin datos de gastos')),
      );
    }

    final Map<String, double> categoryTotals = {};
    for (final t in expenses) {
      categoryTotals[t.category] = (categoryTotals[t.category] ?? 0) + t.amount;
    }

    final entries = categoryTotals.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    final groups = <BarChartGroupData>[];
    double maxY = 0;
    for (var i = 0; i < entries.length; i++) {
      final amount = entries[i].value;
      maxY = math.max(maxY, amount);
      groups.add(
        BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
              toY: amount,
              width: 18,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(6)),
            ),
          ],
        ),
      );
    }

    maxY = (maxY * 1.15).clamp(1, double.infinity);

    return Container(
      padding: const EdgeInsets.all(16),
      height: 300,
      child: BarChart(
        BarChartData(
          barGroups: groups,
          alignment: BarChartAlignment.spaceBetween,
          gridData: const FlGridData(show: true, drawVerticalLine: false),
          borderData: FlBorderData(show: false),

          // Ejes y títulos
          titlesData: FlTitlesData(
            topTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),

            // Eje Y (izquierdo)
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                getTitlesWidget: (double value, TitleMeta meta) {
                  if (value % 1 != 0) return const SizedBox.shrink();
                  return Text(value.toInt().toString(),
                      style: Theme.of(context).textTheme.bodySmall);
                },
              ),
            ),

            // Eje X (categorías)
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 52,
                getTitlesWidget: (double value, TitleMeta meta) {
                  final idx = value.toInt();
                  if (idx < 0 || idx >= entries.length) {
                    return const SizedBox.shrink();
                  }
                  final label = entries[idx].key;

                  return Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Transform.rotate(
                      angle: -math.pi / 6, // ~ -30°
                      child: Text(
                        label,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          minY: 0,
          maxY: maxY,

          barTouchData: BarTouchData(
            enabled: true,
            touchTooltipData: BarTouchTooltipData(
              tooltipMargin: 8,
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                final cat = entries[group.x.toInt()].key;
                final amount = rod.toY;
                return BarTooltipItem(
                  '$cat\n',
                  const TextStyle(fontWeight: FontWeight.bold),
                  children: [TextSpan(text: amount.toStringAsFixed(2))],
                );
              },
            ),
          ),
        ),

        duration: const Duration(milliseconds: 250),
      ),
    );
  }
}
