import 'package:flutter/material.dart';

class Room {
  final int id;
  final String name;
  final String inflectedName;
  final String imageURL;
  final MaterialColor color;
  final bool allowMultipleRooms;
  late int count;

  Room(this.id, this.name, this.imageURL, this.color, this.allowMultipleRooms, this.inflectedName) {
    if (allowMultipleRooms) {
      count = 1;
    } else {
      count = 0;
    }    
  }
}
