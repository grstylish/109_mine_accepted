import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

class LanguageTracePage {
  final String track;
  final String addNumberTrack;
  final String findtrack;
  final String activeTrack;
  final String chooseCategoryName;
  final String status;
  final String subtext;
  final String subtext1;
  final String rate;
  final String closebtn;
  final String comment;
  final String traceText1;
  final String traceText2;
  final String traceText3;
  final String name109;
  final String accepted;
  final String returnback;
  final String report;
  final String error;

  LanguageTracePage(
      {@required this.track,
      @required this.addNumberTrack,
      @required this.findtrack,
      @required this.activeTrack,
      @required this.chooseCategoryName,
      @required this.status,
      @required this.subtext,
      @required this.subtext1,
      @required this.rate,
      @required this.closebtn,
      @required this.comment,
      @required this.traceText1,
      @required this.traceText2,
      @required this.traceText3,
      @required this.name109,
      @required this.accepted,
      @required this.returnback,
      @required this.report,
      @required this.error});

  static Future<LanguageTracePage> parseJson({bool isRus = true}) async {
    String jsonString =
        await rootBundle.loadString("images/translations/trace_translate.json");
    Map objectMap = json.decode(jsonString);
    objectMap = isRus ? objectMap['rus'] : objectMap['kaz'];
    return LanguageTracePage(
        track: objectMap['track'],
        addNumberTrack: objectMap['addNumberTrack'],
        findtrack: objectMap['findtrack'],
        activeTrack: objectMap['activeTrack'],
        chooseCategoryName: objectMap['chooseCategoryName'],
        status: objectMap['status'],
        subtext: objectMap['subtext'],
        subtext1: objectMap['subtext1'],
        rate: objectMap['rate'],
        closebtn: objectMap['closebtn'],
        comment: objectMap['comment'],
        traceText1: objectMap['traceText1'],
        traceText2: objectMap['traceText2'],
        traceText3: objectMap['traceText3'],
        name109: objectMap['name109'],
        accepted: objectMap['accepted'],
        returnback: objectMap['returnback'],
        report: objectMap['report'],
        error: objectMap['error']);
  }
}
