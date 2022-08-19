import 'package:flutter/material.dart';
import 'package:budget_tracker/models/category.dart';
import 'package:budget_tracker/models/expense.dart';
import 'package:budget_tracker/services/database.dart';


class NewExpense extends StatefulWidget {
  final Category category;
  const NewExpense({Key? key, required this.category}) : super(key: key);

  @override
  _NewExpenseState createState() => _NewExpenseState();
}

class _NewExpenseState extends State<NewExpense> {

  final expenseNameController = TextEditingController();
  final expenseAmountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.black87,
        title: Text('New Expense'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextFormField(
              decoration: InputDecoration(
                  labelText: 'Category: ${widget.category.name}'
              ),
              readOnly: true,
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Name'),
              controller: expenseNameController,
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Amount'),
              controller: expenseAmountController,
              keyboardType: TextInputType.number,
            ),
            ElevatedButton(
              onPressed: () async {
                Expense expense = Expense(
                    categoryId: widget.category.id,
                    name: expenseNameController.text,
                    amount: double.parse(expenseAmountController.text),
                );
                await BudgetDatabase.instance.insertExpense(expense);
                Navigator.pop(context);
              },
              child: Text('Add Expense'),
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.red[300])),
            ),
          ],
        ),
      ),
    );
  }
}