import 'package:flutter/material.dart';

class GuideFindPharmacy {
  final String name;
  final String address;
  final String contact;
  final String saleType;
  final String phone;

  GuideFindPharmacy(
      {@required this.name,
      @required this.address,
      @required this.contact,
      @required this.saleType,
      @required this.phone});

  factory GuideFindPharmacy.parseMap(Map object) {
    return GuideFindPharmacy(
        name: object['name'],
        address: object['address'],
        contact: object['contact'],
        saleType: object['sale_type'],
        phone: object['phone']);
  }

  static List<GuideFindPharmacy> parseList(List objectList) {
    List<GuideFindPharmacy> list = [];
    for (Map item in objectList) list.add(GuideFindPharmacy.parseMap(item));
    return list;
  }
}
