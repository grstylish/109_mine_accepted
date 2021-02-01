import 'package:flutter/cupertino.dart';

class Guide {
  final List<GuideInformation> rus;
  final List<GuideInformation> kaz;

  Guide(this.rus, this.kaz);
}

class GuideInformation {
  final String name;
  final List<Executive> executives;

  GuideInformation({
    @required this.name,
    @required this.executives,
  });

  factory GuideInformation.parseMap(Map object) {
    print(object);
    return GuideInformation(
      name: object['name'],
      executives: Executive.parseList(object['executive']),
    );
  }

  static List<GuideInformation> parseList(List objectList) {
    List<GuideInformation> list = [];
    for (Map item in objectList) list.add(GuideInformation.parseMap(item));
    print('LIST LENGTH: ${list.length}');
    return list;
  }
}

class Executive {
  final String fullName;
  final String address;
  final String phone;

  Executive({
    @required this.fullName,
    @required this.address,
    @required this.phone,
  });

  factory Executive.parseMap(Map object) {
    return Executive(
      fullName: object['full_name'],
      address: object['address'],
      phone: object['phone'],
    );
  }

  static List<Executive> parseList(List objectList) {
    List<Executive> list = [];
    print('LIST OBJECT: $objectList');
    for (Map item in objectList) list.add(Executive.parseMap(item));
    return list;
  }
}
