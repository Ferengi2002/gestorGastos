enum TransactionType { income, expense }

class Transaction {
  String id;
  String category;
  String description;
  double amount;
  TransactionType type;
  DateTime date;

  Transaction(
      {required this.id,
      required this.category,
      required this.description,
      required this.amount,
      required this.type,
      required this.date});

  Map<String, dynamic> toMap() => {
        'id': id,
        'category': category,
        'description': description,
        'amount': amount,
        'type': type == TransactionType.income ? 'income' : 'expense',
        'date': date.toUtc().toIso8601String(),
      };
}
