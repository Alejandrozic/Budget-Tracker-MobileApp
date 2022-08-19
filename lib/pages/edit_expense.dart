import 'package:flutter/material.dart';
import 'package:budget_tracker/models/expense.dart';
import 'package:budget_tracker/services/database.dart';


class EditExpense extends StatefulWidget {
  final Expense expense;
  const EditExpense({Key? key, required this.expense}) : super(key: key);

  @override
  _EditExpenseState createState() => _EditExpenseState();
}

class _EditExpenseState extends State<EditExpense> {

  final expenseNameController = TextEditingController();
  final expenseAmountController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    expenseNameController.text = widget.expense.name;
    expenseAmountController.text = widget.expense.amount.toString();

    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.black87,
        title: Text('Edit Expense'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextField(
              controller: expenseNameController,
            ),
            TextField(
              controller: expenseAmountController,
              keyboardType: TextInputType.number,
            ),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      Expense updatedExpense = widget.expense.copy(
                          name: expenseNameController.text,
                          amount: double.parse(expenseAmountController.text),
                      );
                      await BudgetDatabase.instance.updateExpense(updatedExpense);
                      Navigator.pop(context);
                    },
                    child: Text('Update Expense'),
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.red[300])),
                  ),
                ),
                SizedBox(width: 50.0),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      await BudgetDatabase.instance.deleteExpense(widget.expense);
                      Navigator.pop(context);
                    },
                    child: Text('Delete Expense'),
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.red[300])),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}