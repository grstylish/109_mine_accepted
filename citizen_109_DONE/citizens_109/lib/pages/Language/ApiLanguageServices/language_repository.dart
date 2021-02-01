import 'package:citizens01/pages/Language/model/language.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LanguageRepository {
  FlutterSecureStorage storage = new FlutterSecureStorage();
  String key = 'language';

  Future<String> fetchLanguage() async {
    String jsonString = await storage.read(key: key);
    if (jsonString == null) return Language.ru;
    return jsonString;
  }

  Future<void> changeLanguage(String language) async {
    await storage.write(key: key, value: language);
  }
}
