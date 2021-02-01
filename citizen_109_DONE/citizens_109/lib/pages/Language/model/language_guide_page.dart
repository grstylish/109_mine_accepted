import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LanguageGuidePage {
  final String chooseDirectory;
  final String changeDirectory;
  final String nameDirectoryKsk;
  final String nameDirectoryGu;
  final String chooseStreet;
  final String chooseStreetNumber;
  final String findKsk;
  final String nameKsk;
  final String addressKsk;
  final String phoneKsk;
  final String nameGu;
  final String boss;
  final String call;
  final String name109;
  final String nameApteka;
  final String saleType;
  final String contact;
  final String chooseNamePharmacy;
  final String choosePharmacyAddress;
  final String findPharmacy;
  final String guideLift;
  final String guideHospital;
  final String chooseHospitalName;
  final String guideAddEducation;
  final String guideSchool;
  final String chooseguideSchoolName;
  final String guidekinder;
  final String chooseguidekindername;
  final String error;

  LanguageGuidePage(
      {@required this.chooseDirectory,
      @required this.changeDirectory,
      @required this.nameDirectoryKsk,
      @required this.nameDirectoryGu,
      @required this.chooseStreet,
      @required this.chooseStreetNumber,
      @required this.findKsk,
      @required this.nameKsk,
      @required this.addressKsk,
      @required this.phoneKsk,
      @required this.nameGu,
      @required this.boss,
      @required this.call,
      @required this.name109,
      @required this.nameApteka,
      @required this.saleType,
      @required this.contact,
      @required this.chooseNamePharmacy,
      @required this.choosePharmacyAddress,
      @required this.findPharmacy,
      @required this.guideLift,
      @required this.guideHospital,
      @required this.chooseHospitalName,
      @required this.guideAddEducation,
      @required this.guideSchool,
      @required this.chooseguideSchoolName,
      @required this.guidekinder,
      @required this.chooseguidekindername,
      @required this.error});

  static Future<LanguageGuidePage> parseJson({bool isRus = true}) async {
    String jsonString =
        await rootBundle.loadString("images/translations/guide_translate.json");
    Map objectMap = json.decode(jsonString);
    objectMap = isRus ? objectMap['rus'] : objectMap['kaz'];
    return LanguageGuidePage(
        boss: objectMap['boss'],
        call: objectMap['call'],
        changeDirectory: objectMap['changeDirectory'],
        chooseStreet: objectMap['chooseStreet'],
        chooseDirectory: objectMap['chooseDirectory'],
        chooseStreetNumber: objectMap['chooseStreetNumber'],
        findKsk: objectMap['findKsk'],
        addressKsk: objectMap['addressKsk'],
        nameDirectoryGu: objectMap['nameDirectoryGu'],
        nameDirectoryKsk: objectMap['nameDirectoryKsk'],
        nameGu: objectMap['nameGu'],
        nameKsk: objectMap['nameKsk'],
        phoneKsk: objectMap['phoneKsk'],
        name109: objectMap['name109'],
        contact: objectMap['contact'],
        nameApteka: objectMap['nameApteka'],
        saleType: objectMap['saleType'],
        chooseNamePharmacy: objectMap['chooseNamePharmacy'],
        choosePharmacyAddress: objectMap['choosePharmacyAddress'],
        findPharmacy: objectMap['findPharmacy'],
        guideLift: objectMap['guideLift'],
        guideHospital: objectMap['guideHospital'],
        chooseHospitalName: objectMap['chooseHospitalName'],
        guideAddEducation: objectMap['guideAddEducation'],
        guideSchool: objectMap['guideSchool'],
        chooseguideSchoolName: objectMap['chooseguideSchoolName'],
        guidekinder: objectMap['guidekinder'],
        chooseguidekindername: objectMap['chooseguidekindername'],
        error: objectMap['error']);
  }
}
