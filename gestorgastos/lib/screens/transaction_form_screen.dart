import 'package:exprense_tracker/models/transaction.dart';
import 'package:exprense_tracker/providers/transaction_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TransactionFormScreen extends StatefulWidget {
  final Transaction? transaction;
  const TransactionFormScreen({super.key, this.transaction});

  @override
  State<TransactionFormScreen> createState() => _TransactionFormScreenState();
}

class _TransactionFormScreenState extends State<TransactionFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  String _selectedCategory = 'Comida';
  TransactionType _selectedType = TransactionType.expense;

  final List<String> _categories = ['Comida','Transporte','Juegos','Vicio','Otros'];

  @override
  void initState() {
    super.initState();
    final tx = widget.transaction;
    if (tx != null) {
      _amountController.text = tx.amount.toString();
      _descriptionController.text = tx.description;
      _selectedCategory = tx.category;
      _selectedType = tx.type;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.transaction == null ? 'Registrar Transacción' : 'Editar Transacción')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _amountController,
                decoration: const InputDecoration(labelText: 'Monto'),
                keyboardType: TextInputType.number,
                validator: (v) => (v == null || v.isEmpty) ? 'Por favor ingrese un monto' : null,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Descripción'),
                validator: (v) => (v == null || v.isEmpty) ? 'Por favor ingrese una descripción' : null,
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField(
                value: _selectedCategory,
                decoration: const InputDecoration(labelText: 'Categoría'),
                items: _categories.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                onChanged: (v) => setState(() => _selectedCategory = v as String),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(child: RadioListTile(
                    title: const Text('Gasto'),
                    value: TransactionType.expense,
                    groupValue: _selectedType,
                    onChanged: (TransactionType? v) => setState(() => _selectedType = v!),
                  )),
                  Expanded(child: RadioListTile(
                    title: const Text('Ingreso'),
                    value: TransactionType.income,
                    groupValue: _selectedType,
                    onChanged: (TransactionType? v) => setState(() => _selectedType = v!),
                  )),
                ],
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    if (!_formKey.currentState!.validate()) return;
                    final provider = Provider.of<TransactionProvider>(context, listen: false);

                    if (widget.transaction == null) {
                      await provider.addTransaction(
                        Transaction(
                          id: DateTime.now().millisecondsSinceEpoch.toString(),
                          category: _selectedCategory,
                          description: _descriptionController.text.trim(),
                          amount: double.parse(_amountController.text),
                          type: _selectedType,
                          date: DateTime.now().toUtc(), // guarda en UTC
                        ),
                      );
                    } else {
                      final tx = widget.transaction!;
                      await provider.updateTransaction(
                        Transaction(
                          id: tx.id,
                          category: _selectedCategory,
                          description: _descriptionController.text.trim(),
                          amount: double.parse(_amountController.text),
                          type: _selectedType,
                          date: tx.date, // conserva fecha original (o cámbiala si agregas picker)
                        ),
                      );
                    }

                    if (!mounted) return;
                    // ignore: use_build_context_synchronously
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(widget.transaction == null ? 'Transacción registrada' : 'Transacción actualizada'),
                    ));
                    // ignore: use_build_context_synchronously
                    Navigator.pop(context, true);
                  },
                  child: Text(
                    widget.transaction == null ? 'Guardar Transacción' : 'Actualizar Transacción',
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
