import 'package:flutter/material.dart';

class GuideKindergarten {
  final String name;
  final String contact;
  final String executive;
  final String address;
  final String phone;

  GuideKindergarten(
      {@required this.name,
      @required this.contact,
      @required this.executive,
      @required this.address,
      @required this.phone});

  factory GuideKindergarten.parseMap(Map object) {
    return GuideKindergarten(
        name: object['name'],
        contact: object['contact'],
        executive: object['executive'],
        address: object['address'],
        phone: object['phone']);
  }

  static List<GuideKindergarten> parseList(List objectList) {
    List<GuideKindergarten> list = [];
    for (Map item in objectList) list.add(GuideKindergarten.parseMap(item));
    return list;
  }
}
