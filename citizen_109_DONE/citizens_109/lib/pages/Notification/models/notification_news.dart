import 'package:flutter/material.dart';

class NotificationNews {
  final String lbl;
  final String lblkz;
  final String from;
  final String to;

  NotificationNews(
      {@required this.lbl,
      @required this.lblkz,
      @required this.from,
      @required this.to});

  factory NotificationNews.parseMap(Map object) {
    String from = object['from'];
    if (from != null) from += ' Z';
    String to = object['to'];
    if (to != null) to += ' Z';
    return NotificationNews(
        lbl: object['lbl'], lblkz: object['lbl_kz'], from: from, to: to);
  }

  static List<NotificationNews> parseList(List objectList) {
    List<NotificationNews> list = [];
    for (Map item in objectList) list.add(NotificationNews.parseMap(item));
    return list;
  }

  String get getFrom {
    String from = DateTime.parse(this.from).toLocal().toString();
    return from.substring(0, from.length - 4);
  }

  String get getTo {
    String to = DateTime.parse(this.to).toLocal().toString();
    return to.substring(0, to.length - 4);
  }
}
