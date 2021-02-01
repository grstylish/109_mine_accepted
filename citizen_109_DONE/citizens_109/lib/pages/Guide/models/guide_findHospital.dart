import 'package:flutter/material.dart';

class GuideFindHospital {
  final String name;
  final String address;
  final String email;
  final String contact;
  final String phone;

  GuideFindHospital(
      {@required this.name,
      @required this.address,
      @required this.email,
      @required this.contact,
      @required this.phone});

  factory GuideFindHospital.parseMap(Map object) {
    return GuideFindHospital(
        name: object['name'],
        address: object['address'],
        email: object['email'],
        contact: object['contact'],
        phone: object['phone']);
  }

  static List<GuideFindHospital> parseList(List objectList) {
    List<GuideFindHospital> list = [];
    for (Map item in objectList) list.add(GuideFindHospital.parseMap(item));
    return list;
  }
}
