import 'package:citizens01/pages/Language/ApiLanguageServices/language_repository.dart';
import 'package:citizens01/pages/Trace/models/active_tracename.dart';
import 'package:citizens01/pages/Trace/models/search_tracename.dart';
import 'package:http/http.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

class TraceProvider {
  LanguageRepository _languageRepository = LanguageRepository();
  Future<List<ActiveTraceName>> getActiveTraceName(String phone) async {
    Response response;

    final s = convert.jsonEncode({'phone': phone});
    response = await http.post(
        "https://ccc.akt.kz/portal/api/track_application/",
        headers: {'Content-Type': 'application/json'},
        body: s);
    if (response.statusCode == 200) {
      Map object = convert.jsonDecode(convert.utf8.decode(response.bodyBytes));

      if (object["status"] == 400) {
        String languageType = await _languageRepository.fetchLanguage();
        languageType == 'KZ' ? throw object['error_kz'] : throw object['error'];
      }
      print(object);

      print("========>>>>> ${object['error']}");
    } else {
      throw "Попробуйте позже";
    }
    Map object = convert.jsonDecode(convert.utf8.decode(response.bodyBytes));
    return ActiveTraceName.parseList(object['dat']);
  }

// if (object["dat"]?.isEmpty ?? true) throw "";

  Future<List<SearchTraceName>> getSearchTraceName(String track_number) async {
    Response response;
    final s = convert.jsonEncode({'track_number': track_number});
    response = await http.post(
        "https://ccc.akt.kz/portal/api/track_application/",
        headers: {'Content-Type': 'application/json'},
        body: s);
    if (response.statusCode == 200) {
      Map object = convert.jsonDecode(convert.utf8.decode(response.bodyBytes));
      print("SEARCH $object");

      // if (object["dat"]?.isEmpty ?? true) throw "Нет активных заявок";
      if (object["status"] == 400) {
        String languageType = await _languageRepository.fetchLanguage();
        languageType == 'KZ' ? throw object['error_kz'] : throw object['error'];
      }
    } else {
      throw "Попробуйте позже";
    }
    Map object = convert.jsonDecode(convert.utf8.decode(response.bodyBytes));
    return SearchTraceName.parseList(object['dat']);
  }

  Future<void> getSendRequest(
      phone, token, int rating, comment, track_number) async {
    Response response;
    try {
      print(convert.jsonEncode({
        'phone': phone,
        'jwt_token': token,
        'rating': rating,
        'comment': comment,
        'track_number': track_number
      }));
      response =
          await http.post('https://ccc.akt.kz/portal/api/evaluate_application/',
              body: convert.jsonEncode({
                'phone': phone,
                'jwt_token': token,
                'rating': rating,
                'comment': comment,
                'track_number': track_number
              }),
              headers: {'Content-Type': 'application/json'});
      Map object = convert.jsonDecode(convert.utf8.decode(response.bodyBytes));
      print(object);
    } catch (e) {
      print(e);
    }
  }
}
