import 'package:flutter/material.dart';
import 'package:budget_tracker/models/category.dart';
import 'package:budget_tracker/services/database.dart';
import 'package:budget_tracker/pages/edit_category.dart';
import 'package:budget_tracker/pages/new_category.dart';
import 'package:budget_tracker/pages/expenses_by_category.dart';


class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  late List<Category> categories = [];
  late Map totalByCategory = {};

  @override
  void initState(){
    super.initState();
    refreshCategories();
  }
  Future<void> refreshCategories() async {
    this.categories = await BudgetDatabase.instance.getAllCategories();
    this.totalByCategory = await BudgetDatabase.instance.getCategoryTotals();
    setState(() {});  // Triggers categories refresh
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
                        builder: (context) => NewCategory(),
                      ));
                  setState(() {
                    refreshCategories();
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
        title: Text('Budget Tracker'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.grey[700],
      ),
      body: ListView.builder(
        itemCount: categories.length,
        itemBuilder: (context, index){
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 1.0, horizontal: 4.0),
            child: Card(
              child: ListTile(
                onTap: () async {
                  await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ExpensesByCategory(category: categories[index]),
                      ));
                  setState(() {
                    refreshCategories();
                  });
                },
                title: Text(
                  '${categories[index].name}',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: RichText(
                    text: TextSpan(
                      children: <TextSpan>[
                        new TextSpan(
                            text: '${totalByCategory[categories[index].id].toString()}',
                            style: TextStyle(
                                color: Colors.black,
                                // TODO: Figure out how to get categories with null expenses to shows 0
                                // color: totalByCategory[categories[index].id] > categories[index].threshold ? Colors.red : Colors.green
                            )
                        ),
                        new TextSpan(text: ' / ',
                            style: TextStyle(color: Colors.black)),
                        new TextSpan(text: '${categories[index].threshold}',
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
                          builder: (context) => EditCategory(category: categories[index]),
                        ));
                    setState(() {
                      refreshCategories();
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
