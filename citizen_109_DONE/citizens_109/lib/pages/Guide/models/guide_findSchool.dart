import 'package:flutter/material.dart';

class GuideFindSchool {
  final String name;
  final String email;
  final String executive;
  final String address;
  final String phone;

  GuideFindSchool(
      {@required this.name,
      @required this.email,
      @required this.executive,
      @required this.address,
      @required this.phone});

  factory GuideFindSchool.parseMap(Map object) {
    return GuideFindSchool(
        name: object['name'],
        email: object['email'],
        executive: object['executive'],
        address: object['address'],
        phone: object['phone']);
  }

  static List<GuideFindSchool> parseList(List objectList) {
    List<GuideFindSchool> list = [];
    for (Map item in objectList) list.add(GuideFindSchool.parseMap(item));
    return list;
  }
}
