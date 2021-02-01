import 'package:flutter/foundation.dart';

class SearchTraceName {
  final String name;
  final String namekz;
  final String subname;
  final String subnamakz;
  final String deadline;
  final String comment;
  final bool israted;
  final int track_number;

  final List<Statuses> statuses;

  SearchTraceName(
      {@required this.name,
      @required this.namekz,
      @required this.subname,
      @required this.subnamakz,
      @required this.statuses,
      @required this.deadline,
      @required this.comment,
      @required this.israted,
      @required this.track_number});

  factory SearchTraceName.parseMap(Map object) {
    String deadline = object['deadline'];
    if (deadline != 'None') deadline += ' Z';

    return SearchTraceName(
        name: object['category'],
        namekz: object['category_kz'],
        subname: object['subcategory'],
        subnamakz: object['subcategory_kz'],
        deadline: deadline,
        comment: object['comment'],
        israted: object['israted'],
        track_number: object['track_number'],
        statuses: Statuses.parseList(object['statuses']));
  }

  static List<SearchTraceName> parseList(List objectList) {
    List<SearchTraceName> list = [];
    for (Map item in objectList) list.add(SearchTraceName.parseMap(item));
    return list;
  }

  String get getDeadline {
    if (deadline != 'None') {
      String deadline = DateTime.parse(this.deadline).toLocal().toString();
      return deadline.substring(0, deadline.length - 4);
    }
    if (deadline == 'None') {
      return '';
    }
  }
}

class Statuses {
  final String status;
  final String statuskz;
  final String lbl;
  final String lblkz;
  final String date;
  final List<String> file;

  Statuses(
      {@required this.status,
      @required this.lbl,
      @required this.date,
      @required this.statuskz,
      @required this.lblkz,
      @required this.file});

  factory Statuses.parseMap(Map object) {
    String date = object['date'];
    if (date != null) date += ' Z';
    return Statuses(
      status: object['status'],
      lbl: object['lbl'],
      date: date,
      statuskz: object['status_kz'],
      lblkz: object['lbl_kz'],
      file: object['file'] != null ? object['file'].cast<String>() : [],
    );
  }

  static List<Statuses> parseList(List objectList) {
    List<Statuses> list = [];
    for (Map item in objectList) list.add(Statuses.parseMap(item));
    return list;
  }

  String get getDate {
    String date = DateTime.parse(this.date).toLocal().toString();
    return date.substring(0, date.length - 4);
  }
}
