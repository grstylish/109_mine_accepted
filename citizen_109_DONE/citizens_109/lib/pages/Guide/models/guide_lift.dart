import 'package:flutter/material.dart';

class GuideLift {
  final String name;
  final String executive;
  final String contact;
  final String phone;

  GuideLift(
      {@required this.name,
      @required this.executive,
      @required this.contact,
      @required this.phone});

  factory GuideLift.parseMap(Map object) {
    return GuideLift(
        name: object['name'],
        executive: object['executive'],
        contact: object['contact'],
        phone: object['phone']);
  }

  static List<GuideLift> parseList(List objectList) {
    List<GuideLift> list = [];
    for (Map item in objectList) list.add(GuideLift.parseMap(item));
    return list;
  }
}
