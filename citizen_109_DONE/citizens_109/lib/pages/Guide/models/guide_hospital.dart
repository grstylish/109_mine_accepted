import 'package:flutter/material.dart';

class GuideHospital {
  final String name;
  final String address;
  final String email;
  final String contact;
  final String phone;

  GuideHospital(
      {@required this.name,
      @required this.address,
      @required this.email,
      @required this.contact,
      @required this.phone});

  factory GuideHospital.parseMap(Map object) {
    return GuideHospital(
        name: object['name'],
        address: object['address'],
        email: object['email'],
        contact: object['contact'],
        phone: object['phone']);
  }
  static List<GuideHospital> parseList(List objectList) {
    List<GuideHospital> list = [];
    for (Map item in objectList) list.add(GuideHospital.parseMap(item));
    return list;
  }
}
