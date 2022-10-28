import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:path/path.dart';
import 'package:xo_moble_app/Date.dart';
import 'package:intl/intl.dart';

class Winner {
  String? id;
  String? winner;
  DateTime? date;
  String? size;

  Winner({this.id, this.winner, this.date, this.size});
  factory Winner.fromMap(Map<String, dynamic> json) {
    return Winner(
        id: json['id'],
        winner: json['winner'],
        date: DateTime.parse(json['date']),
        size: json['size']);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'winner': winner,
      'date': date!.toIso8601String(),
      'size': size,
    };
  }
}

class Condition {
  String? id;
  String? position;
  String? symbol;

  Condition({this.id, this.position, this.symbol});
  factory Condition.fromMap(Map<String, dynamic> json) {
    return Condition(
        id: json['id'], position: json['position'], symbol: json['symbol']);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'position': position,
      'symbol': symbol,
    };
  }
}

class DatabaseHelper {
  DatabaseHelper.__privateConstrutor();
  static final DatabaseHelper instance = DatabaseHelper.__privateConstrutor();

  static Database? _database;
  Future<Database> get database async => _database ??= await _initDatabase();

  Future<Database> _initDatabase() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, 'winner.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
  CREATE TABLE Winner(
    id TEXT PRIMARY KEY,
    winner TEXT,
    size TEXT,
    date DATETIME 
    )
  ''');
    await db.execute('''
  CREATE TABLE Condition(
    id TEXT ,
    position TEXT ,
    symbol TEXT,
    PRIMARY KEY (id, position)
    )
  ''');
  }

  List<Winner> ListWinner = [];
  Future<List<Winner>> getWinner() async {
    Database db = await instance.database;
    var text_winnner = await db.query('winner');
    ListWinner = text_winnner.isNotEmpty
        ? text_winnner.map((e) => Winner.fromMap(e)).toList()
        : [];
    return ListWinner;
  }

  List<Condition> ListCondition = [];
  Future<List<Condition>> getCondition() async {
    Database db = await instance.database;
    var text_Condition = await db.query('Condition');
    ListCondition = text_Condition.isNotEmpty
        ? text_Condition.map((e) => Condition.fromMap(e)).toList()
        : [];
    return ListCondition;
  }

  Future<int> add(Winner winner) async {
    Database db = await instance.database;
    if (ListWinner.length > 0) {
      if (ListWinner.length < 10) {
        int id = ListWinner.length + 1;
        winner.id = "00" + id.toString();
      } else if (ListWinner.length < 100) {
        int id = ListWinner.length + 1;
        winner.id = "0" + id.toString();
      }

      DateTime _dateTime = DateTime.now();

      winner.date = _dateTime;
      return await db.insert('winner', winner.toMap());
    } else {
      winner.id = "001";
      DateTime _dateTime = DateTime.now();
      winner.date = _dateTime;

      return await db.insert('winner', winner.toMap());
    }
  }

  void add2(Winner winner, List<String> showXO) async {
    Condition c = Condition();
    Database db = await instance.database;
    if (ListWinner.length > 0) {
      if (ListWinner.length < 10) {
        int id = ListWinner.length + 1;
        winner.id = "00" + id.toString();
      } else if (ListWinner.length < 100) {
        int id = ListWinner.length + 1;
        winner.id = "0" + id.toString();
      }

      DateTime _dateTime = DateTime.now();

      winner.date = _dateTime;
      await db.insert('winner', winner.toMap());
    } else {
      winner.id = "001";
      DateTime _dateTime = DateTime.now();
      winner.date = _dateTime;
      await db.insert('winner', winner.toMap());
      //condition
      c.id = winner.id;
      for (int i = 1; i <= showXO.length; i++) {
        c.position = i.toString();
        c.symbol = showXO[i];
        await db.insert('condition', c.toMap());
      }
    }
  }

  Future<int> remove(String id) async {
    var int_id = int.parse(id);
    Database db = await instance.database;
    return await db.delete('winner', where: 'id =?', whereArgs: [int_id]);
  }

  static Future deleteTable(String s) async {
    final db = await DatabaseHelper._database;

    return db!.rawQuery('DELETE FROM ${s}');
  }
}
