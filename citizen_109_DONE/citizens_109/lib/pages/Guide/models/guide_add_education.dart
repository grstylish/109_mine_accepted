import 'package:flutter/material.dart';

class GuideAddEducation {
  final String name;
  final String email;
  final String executive;
  final String address;
  final String phone;

  GuideAddEducation(
      {@required this.name,
      @required this.email,
      @required this.executive,
      @required this.address,
      @required this.phone});

  factory GuideAddEducation.parseMap(Map object) {
    return GuideAddEducation(
        name: object['name'],
        email: object['email'],
        executive: object['executive'],
        address: object['address'],
        phone: object['phone']);
  }

  static List<GuideAddEducation> parseList(List objectList) {
    List<GuideAddEducation> list = [];
    for (Map item in objectList) list.add(GuideAddEducation.parseMap(item));
    return list;
  }
}
