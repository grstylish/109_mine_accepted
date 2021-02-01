import 'package:citizens01/pages/Profile/models/profile_information.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

FlutterSecureStorage storage;

class ApiProvider {
  Future<String> getAccToken() async {
    Response response;
    try {
      response = await http.post(
        'https://ident.akt.kz/auth/visits',
        body: convert
            .jsonEncode({'appl_code': 'MjAyMC0wNi0xMSAxNTowODowNC4zNzU3MjYx'}),
      );
    } catch (e) {
      print('ERROR $e');
      throw e;
    }
    if (response.statusCode != 200) {
      throw ('Invalid');
    }
    String accToken = convert.jsonDecode(response.body)['dat']['access_token'];
    return accToken;
  }

  Future<void> getStatus(username, lastname, email, phone, accessToken) async {
    Response response;
    try {
      response = await http.post('https://ident.akt.kz/auth/auth_mobile_login',
          body: convert.jsonEncode({
            'username': username,
            'lastname': lastname,
            'email': email,
            'phone': phone
          }),
          headers: {'access-token': accessToken});
      print(response.body);
    } catch (e) {
      throw ("Error2 $e");
    }
    if (response.statusCode != 200) {
      throw ("Invalid 2");
    }
  }

  Future<ProfileInformation> getCode(code, accessToken) async {
    Response response;
    try {
      response =
          await http.post('https://ident.akt.kz/auth/auth_mobile_login_code',
              body: convert.jsonEncode({
                'code': code,
              }),
              headers: {'access-token': accessToken});
      print(response.statusCode);
      print(response.body);
    } catch (e) {
      throw 400;
    }
    if (response.statusCode == 200) {
      Map object = convert.json.decode(response.body);
      if (object['sts'] == 'e') throw '';
      if (object['sts'] != 's') throw '';
    }

    Map object = convert.jsonDecode(convert.utf8.decode(response.bodyBytes));
    return ProfileInformation.fromMap(object['dat']);
  }
}
