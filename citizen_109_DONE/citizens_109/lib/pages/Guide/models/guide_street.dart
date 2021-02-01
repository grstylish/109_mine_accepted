import 'package:flutter/foundation.dart';

class GuideStreetNumber {
  final String number;

  GuideStreetNumber({@required this.number});

  factory GuideStreetNumber.parseMap(Map object) {
    return GuideStreetNumber(number: object['number']);
  }

  static List<GuideStreetNumber> parseList(List objectList) {
    List<GuideStreetNumber> list = [];
    for (Map item in objectList) list.add(GuideStreetNumber.parseMap(item));
    return list;
  }
}
