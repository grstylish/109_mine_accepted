import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LanguageProfilePage {
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final String notification;
  final String alerts;
  final String turnOn;
  final String turnOff;
  final String change;
  final String yourProfile;
  final String changeProfile;
  final String btncontinue;
  final String mustfield;
  final String name109;
  final String saved;
  final String alertsnot;
  final String receivenatification;
  final String yes;
  final String no;
  final String error;
  final String logout;

  LanguageProfilePage(
      {@required this.firstName,
      @required this.lastName,
      @required this.phoneNumber,
      @required this.notification,
      @required this.alerts,
      @required this.turnOn,
      @required this.turnOff,
      @required this.change,
      @required this.yourProfile,
      @required this.changeProfile,
      @required this.btncontinue,
      @required this.mustfield,
      @required this.name109,
      @required this.saved,
      @required this.alertsnot,
      @required this.receivenatification,
      @required this.no,
      @required this.yes,
      @required this.error,
      @required this.logout});

  static Future<LanguageProfilePage> parseJson({bool isRus = true}) async {
    String jsonString = await await rootBundle
        .loadString("images/translations/profile_translate.json");
    Map objectMap = json.decode(jsonString);
    objectMap = isRus ? objectMap['rus'] : objectMap['kaz'];
    return LanguageProfilePage(
        firstName: objectMap['firstName'],
        lastName: objectMap['lastName'],
        phoneNumber: objectMap['phoneNumber'],
        notification: objectMap['notification'],
        alerts: objectMap['alerts'],
        change: objectMap['change'],
        turnOff: objectMap['turnOff'],
        turnOn: objectMap['turnOn'],
        yourProfile: objectMap['yourProfile'],
        changeProfile: objectMap['changeProfile'],
        btncontinue: objectMap['btncontinue'],
        mustfield: objectMap['mustfield'],
        name109: objectMap['name109'],
        saved: objectMap['saved'],
        alertsnot: objectMap['alertsnot'],
        receivenatification: objectMap['receivenatification'],
        yes: objectMap['yes'],
        no: objectMap['no'],
        error: objectMap['error'],
        logout: objectMap['logout']);
  }
}
