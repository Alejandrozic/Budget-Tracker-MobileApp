import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:budget_tracker/models/category.dart';
import 'package:budget_tracker/models/expense.dart';  // NOT IMPLEMENTED YET


class BudgetDatabase{

  /*
  *   Implementation was done side-by-side using module
  *   example at https://flutter.dev/docs/cookbook/persistence/sqlite.
  *   Some components were reused from the example.
  */

  String filePath = 'budget.db';
  static final BudgetDatabase instance = BudgetDatabase.__init();
  BudgetDatabase.__init();
  static Database? _database;

  Future<Database> get database async {
    if (_database == null) return await _initDB();
    return database;
  }

  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async{
    String sqlCategoryTable = '''
    CREATE TABLE $tableCategory (
      _id         INTEGER PRIMARY KEY AUTOINCREMENT,
      name        TEXT NOT NULL,
      threshold   REAL NOT NULL
    );''';
    await db.execute(sqlCategoryTable);
    String sqlExpenseTable = '''
    CREATE TABLE $tableExpense (
      _id         INTEGER PRIMARY KEY AUTOINCREMENT,
      _categoryId INTEGER NOT NULL,
      name        TEXT NOT NULL,
      amount      REAL NOT NULL
    );''';
    await db.execute(sqlExpenseTable);
  }

  Future close() async{
    final db = await instance.database;
    db.close();
  }

  /*
  *   Function used to delete a database.
  *   Used for testing only.
  */

  Future<void> deleteDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    databaseFactory.deleteDatabase(path);
  }


  /*
  *   Category: INSERT
  *
  *   Function takes a Category object and
  *   adds it to the database.
  */

  Future<Null> insertCategory(Category category) async {
    final db = await instance.database;
    await db.insert(tableCategory, category.toMap());
  }

  /*
  *   Category: UPDATE
  *
  *   Function takes an updated Category object and
  *   updates the database row values for it.
  */

  Future<Null> updateCategory(Category category) async {
    final db = await instance.database;
    await db.update(
      tableCategory,
      category.toMap(),
      where: '_id = ?',
      whereArgs: [category.id],
    );
  }

  /*
  *   Category: DELETE
  *
  *   Function takes a Category object and
  *   deletes it from the database.
  */

  Future<Null> deleteCategory(Category category) async {
    final db = await instance.database;
    await db.delete(
        tableCategory,
        where: '_id = ?',
      whereArgs: [category.id],
    );
  }

  /*
  *   Category: RETRIEVE ALL ROWs
  *
  *   Function retrieves all the Category
  *   rows  in ASC order by name and converts
  *   them to object.
  */

  Future<List<Category>> getAllCategories() async {
    final db = await instance.database;
    final maps = await db.query(
      tableCategory,
      orderBy: 'name ASC',
    );
    List<Category> output = [];
    if (maps.isEmpty){
      // TODO: Review what we want to show on _blank start.
    } else {
      maps.forEach((element) {
        Category category = Category.fromMap(element);
        output.add(category);
      });
    }
    return output;
  }

  /*
  *   Category: Sum all expenses by category
  *
  *   Function retrieves the sum of all expense by category.
  */

  Future<Map> getCategoryTotals() async {
    final db = await instance.database;
    // Custom SQL Query to also pull running total for category
    String sql = '''
      SELECT 
        $tableCategory._id,
        $tableCategory.name,
        SUM ($tableExpense.amount) as currentTotal
      FROM 
        $tableCategory
      INNER JOIN $tableExpense 
        ON $tableExpense._categoryId ==  $tableCategory._id
      GROUP BY $tableCategory.name
      ORDER BY $tableCategory.name ASC;
    ''';
    final maps = await db.rawQuery(sql);
    Map output = {};
    if (maps.isEmpty){
      // _blank start.
    } else {
      maps.forEach((element) {
        int categoryId = element['_id'] as int;
        double currentTotal = element['currentTotal'] as double;
        output[categoryId] = currentTotal;
      });
    }
    return output;
  }

  /*
  *   Expense: Insert
  *
  *   Function takes a Expense object and
  *   adds it to the database.
  */

  Future<Null> insertExpense(Expense expense) async {
    final db = await instance.database;
    await db.insert(tableExpense, expense.toMap());
  }


  /*
  *   Expense: UPDATE
  *
  *   Function takes an updated Expense object and
  *   updates the database row values for it.
  */

  Future<Null> updateExpense(Expense expense) async {
    final db = await instance.database;
    await db.update(
      tableExpense,
      expense.toMap(),
      where: '_id = ?',
      whereArgs: [expense.id],
    );
  }

  /*
  *   Expense: DELETE
  *
  *   Function takes a Expense object and
  *   deletes it from the database.
  */

  Future<Null> deleteExpense(Expense expense) async {
    final db = await instance.database;
    await db.delete(
      tableExpense,
      where: '_id = ?',
      whereArgs: [expense.id],
    );
  }

  /*
  *   Expense: Retrieve list of expenses by category
  *
  *   Function retrieves all the Expense for
  *   a given Category in ASC order by name and
  *   converts them to object.
  */

  Future<List<Expense>> getExpensesByCategory(Category category) async {
    final db = await instance.database;
    final maps = await db.query(
      tableExpense,
      where: '_categoryId = ?',
      whereArgs: [category.id],
      orderBy: 'name ASC',
    );
    List<Expense> output = [];
    if (maps.isEmpty){
      // _blank start no data
    } else {
      maps.forEach((element) {
        Expense expense = Expense.fromMap(element);
        output.add(expense);
      });
    }
    return output;
  }

}