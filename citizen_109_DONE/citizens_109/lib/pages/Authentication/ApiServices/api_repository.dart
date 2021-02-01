import 'dart:convert';

import 'package:citizens01/pages/AuthApp/AuthApiServices/api_provider.dart';
import 'package:citizens01/pages/Profile/models/profile_information.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiRepository {
  final ApiProvider apiProvider = ApiProvider();
  final FlutterSecureStorage storage = FlutterSecureStorage();
//Для получения кода
  Future<void> getStatusProvider(username, lastname, email, phone) async {
    String accToken = await storage.read(key: 'access_token');
    print('ACCTKN =>>>>> $accToken');
    await apiProvider.getStatus(username, lastname, email, phone, accToken);
  }

  Future<ProfileInformation> getProfileInformation() async {
    String jsonString = await storage.read(key: 'profile_data');
    print("OTTTTTTTT $jsonString");
    if (jsonString == null) return null;
    return ProfileInformation.fromMap(json.decode(jsonString));
  }

//Для подтверждения кода
  Future<bool> getCodeProvider(String code) async {
    String accToken = await storage.read(key: 'access_token');
    print('access_token $accToken');
    final profile = await apiProvider.getCode(code, accToken);
    print("THIS IS APIIII REPOSITORY");
    print(profile.toMap());
    await storage.write(
        key: 'profile_data', value: json.encode(profile.toMap()));
    return false;
  }
}
