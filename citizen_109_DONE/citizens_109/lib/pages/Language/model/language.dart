import 'package:citizens01/pages/Language/model/language_apply_page.dart';
import 'package:citizens01/pages/Language/model/language_auth_page.dart';
import 'package:citizens01/pages/Language/model/language_guide_page.dart';
import 'package:citizens01/pages/Language/model/language_notification_page.dart';
import 'package:citizens01/pages/Language/model/language_profile_page.dart';
import 'package:citizens01/pages/Language/model/language_trace_page.dart';
import 'package:flutter/material.dart';

class Language {
  static const String ru = "RU";
  static const String kz = "KZ";

  final LanguageProfilePage languageProfilePage;
  final List<LanguageNotificationPage> languageNotificationPage;
  final LanguageGuidePage languageGuidePage;
  final LanguageApplyPage languageApplyPage;
  final LanguageTracePage languageTracePage;
  final LanguageAuthPage languageAuthPage;

  Language(
      {@required this.languageProfilePage,
      @required this.languageNotificationPage,
      @required this.languageGuidePage,
      @required this.languageApplyPage,
      @required this.languageTracePage,
      @required this.languageAuthPage});

  static Future<Language> rus() async {
    return Language(
        languageProfilePage: await LanguageProfilePage.parseJson(),
        languageNotificationPage: LanguageNotificationPage.rus(),
        languageGuidePage: await LanguageGuidePage.parseJson(),
        languageApplyPage: await LanguageApplyPage.parseJson(),
        languageTracePage: await LanguageTracePage.parseJson(),
        languageAuthPage: await LanguageAuthPage.parseJson());
  }

  static Future<Language> kaz() async {
    return Language(
        languageProfilePage: await LanguageProfilePage.parseJson(isRus: false),
        languageNotificationPage: LanguageNotificationPage.kaz(),
        languageGuidePage: await LanguageGuidePage.parseJson(isRus: false),
        languageApplyPage: await LanguageApplyPage.parseJson(isRus: false),
        languageTracePage: await LanguageTracePage.parseJson(isRus: false),
        languageAuthPage: await LanguageAuthPage.parseJson(isRus: false));
  }
}
