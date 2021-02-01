import 'package:flutter/cupertino.dart';

class ProfileInformation {
  final String username;
  final String lastname;
  final String email;
  final String phone;
  final String token;

  ProfileInformation({
    @required this.username,
    @required this.lastname,
    @required this.email,
    @required this.phone,
    @required this.token,
  });

  factory ProfileInformation.fromMap(Map<String, dynamic> object) {
    return ProfileInformation(
      username: object['username'],
      lastname: object['lastname'],
      email: object['email'],
      phone: object['phone'],
      token: object['token'],
    );
  }

  static List<ProfileInformation> parseList(List objectList) {
    List<ProfileInformation> list = [];
    for (Map item in objectList) list.add(ProfileInformation.fromMap(item));
    return list;
  }

  ProfileInformation updateNames(String username, String lastname) {
    return ProfileInformation(
      username: username,
      lastname: lastname,
      email: this.email,
      phone: this.phone,
      token: this.token,
    );
  }

  ProfileInformation updateEmail(String email) {
    return ProfileInformation(
        username: this.username,
        lastname: this.lastname,
        email: email,
        phone: this.phone,
        token: this.token);
  }

  Map toMap() {
    return {
      'username': this.username,
      'lastname': this.lastname,
      'email': this.email,
      'phone': this.phone,
      'token': this.token,
    };
  }
}
