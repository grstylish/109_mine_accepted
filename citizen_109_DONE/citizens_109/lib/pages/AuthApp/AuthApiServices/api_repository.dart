import 'dart:convert';

import 'package:citizens01/pages/AuthApp/AuthApiServices/api_provider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthAppRepository {
  final ApiProvider apiProvider = ApiProvider();
  final FlutterSecureStorage storage = FlutterSecureStorage();

  Future<bool> getAccessProvider() async {
    print('Fetching access token:');
    String accessToken = await apiProvider.getAccToken();
    print(accessToken);
    if (accessToken != null) {
      await storage.write(key: 'access_token', value: accessToken);
      print("Access_token in STORAGE: $accessToken");
      return true;
    }
    return false;
  }

  Future<String> checkJwtToken() async {
    try {
      //Удаление со storage
      // await storage.delete(key: 'profile_data');
      String data = await storage.read(key: 'profile_data');
      if (data == null) return null;
      Map<String, dynamic> data1 = json.decode(data);
      String jwtToken = data1['token'];
      return jwtToken;
      // print("JWTTOKEN $jwtToken");
    } catch (e) {
      print("CheckJwtToken ERROR $e");
      return null;
    }
  }

  Future<void> removeUser() async {
    await storage.delete(key: 'profile_data');
  }
}
