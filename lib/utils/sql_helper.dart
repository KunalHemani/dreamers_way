import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart' as sql;

class SQLHelper {
  // create table
  static Future<void> createTables(sql.Database database) async {
    await database.execute("""CREATE TABLE IF NOT EXISTS package(
          id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, 
          title TEXT, 
          description TEXT, 
          amount FLOAT,
          coverImage TEXT
          )""");

    await database.execute("""CREATE TABLE IF NOT EXISTS users(
          id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, 
          username TEXT UNIQUE, 
          password TEXT, 
          createdAt TIMESTAMP NOT NULL
          )""");

    // await database.execute("""UPDATE package
    // SET title = "_journals[index]["title"]",
    // description = "_journals[index]["description"]",
    // amount = "_journals[index]["amount"]",
    // coverImage = "_journals[index]["coverImage"]"
    // WHERE id = "_journals[index]["id"]"
    // """);
    //
    // await database.execute("""DELETE package
    // WHERE id = "_journals[index]["id"]"
    // """);

    // await SQLHelper.createWalletItem(0, "Cash", null);
  }

  // open db
  static Future<sql.Database> db() async {
    var databasesPath = await sql.getDatabasesPath();
    var path = '$databasesPath/dreamersway.db';
    return sql.openDatabase(
      path,
      version: 1,
      onCreate: (sql.Database database, int version) async {
        var batch = database.batch();
        await createTables(database);
        await batch.commit();
      },
    );
  }

  // read all record

  static Future<List<Map<String, dynamic>>> getItems({
    required String? switchArg,
    required String? tableName,
    int? idclm,
    String? titleclm,
    String? walletclm,
    String? categoriesclm,
    String? whereqry,
    String? whereqryvalue,
    int? offset = 0,
    int? limit,
  }) async {
    final db = await SQLHelper.db();
    switch (switchArg) {
    // limit return
      case "limitAll":
        return db.rawQuery(
            "select * from ($tableName) order by id desc limit $limit offset $offset");
      case "limit":
        return db.rawQuery(
            "select * from ($tableName) where wallet = ? order by id desc limit $limit offset $offset",
            [walletclm]);
    // Columns
      case "all":
        if (limit != null) {
          return db.rawQuery(
              "Select * from ($tableName) order by id desc");
        }
        return db.rawQuery('SELECT * FROM ($tableName) order by id desc');
      case "categories":
        return db.rawQuery(
            'SELECT distinct(category) FROM ($tableName) order by category');
    // Filters
      case "filterById":
        return db.rawQuery(
            'SELECT * FROM ($tableName) WHERE id = ? order by id desc',
            [idclm]);
      case "filterByTitle":
        return db.rawQuery(
            'SELECT * FROM ($tableName) WHERE title = ? order by id desc',
            [titleclm]);
      case "filterByWallet":
        return db.rawQuery(
            'SELECT * FROM ($tableName) WHERE wallet = ? order by id desc',
            [walletclm]);
      case "filterByCategories":
        return db.rawQuery(
            'SELECT * FROM ($tableName) WHERE category = ? order by id desc',
            [categoriesclm]);
    // Reports
      case "categoriesReport":
        return db.rawQuery(
            'SELECT DISTINCT category as asHead, SUM(amount) as totalAmount FROM ($tableName) where ($whereqry) = ? group by category',
            [whereqryvalue]);
      case "walletReport":
        return db.rawQuery(
            'SELECT DISTINCT title as asHead, amount as totalAmount FROM ($tableName) where amount > 0');
      default:
        return db.rawQuery("select * from transactions");
    }
  }
  // create record
  static Future<int> createItem(
      String title,
      String description,
      double amount,
      String path,
      ) async {
    final db = await SQLHelper.db();

    final data = {
      'title': title,
      'description': description,
      'amount': amount,
      'coverImage' : path,
    };
    final id = await db.insert(
      'package',
      data,
      conflictAlgorithm: sql.ConflictAlgorithm.replace,
    );
    return id;
  }

  static Future<int> updateItem(int indexController, String titleController, String descriptionController, double amountController, String imageController) async {
    final db = await SQLHelper.db();

    try {
      final result = await db.rawUpdate(
        'UPDATE package SET title = ?, description = ?, amount = ?, coverImage = ? WHERE id = ?',
        [titleController, descriptionController, amountController, imageController, indexController],
      );
      return result;
    } catch (e) {
      print('Error updating item: $e');
      // You can handle the error further, throw it, log it, etc.
      // throw e; // Uncomment this line if you want to propagate the error to the calling code.
      return -1; // Or return an error code, whatever makes sense for your application.
    }
  }


  // static updateItem(int indexController, String titleController, String descriptionController, double amountController, String imageController) async {
  //   final db = await SQLHelper.db();
  //   // final data = {
  //   //   'title': titleController,
  //   //   'description': descriptionController,
  //   //   'amount' : amountController,
  //   //   'coverImage' : imageController
  //   //
  //   // };
  //   // var id;
  //   try {
  //     final result = await db.rawUpdate(
  //       'update package set title = ?, description = ?, amount = ?, coverImage = ? where id = ?',
  //       [
  //         titleController,
  //         descriptionController,
  //         amountController,
  //         imageController,
  //         indexController
  //       ],
  //     );
  //     return result;
  //   }
  //   catch (e){
  //    print(e);
  //   }
  //   }

  static Future<void> deleteItem(int id) async {
    final db = await SQLHelper.db();
    try {
      await db.delete("package", where: "id = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
  }
}