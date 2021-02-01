import 'package:flutter/cupertino.dart';

class ApplyCategories {
  final int id;
  final String name;
  final String groupName;
  final int groupID;
  final String namekz;
  final String groupNamekz;

  ApplyCategories(
      {@required this.id,
      @required this.name,
      @required this.groupName,
      @required this.groupID,
      @required this.namekz,
      @required this.groupNamekz});

  factory ApplyCategories.parseMap(Map object) {
    String groupName;
    int groupID;
    if (object['group'] != null) {
      groupID = object['group']['id'];
      groupName = object['group']['name'];
    }
    return ApplyCategories(
        name: object['name'],
        namekz: object['name_kz'],
        groupName: groupName,
        groupNamekz: object['name_kz'],
        groupID: groupID,
        id: object['id']);
  }
  static List<ApplyCategories> parseList(List objectList) {
    List<ApplyCategories> list = [];
    for (Map item in objectList) list.add(ApplyCategories.parseMap(item));
    return list;
  }
}
