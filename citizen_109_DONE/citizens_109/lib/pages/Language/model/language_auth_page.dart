import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LanguageAuthPage {
  final String title1;
  final String title2;
  final String title3;
  final String mustfield;
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final String getCode;
  final String registration;
  final String resend;
  final String enterCode;
  final String name109;
  final String timertext1;
  final String timertext2;
  final String timertext3;
  final String error;

  LanguageAuthPage(
      {@required this.title1,
      @required this.title2,
      @required this.title3,
      @required this.mustfield,
      @required this.firstName,
      @required this.lastName,
      @required this.phoneNumber,
      @required this.getCode,
      @required this.registration,
      @required this.resend,
      @required this.enterCode,
      @required this.name109,
      @required this.timertext1,
      @required this.timertext2,
      @required this.timertext3,
      @required this.error});

  static Future<LanguageAuthPage> parseJson({bool isRus = true}) async {
    String jsonString =
        await rootBundle.loadString("images/translations/auth_translate.json");
    Map objectMap = json.decode(jsonString);
    objectMap = isRus ? objectMap['rus'] : objectMap['kaz'];
    return LanguageAuthPage(
        title1: objectMap['title1'],
        title2: objectMap['title2'],
        title3: objectMap['title3'],
        mustfield: objectMap['mustfield'],
        firstName: objectMap['firstName'],
        lastName: objectMap['lastName'],
        phoneNumber: objectMap['phoneNumber'],
        getCode: objectMap['getCode'],
        registration: objectMap['registration'],
        resend: objectMap['resend'],
        enterCode: objectMap['enterCode'],
        name109: objectMap['name109'],
        timertext1: objectMap['timertext1'],
        timertext2: objectMap['timertext2'],
        timertext3: objectMap['timertext3'],
        error: objectMap['error']);
  }
}
