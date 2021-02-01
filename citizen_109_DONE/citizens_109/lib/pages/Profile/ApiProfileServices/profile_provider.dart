import 'package:citizens01/pages/Profile/models/profile_information.dart';
import 'package:http/http.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

class ProfileProvider {
  Future<ProfileInformation> getProfileInformation(phone, token) async {
    Response response;
    print("GetInformation");
    final s = convert.jsonEncode({'phone': phone, 'jwt_token': token});
    print(s);
    response = await http.post("https://ccc.akt.kz/portal/api/profile/",
        headers: {'Content-Type': 'application/json'}, body: s);
    print("Status =>>>> ${response.statusCode}");
    if (response.statusCode == 200) {
      Map object = convert.jsonDecode(convert.utf8.decode(response.bodyBytes));
      print(object);
      return ProfileInformation.fromMap(object['dat']);
    }
    throw "Попробуйте позже";
  }

  Future<void> getUpdateProfile(
      username, lastname, email, phone, token, accToken) async {
    Response response;
    try {
      response = await http.post('https://ident.akt.kz/auth/update_profile',
          body: convert.jsonEncode({
            'username': username,
            'lastname': lastname,
            'email': email,
            'phone': phone,
            'token': token
          }),
          headers: {'access-token': accToken});
      print("From Sapr");
      print(response.body);
      Map object = convert.jsonDecode(convert.utf8.decode(response.bodyBytes));
      print(object);
    } catch (e) {
      throw ("Error2 $e");
    }
    if (response.statusCode != 200) {
      throw "Попробуйте позже";
    }
  }

  Future<void> getUpdateEmail(
      username, lastname, email, phone, token, accToken) async {
    Response response;
    try {
      response = await http.post('https://ident.akt.kz/auth/update_profile',
          body: convert.jsonEncode({
            'username': username,
            'lastname': lastname,
            'email': email,
            'phone': phone,
            'token': token
          }),
          headers: {'access-token': accToken});
      print(response.body);
      Map object = convert.jsonDecode(convert.utf8.decode(response.bodyBytes));
      print(object);
    } catch (e) {
      throw ("Error2 $e");
    }
    if (response.statusCode != 200) {
      throw "Попробуйте позже";
    }
  }
}
