import 'package:flutter/foundation.dart';

class GuideFindKsk {
  final String name;
  final String address;
  final String phone;

  GuideFindKsk(
      {@required this.name, @required this.address, @required this.phone});

  factory GuideFindKsk.parseMap(Map object) {
    return GuideFindKsk(
        name: object['name'],
        address: object['address'],
        phone: object['phone']);
  }

  static List<GuideFindKsk> parseList(List objectList) {
    List<GuideFindKsk> list = [];
    for (Map item in objectList) list.add(GuideFindKsk.parseMap(item));
    return list;
  }
}
