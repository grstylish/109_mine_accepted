import 'dart:async';
import 'dart:convert';

import 'package:citizens01/pages/Authentication/ApiServices/api_repository.dart';
import 'package:citizens01/pages/Profile/ApiProfileServices/profile_provider.dart';
import 'package:citizens01/pages/Profile/models/profile_information.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ProfileRepository {
  final ProfileProvider profileProvider = ProfileProvider();
  final ApiRepository apiRepository = ApiRepository();
  final FlutterSecureStorage storage = FlutterSecureStorage();

  Future<ProfileInformation> getProfileInformationProvider() async {
    final profile = await apiRepository.getProfileInformation();
    return await profileProvider.getProfileInformation(
        profile.phone, profile.token);
  }

  Future<void> getUpdateProfileProvider(username, lastname) async {
    String data = await storage.read(key: 'profile_data');
    print("PROFIIILLLEEE $data");
    Map<String, dynamic> data1 = json.decode(data);
    var profile = ProfileInformation.fromMap(data1);
    String token = profile.token;
    String phone = profile.phone;
    String email = profile.email;
    String accToken = await storage.read(key: 'access_token');
    profile = profile.updateNames(username, lastname);
    await storage.write(
        key: 'profile_data', value: json.encode(profile.toMap()));

    return await profileProvider.getUpdateProfile(
        username, lastname, email, phone, token, accToken);
  }

  Future<void> getUpdateEmailProvider(email) async {
    String data = await storage.read(key: 'profile_data');
    print("PROFIIILLLEEE $data");
    Map<String, dynamic> data1 = json.decode(data);
    var profile = ProfileInformation.fromMap(data1);
    String token = profile.token;
    String phone = profile.phone;
    String lastname = profile.lastname;
    String username = profile.username;
    String accToken = await storage.read(key: 'access_token');
    profile = profile.updateEmail(email);
    await storage.write(
        key: 'profile_data', value: json.encode(profile.toMap()));

    return await profileProvider.getUpdateProfile(
        username, lastname, email, phone, token, accToken);
  }
}
