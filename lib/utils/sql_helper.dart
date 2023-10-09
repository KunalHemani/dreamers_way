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
      // var sql = "UPDATE package SET title = ?, description = ?, amount = ?, coverImage = ? WHERE id = ?' [titleController, descriptionController, amountController, imageController, indexController]";


      var sql1 = "UPDATE package SET title = 'Surat', description = 'Surat's food is very famous.', amount = '${amountController}', coverImage = 'https://www.achhikhabar.com/wp-content/uploads/2023/01/%E0%A4%B8%E0%A5%82%E0%A4%B0%E0%A4%A4-%E0%A4%95%E0%A4%BE-%E0%A4%87%E0%A4%A4%E0%A4%BF%E0%A4%B9%E0%A4%BE%E0%A4%B8-Complete-History-of-Surat-in-Hindi-1024x576.jpg' WHERE id = 7";
      var sql2 = "UPDATE package SET title = 'Goa', description = 'Goa is a very beautiful', amount = '${amountController}', coverImage = 'https://th.bing.com/th/id/OIP.13QYrG_OR_ZNhuiR76S7eQAAAA?pid=ImgDet&rs=1' WHERE id = 8";
      var sql3 = "UPDATE package SET title = 'Kerala', description = 'Kerala has various places to visit.', amount = '${amountController}', coverImage = 'https://th.bing.com/th/id/OIP.UYiSdWPVH1ZBQfy_IX-6LwHaFj?pid=ImgDet&w=800&h=600&rs=1' WHERE id = 9";
      var sql4 = "UPDATE package SET title = 'Amritsar', description = 'The famous Golden Temple', amount = '${amountController}', coverImage = 'https://live.staticflickr.com/4817/44986206145_2b7b818ecf_b.jpg' WHERE id = 11";

      db.rawUpdate(sql1);
      db.rawUpdate(sql2);
      db.rawUpdate(sql3);
      db.rawUpdate(sql4);
      print("Kunal");
      return 1;
    } catch (e) {
      print('Error updating item: $e');
      // You can handle the error further, throw it, log it, etc.
      // throw e; // Uncomment this line if you want to propagate the error to the calling code.
      return 0; // Or return an error code, whatever makes sense for your application.
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