import 'package:flutter/material.dart';

class GuidePharmacy {
  final String name;
  final String address;
  final String contact;
  final String objectType;
  final String saleType;
  final String phone;

  GuidePharmacy(
      {@required this.name,
      @required this.address,
      @required this.contact,
      @required this.objectType,
      @required this.saleType,
      @required this.phone});

  factory GuidePharmacy.parseMap(Map object) {
    return GuidePharmacy(
        name: object['name'],
        address: object['address'],
        contact: object['contact'],
        objectType: object['object_type'],
        saleType: object['sale_type'],
        phone: object['phone']);
  }

  static List<GuidePharmacy> parseList(List objectList) {
    List<GuidePharmacy> list = [];
    for (Map item in objectList) list.add(GuidePharmacy.parseMap(item));
    return list;
  }
}
