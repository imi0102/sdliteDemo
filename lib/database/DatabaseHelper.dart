import 'package:local_database_demo/models/ListModel.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {



  String dbTable = 'data_table';
  String colId = 'id';
  String colTitle = 'title';

  DatabaseHelper._createInstance();

  factory DatabaseHelper() {
    DatabaseHelper? _databaseHelper;

    if (_databaseHelper == null) {
      _databaseHelper = DatabaseHelper._createInstance(); // This is executed only once
    }
    return _databaseHelper;
  }
  Future<Database> get database async {
     Database? _database;
    if (_database == null) {
      _database = await initializeDatabase();
    }
    return _database;
  }

  Future<Database> initializeDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'data_db.db';
    var notesDatabase = await openDatabase(path, version: 1, onCreate: _createDb);
    return notesDatabase;
  }

  void _createDb(Database db, int newVersion) async {

    await db.execute('CREATE TABLE $dbTable($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colTitle TEXT)');
  }


  Future<List<ListModel>> getDbData() async {

    Database db = await this.database;
    var maps = await db.query(dbTable, orderBy: '$colId ASC');
    List<ListModel> noteList=[];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {

        noteList.add(ListModel.fromMapObject(maps[i]));
      }
    }
    return noteList;
  }

  Future<List<Map<String, dynamic>>> getNoteMapList() async {
    Database db = await this.database;
    var result = await db.query(dbTable, orderBy: '$colId ASC');
    return result;
  }

  Future<int> insertData(ListModel data) async {
    Database db = await this.database;
    var result = await db.insert(dbTable, data.toMap());
    return result;
  }

  Future<int> updateData(ListModel data) async {
    var db = await this.database;
    var result = await db.update(dbTable, data.toMap(), where: '$colId = ?', whereArgs: [data.id]);
    return result;
  }

  Future<int> deleteData(int id) async {
    var db = await this.database;
    int result = await db.rawDelete('DELETE FROM $dbTable WHERE $colId = $id');
    return result;
  }

}