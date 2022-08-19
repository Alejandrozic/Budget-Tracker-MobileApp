import 'package:flutter/material.dart';
import 'package:budget_tracker/models/category.dart';
import 'package:budget_tracker/services/database.dart';


class NewCategory extends StatefulWidget {
  const NewCategory({Key? key}) : super(key: key);

  @override
  _NewCategoryState createState() => _NewCategoryState();
}

class _NewCategoryState extends State<NewCategory> {

  final categoryNameController = TextEditingController();
  final categoryThresholdController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.black87,
        title: Text('New Category'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextField(
              decoration: InputDecoration(labelText: 'Name'),
              controller: categoryNameController,
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Threshold'),
              controller: categoryThresholdController,
              keyboardType: TextInputType.number,
            ),
            ElevatedButton(
              onPressed: () async {
                Category category = Category(
                    name: categoryNameController.text ,
                    threshold: double.parse(categoryThresholdController.text),
                );
                await BudgetDatabase.instance.insertCategory(category);
                Navigator.pop(context);
              },
              child: Text('Add Category'),
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.red[300])),
            ),
          ],
        ),
      ),
    );
  }
}