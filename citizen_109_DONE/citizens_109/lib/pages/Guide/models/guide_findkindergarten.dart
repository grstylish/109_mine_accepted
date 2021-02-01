import 'package:flutter/material.dart';

class GuideFindKindergarten {
  final String name;
  final String contact;
  final String executive;
  final String address;
  final String phone;

  GuideFindKindergarten(
      {@required this.name,
      @required this.contact,
      @required this.executive,
      @required this.address,
      @required this.phone});

  factory GuideFindKindergarten.parseMap(Map object) {
    return GuideFindKindergarten(
        name: object['name'],
        contact: object['contact'],
        executive: object['executive'],
        address: object['address'],
        phone: object['phone']);
  }

  static List<GuideFindKindergarten> parseList(List objectList) {
    List<GuideFindKindergarten> list = [];
    for (Map item in objectList) list.add(GuideFindKindergarten.parseMap(item));
    return list;
  }
}
