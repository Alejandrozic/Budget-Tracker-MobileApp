import 'package:flutter/material.dart';
import 'package:budget_tracker/models/category.dart';
import 'package:budget_tracker/models/expense.dart';
import 'package:budget_tracker/services/database.dart';
import 'package:budget_tracker/pages/new_expense.dart';
import 'package:budget_tracker/pages/edit_expense.dart';


class ExpensesByCategory extends StatefulWidget {
  final Category category;
  const ExpensesByCategory({Key? key, required this.category}) : super(key: key);

  @override
  _ExpensesByCategoryState createState() => _ExpensesByCategoryState();
}

class _ExpensesByCategoryState extends State<ExpensesByCategory> {

  late List<Expense> expenses = [];

  @override
  void initState(){
    super.initState();
    refreshExpenses();
  }
  Future<void> refreshExpenses() async {
    this.expenses = await BudgetDatabase.instance.getExpensesByCategory(widget.category);
    setState(() {});  // Triggers expenses refresh
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.bottomRight,
            child: FloatingActionButton(
              onPressed: () async {
                await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NewExpense(category: widget.category),
                    ));
                setState(() {
                  refreshExpenses();
                });
              },
              child: const Icon(Icons.add_rounded, size: 40.0),
              backgroundColor: Colors.black26,
            ),
          ),
        ],
      ),
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text('Expenses'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.grey[700],
      ),
      body: ListView.builder(
        itemCount: expenses.length,
        itemBuilder: (context, index){
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 1.0, horizontal: 4.0),
            child: Card(
              child: ListTile(
                onTap: (){
                  // Do nothing on tap
                },
                title: Text(
                  '${expenses[index].name}',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: RichText(
                    text: TextSpan(
                      children: <TextSpan>[
                        new TextSpan(text: '${expenses[index].amount}',
                            style: TextStyle(color: Colors.black)),
                      ],
                    )
                ),
                trailing: IconButton(
                  icon: Icon(Icons.more_vert),
                  onPressed: () async {
                    await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditExpense(expense: expenses[index]),
                        ));
                    setState(() {
                      refreshExpenses();
                    });
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
