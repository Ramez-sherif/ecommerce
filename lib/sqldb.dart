import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart'; //contains join func

class SqlDb {
  static Database? _db;
  Future<Database?> get db async {
    if (_db == null) {
      _db = await initialDb();
      return _db;
    } else {
      return _db;
    }
  }

  initialDb() async {
    //default database Location
    String databasePath = await getDatabasesPath();
    //note when generate DB we should join database name folowed by (.db) with database path
    String path = join(databasePath, "Egyzonaaaaa.db"); // databasePath/Egyzona.db
    Database mydb = await openDatabase(path,
        onCreate: _onCreate, version: 1, onUpgrade: _onUpgrade);
    return mydb;
  }

  _onUpgrade(Database db, int oldVersion, int newVersion) {
    print("onUpgrade==================");
  }

// on create function which create the DB tabels
//this function is called once when we create database
  _onCreate(Database db, int version) async {
    await db.execute(
        'CREATE TABLE favorites ("id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT , "productId" TEXT,  "userId" TEXT)');
    print("onCreate================================");

    // await db.execute(
    //     'CREATE TABLE category ("id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT , "onlineCategoryID" TEXT,  "name" TEXT)');
    // print("onCreate================================");

    await db.execute(
        'CREATE TABLE product ("id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT , "onlineProductId" TEXT,  "onlineCategoryID" TEXT,"name" TEXT,"price" TEXT,"rate" TEXT)');
    print("onCreate================================");
  }

  readData(String sql) async {
    Database? mydb = await db;
    List<Map> response = await mydb!.rawQuery(sql);
    return response;
  }

  insertData(String sql) async {
    Database? mydb = await db;
    int response = await mydb!
        .rawInsert(sql); //return the number of raw that is added to the table
    return response;
  }

  updateData(String sql) async {
    Database? mydb = await db;
    int response = await mydb!
        .rawUpdate(sql); //return the number of raw that is added to the table
    return response;
  }

  deleteData(String sql) async {
    Database? mydb = await db;
    int response = await mydb!
        .rawDelete(sql); //return the number of raw that is added to the table
    return response;
  }
}
