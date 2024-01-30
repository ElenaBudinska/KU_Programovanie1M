import 'package:flutter/material.dart';
import 'package:servicesapp/pages/start_page.dart';
import 'package:servicesapp/services/databaseHelper.dart';

void main() {
  // inicializácia sqflite
  DatabaseHelper.init();

  runApp(const MaterialApp(
    home: StartPage(),
    debugShowCheckedModeBanner: false,
  ));
}
