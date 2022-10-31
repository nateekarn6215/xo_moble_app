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
  int? position;
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
    print(path);
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
    position INT ,
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
  Future<List<Condition>> getCondition(String? id) async {
    Database db = await instance.database;
    var text_Condition = await db.query(
      'Condition',
      where: "id = ${id}",
    );
    ListCondition = text_Condition.isNotEmpty
        ? text_Condition.map((e) => Condition.fromMap(e)).toList()
        : [];
    return ListCondition;
  }

  void add(Winner winner, List<String> showXO) async {
    Condition c = Condition();
    Database db = await instance.database;
    ListWinner = await DatabaseHelper.instance.getWinner();
    print(ListWinner.length);
    if (ListWinner.length > 0) {
      String t_id = ListWinner.last.id.toString();
      int id = int.parse(t_id);
      int t = id + 1;
      winner.id = t.toString();

      DateTime _dateTime = DateTime.now();
      winner.date = _dateTime;
      await db.insert('winner', winner.toMap());
      //condition
      c.id = winner.id;
      for (int i = 0; i < showXO.length; i++) {
        c.position = i;
        if (showXO[i] == "") {
          c.symbol = "";
        } else {
          c.symbol = showXO[i];
        }

        await db.insert('condition', c.toMap(),
            conflictAlgorithm: ConflictAlgorithm.replace);
      }
    } else {
      winner.id = "100";
      DateTime _dateTime = DateTime.now();
      winner.date = _dateTime;
      await db.insert('winner', winner.toMap());
      //condition
      c.id = winner.id;
      for (int i = 0; i < showXO.length; i++) {
        c.position = i;
        if (showXO[i] == "") {
          c.symbol = "";
        } else {
          c.symbol = showXO[i];
        }

        await db.insert('condition', c.toMap(),
            conflictAlgorithm: ConflictAlgorithm.replace);
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
