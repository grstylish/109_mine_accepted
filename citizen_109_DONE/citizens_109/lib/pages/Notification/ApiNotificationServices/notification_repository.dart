import 'dart:convert';

import 'package:citizens01/pages/Authentication/ApiServices/api_repository.dart';
import 'package:citizens01/pages/Notification/ApiNotificationServices/notification_provider.dart';
import 'package:citizens01/pages/Notification/models/notification_news.dart';
import 'package:citizens01/pages/Profile/ApiProfileServices/profile_provider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class NotificationRepository {
  final FlutterSecureStorage storage = FlutterSecureStorage();
  final ProfileProvider profileProvider = ProfileProvider();
  final ApiRepository apiRepository = ApiRepository();
  final String _notfKey = 'notf_action_key';

  final NotificationProvider notificationProvider = NotificationProvider();
  Future<List<NotificationNews>> getNotificationNewsProvider() async {
    return await notificationProvider.getNotificationProvider();
  }

  Future<void> setNotification(bool value) async {
    Map object = {'flag': value};
    await storage.write(key: _notfKey, value: json.encode(object));
  }

  Future<bool> getNotfication() async {
    String jsonString = await storage.read(key: _notfKey);
    if (jsonString == null) return null;
    Map object = json.decode(jsonString);
    print(object);
    return object['flag'];
  }

  Future<void> getSendConfigNotification(bool value) async {
    String devToken = await storage.read(key: 'token');
    print('devToken =>>>>> $devToken');
    String choice = value ? 'y' : 'n';
    final profile = await apiRepository.getProfileInformation();
    await notificationProvider.getSendConfirmNotification(
        profile.phone, devToken, choice);
  }
}
