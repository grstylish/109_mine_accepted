import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LanguageApplyPage {
  final String chooseCategory;
  final String changeCategory;
  final String mustfield;
  final String category;
  final String chooseCategoryName;
  final String address;
  final String map;
  final String cause;
  final String responsibility;
  final String applybtn;
  final String addPhoto;
  final String accepted;
  final String name109;
  final String mapbtn;
  final String error;

  LanguageApplyPage(
      {@required this.chooseCategory,
      @required this.changeCategory,
      @required this.mustfield,
      @required this.category,
      @required this.chooseCategoryName,
      @required this.address,
      @required this.map,
      @required this.cause,
      @required this.responsibility,
      @required this.applybtn,
      @required this.addPhoto,
      @required this.accepted,
      @required this.name109,
      @required this.mapbtn,
      @required this.error});

  static Future<LanguageApplyPage> parseJson({bool isRus = true}) async {
    String jsonString =
        await rootBundle.loadString("images/translations/apply_translate.json");
    Map objectMap = json.decode(jsonString);
    objectMap = isRus ? objectMap['rus'] : objectMap['kaz'];
    return LanguageApplyPage(
        address: objectMap['address'],
        applybtn: objectMap['applybtn'],
        category: objectMap['category'],
        cause: objectMap['cause'],
        changeCategory: objectMap['changeCategory'],
        chooseCategory: objectMap['chooseCategory'],
        chooseCategoryName: objectMap['chooseCategoryName'],
        map: objectMap['map'],
        mustfield: objectMap['mustfield'],
        responsibility: objectMap['responsibility'],
        addPhoto: objectMap['addPhoto'],
        accepted: objectMap['accepted'],
        name109: objectMap['name109'],
        mapbtn: objectMap['mapbtn'],
        error: objectMap['error']);
  }
}
