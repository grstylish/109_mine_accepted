import 'package:flutter/foundation.dart';

class GuideSearch {
  final String name;

  GuideSearch({@required this.name});

  factory GuideSearch.parseMap(Map object) {
    return GuideSearch(name: object['name']);
  }

  static List<GuideSearch> parseList(List objectList) {
    List<GuideSearch> list = [];
    for (Map item in objectList) list.add(GuideSearch.parseMap(item));
    return list;
  }
}
