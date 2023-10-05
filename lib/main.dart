import 'package:dreamers_way/pages/welcome_screen.dart';
import 'package:dreamers_way/utils/sql_helper.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart' as sql;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _LoadSQLTable.db();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: WelcomeScreen(),
    );
  }
}

class _LoadSQLTable {
  static Future<sql.Database> db() async {
    var databasesPath = await sql.getDatabasesPath();
    var path = '$databasesPath/transaction.db';
    return sql.openDatabase(
      path,
      version: 1,
      onCreate: (sql.Database database, int version) async {
        var batch = database.batch();
        SQLHelper.createTables(database);
        await batch.commit();
      },
    );
  }
}