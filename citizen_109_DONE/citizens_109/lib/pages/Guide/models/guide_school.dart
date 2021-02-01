import 'package:flutter/material.dart';

class GuideSchool {
  final String name;
  final String email;
  final String executive;
  final String address;
  final String phone;

  GuideSchool(
      {@required this.name,
      @required this.email,
      @required this.executive,
      @required this.address,
      @required this.phone});

  factory GuideSchool.parseMap(Map object) {
    return GuideSchool(
        name: object['name'],
        email: object['email'],
        executive: object['executive'],
        address: object['address'],
        phone: object['phone']);
  }

  static List<GuideSchool> parseList(List objectList) {
    List<GuideSchool> list = [];
    for (Map item in objectList) list.add(GuideSchool.parseMap(item));
    return list;
  }
}
