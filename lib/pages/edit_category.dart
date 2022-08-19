import 'package:flutter/material.dart';
import 'package:budget_tracker/models/category.dart';
import 'package:budget_tracker/services/database.dart';


class EditCategory extends StatefulWidget {
  final Category category;
  const EditCategory({Key? key, required this.category}) : super(key: key);

  @override
  _EditCategoryState createState() => _EditCategoryState();
}

class _EditCategoryState extends State<EditCategory> {

  final categoryNameController = TextEditingController();
  final categoryThresholdController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    categoryNameController.text = widget.category.name;
    categoryThresholdController.text = widget.category.threshold.toString();

    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.black87,
        title: Text('Edit Category'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextField(
              controller: categoryNameController,
            ),
            TextField(
              controller: categoryThresholdController,
              keyboardType: TextInputType.number,
            ),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      Category updatedCategory = widget.category.copy(
                          name: categoryNameController.text,
                          threshold: double.parse(categoryThresholdController.text),
                      );
                      await BudgetDatabase.instance.updateCategory(updatedCategory);
                      Navigator.pop(context);
                    },
                    child: Text('Update Category'),
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.red[300])),
                  ),
                ),
                SizedBox(width: 50.0),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      await BudgetDatabase.instance.deleteCategory(widget.category);
                      Navigator.pop(context);
                    },
                    child: Text('Delete Category'),
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