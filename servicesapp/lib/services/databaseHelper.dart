import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:servicesapp/models/request.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

class DatabaseHelper {
  final int _dbVersion = 1;
  final String _dbName = 'services.db';
  String adminInfoTable = 'AdminInfo';
  String requestsTable = 'Requests';
  String adminPassword = 'flutter123';

  static void init() {
    if (kIsWeb) {
      databaseFactory = databaseFactoryFfiWeb;
    } else if (Platform.isLinux || Platform.isWindows) {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    }

    // More log to see the executed queries
    // ignore: deprecated_member_use
    databaseFactory = databaseFactory.debugQuickLoggerWrapper();
  }

  // vytvorenie DB a tabuliek "AdminInfo" a "Requests"
  late final Future<Database> _db = () async {
    return await openDatabase(_dbName, version: _dbVersion, onCreate: (db, version) async {
      await db.execute('''
        CREATE TABLE AdminInfo (
          id INTEGER PRIMARY KEY,
          password TEXT NOT NULL
        );

        CREATE TABLE Requests (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          serviceId INTEGER NOT NULL,
          serviceDescription TEXT NOT NULL,
          additionalInformation TEXT,
          requiredDateTime DATETIME NOT NULL,
          customerPhone TEXT,
          customerEmail TEXT
          );
      ''');
    });
  }();

  // vloženie admin hesla do DB do tabuľky "AdminInfo"
  Future<void> createAdminPassword() async {
    Map<String, Object?> data = <String, Object?>{'password': adminPassword};

    Database db = await _db;

    await db.insert(
      adminInfoTable,
      data,
      conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // načítanie admin hesla z DB z tabuľky "AdminInfo"
  Future<String> getAdminPassword() async {
    Database db = await _db;

    var queryResult = await db.query(
      adminInfoTable,
      where: "id = ?",
      whereArgs: [1]);

    return queryResult.isNotEmpty ? jsonMapToPassword(queryResult.first) : "";
  }

  // vloženie novej požiadavky do DB do tabuľky "Requests"
  Future<int> insertServiseRequest(Request request) async {    
    Map<String, Object?> data = request.mapToJson();

    Database db = await _db;

    int queryResult = await db.insert(
      requestsTable,
      data,
      conflictAlgorithm: ConflictAlgorithm.replace);

    return queryResult;
  }

  // načítanie všetkých požiadaviek z DB z tabuľky "Requests"
  Future<List<Request>> getAllServiseRequests() async {
    Database db = await _db;

    List<Map<String, Object?>> queryResult = await db.query(requestsTable);

    return queryResult.map((row) => Request.jsonMapToRequest(row)).toList(growable: false);
  }

  // Future<void> updateServiseRequest(Request request) async {
  //   Database db = await _db;
  //   await db.update(requestsTable, request.mapToJson(), where: 'id = ?', whereArgs: [request.requestId]);
  // }

  // mapovanie DB objektu na string
  String jsonMapToPassword(Map<String, dynamic> json) {
    return json["password"];
  }
}
