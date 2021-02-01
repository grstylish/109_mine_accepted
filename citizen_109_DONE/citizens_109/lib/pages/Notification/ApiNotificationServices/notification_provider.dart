import 'package:citizens01/pages/Notification/models/notification_news.dart';
import 'package:http/http.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

class NotificationProvider {
  Future<List<NotificationNews>> getNotificationProvider() async {
    Response response;
    response = await http.get("https://ccc.akt.kz/portal/api/get_news/",
        headers: {'Content-Type': 'application/json'});
    print(response.statusCode);
    if (response.statusCode == 200) {
      Map object = convert.jsonDecode(convert.utf8.decode(response.bodyBytes));
      if (object["status"] == 400) throw object['error'];
    } else {
      throw "Попробуйте позже";
    }
    Map object = convert.jsonDecode(convert.utf8.decode(response.bodyBytes));
    return NotificationNews.parseList(object['dat']);
  }

  Future<void> getSendConfirmNotification(phone, token, choice) async {
    Response response;
    try {
      print(convert.jsonEncode({
        'phone': phone,
        'token': token,
        'choice': choice,
      }));
      response =
          await http.post('https://ccc.akt.kz/portal/api/push_notification/',
              body: convert.jsonEncode({
                'phone': phone,
                'token': token,
                'choice': choice,
              }),
              headers: {'Content-Type': 'application/json'});
      Map object = convert.jsonDecode(convert.utf8.decode(response.bodyBytes));
      print(object);
    } catch (e) {
      print(e);
    }
  }
}
