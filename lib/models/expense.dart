final String tableExpense = 'expense';

class Expense {
  final int? id;          // Database only field.
  final int? categoryId;  // Database only field.
  final String name;      // Model & Database field.
  final double amount;    // Model & Database field.

  Expense({
    this.id,
    this.categoryId,
    required this.name,
    required this.amount,
  });

  /*
  *   Conversions from Expense to
  *   Dart Map and in reverse.
  */

  Map<String, Object?> toMap() => {
    '_id': id,
    '_categoryId': categoryId,
    'name': name,
    'amount': amount,
  };

  static Expense fromMap(Map<String, Object?> json) => Expense(
    id:         json['_id'] as int?,
    categoryId: json['_categoryId'] as int?,
    name:       json['name'] as String,
    amount:     json['amount'] as double,
  );

  /*
  *   The copy function allows us to create
  *   a copy of the Expense and then
  *   add/update fields. This is currently
  *   used for adding "id" to a Expense
  *   that does not yet have a unique ID on the
  *   database.
  */

  Expense copy({
    int? id,
    int? categoryId,
    String? name,
    double? amount,
  }) => Expense(
    id: id ?? this.id,
    categoryId: categoryId ?? this.categoryId,
    name: name ?? this.name,
    amount: amount ?? this.amount,
  );
}