import 'package:citizens01/pages/Guide/models/guide_add_education.dart';
import 'package:citizens01/pages/Guide/models/guide_findHospital.dart';
import 'package:citizens01/pages/Guide/models/guide_findPharmacy.dart';
import 'package:citizens01/pages/Guide/models/guide_findSchool.dart';
import 'package:citizens01/pages/Guide/models/guide_findkindergarten.dart';
import 'package:citizens01/pages/Guide/models/guide_findksk.dart';
import 'package:citizens01/pages/Guide/models/guide_hospital.dart';
import 'package:citizens01/pages/Guide/models/guide_images.dart';
import 'package:citizens01/pages/Guide/models/guide_information.dart';
import 'package:citizens01/pages/Guide/models/guide_kindergarten.dart';
import 'package:citizens01/pages/Guide/models/guide_lift.dart';
import 'package:citizens01/pages/Guide/models/guide_pharmacy.dart';
import 'package:citizens01/pages/Guide/models/guide_school.dart';
import 'package:citizens01/pages/Guide/models/guide_search.dart';
import 'package:citizens01/pages/Guide/models/guide_street.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class GuideProvider {
  //Для получения image
  Future<List<GuideImages>> getGuideImages() async {
    Response response;
    print("GetImages");
    response = await http.get(
        "https://ccc.akt.kz/portal/api/reference_book_list/",
        headers: {'Content-Type': 'application/json'});
    print(response.statusCode);
    if (response.statusCode == 200) {
      Map object = convert.jsonDecode(convert.utf8.decode(response.bodyBytes));
      print("=====>>>> $object");
      return GuideImages.parseList(object['dat']);
    } else {
      throw "Попробуйте позже";
    }
  }

  // Для получения информации о ГУ
  Future<Guide> getGuideInformation() async {
    Response response;
    print('START INFORMATION: getGuideInformation');
    response = await http.get("https://ccc.akt.kz/portal/api/get_ga/");
    print(response.statusCode);
    if (response.statusCode == 200) {
      // final List<dynamic> jsonInformation = convert.jsonDecode(response.body);
      Map object = convert.jsonDecode(convert.utf8.decode(response.bodyBytes));
      print(object['dat'][0]['rus']);
      final rus = GuideInformation.parseList(object['dat'][0]['ru']);
      final kaz = GuideInformation.parseList(object['dat'][0]['kz']);
      return Guide(rus, kaz);
    } else {
      throw "Попробуйте позже";
    }
  }

  // Для поиска улицы
  Future<List<GuideSearch>> getGuideSearch() async {
    Response response;
    print("Start Searching");
    response = await http.get("https://ccc.akt.kz/portal/api/aoc_streets/");
    print(response.statusCode);
    if (response.statusCode == 200) {
      Map object = convert.jsonDecode(convert.utf8.decode(response.bodyBytes));
      print(object);
      return GuideSearch.parseList(object['dat']);
    } else {
      throw "Попробуйте позже";
    }
  }

  // Для поиска номера дома
  Future<List<GuideStreetNumber>> getGuideStreetNumber(String street) async {
    Response response;
    print("Start Search Street Number");
    response = await http.post(
      "https://ccc.akt.kz/portal/api/aoc_houses/",
      headers: {'Content-Type': 'application/json'},
      body: convert.utf8.encode(convert.jsonEncode({'street': street})),
    );
    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 200) {
      Map object = convert.jsonDecode(convert.utf8.decode(response.bodyBytes));
      print(object);
      return GuideStreetNumber.parseList(object['dat']);
    }
    return [];
  }

  //Для поиска КСК при нажатии
  Future<GuideFindKsk> getGuideFindKsk(String name, String house) async {
    Response response;
    print("START FIND KSK");
    response = await http.post("https://ccc.akt.kz/portal/api/get_aoc/",
        headers: {'Content-Type': 'application/json'},
        body: convert.utf8
            .encode(convert.jsonEncode({'street': name, 'house': house})));
    print(response.statusCode);

    if (response.statusCode == 200) {
      Map object = convert.jsonDecode(convert.utf8.decode(response.bodyBytes));
      print(object);
      if (object['status'] != 200) throw object['error'];
      return GuideFindKsk.parseMap(object['dat']);
    }
    throw "Попробуйте позже";
  }

  //Для получения информации об аптеке
  Future<List<GuidePharmacy>> getGuidePharmacy() async {
    Response response;
    print("START FIND PHARMACY");
    response = await http.get(
        "https://ccc.akt.kz/portal/api/get_pharmacy_list/",
        headers: {'Content-Type': 'application/json'});
    print(response.statusCode);
    if (response.statusCode == 200) {
      Map object = convert.jsonDecode(convert.utf8.decode(response.bodyBytes));
      print("=====>>>> $object");
      return GuidePharmacy.parseList(object['dat']);
    } else {
      throw "Попробуйте позже";
    }
  }

  //Для поиска GuideFindPharmacy
  Future<GuideFindPharmacy> getGuideFindPharmacy(
      String name, String address) async {
    Response response;
    print("START FIND GuideFindPharmacy");
    response = await http.post(
        "https://ccc.akt.kz/portal/api/get_pharmacy_list/",
        headers: {'Content-Type': 'application/json'},
        body: convert.utf8
            .encode(convert.jsonEncode({'name': name, 'address': address})));
    print(response.statusCode);

    if (response.statusCode == 200) {
      Map object = convert.jsonDecode(convert.utf8.decode(response.bodyBytes));
      print("FROM NURKHAT $object");
      if (object['status'] != 200) throw object['error'];
      return GuideFindPharmacy.parseMap(object['dat']);
    }
    throw "Попробуйте позже";
  }

  //Вывести информацию о Лифте
  Future<List<GuideLift>> getGuideLift() async {
    Response response;
    print("GuideLift");
    response = await http.get(
      'https://ccc.akt.kz/portal/api/get_service_list/',
      headers: {'Content-Type': 'application/json'},
    );
    print(response.statusCode);
    if (response.statusCode == 200) {
      Map object = convert.jsonDecode(convert.utf8.decode(response.bodyBytes));
      print("Guidelift  Provider  $object");

      return GuideLift.parseList(object['dat']);
    } else {
      throw "Попробуйте позже";
    }
  }

  //Вывести информацию о поликлинике
  Future<List<GuideHospital>> getGuideHospital() async {
    Response response;
    print("GuideHospital");
    response = await http.get(
      'https://ccc.akt.kz/portal/api/get_lpo_list/',
      headers: {'Content-Type': 'application/json'},
    );
    print(response.statusCode);
    if (response.statusCode == 200) {
      Map object = convert.jsonDecode(convert.utf8.decode(response.bodyBytes));
      print("=====>>>> $object");
      return GuideHospital.parseList(object['dat']);
    } else {
      throw "Попробуйте позже";
    }
  }

  //Для поиска поликлинике
  Future<GuideFindHospital> getGuideFindHospital(String name) async {
    Response response;
    print("START GuideFindHospital");
    response = await http.post("https://ccc.akt.kz/portal/api/get_lpo_list/",
        headers: {'Content-Type': 'application/json'},
        body: convert.utf8.encode(convert.jsonEncode({'name': name})));
    print(response.statusCode);

    if (response.statusCode == 200) {
      Map object = convert.jsonDecode(convert.utf8.decode(response.bodyBytes));
      print(object);
      if (object['status'] != 200) throw object['error'];
      return GuideFindHospital.parseMap(object['dat']);
    }
    throw "Попробуйте позже";
  }

  //Инфо о доп образовании
  Future<List<GuideAddEducation>> getGuideAddEducation() async {
    Response response;
    print(GuideAddEducation);
    response = await http.get(
      'https://ccc.akt.kz/portal/api/get_add_edu_list/',
      headers: {'Content-Type': 'application/json'},
    );
    print(response.statusCode);
    if (response.statusCode == 200) {
      Map object = convert.jsonDecode(convert.utf8.decode(response.bodyBytes));
      print("GuideAddEducation  Provider  $object");
      return GuideAddEducation.parseList(object['dat']);
    } else {
      throw "Попробуйте позже";
    }
  }

  //Для того чтобы вывести инфо об школах
  Future<List<GuideSchool>> getGuideSchool() async {
    Response response;
    print("Start GuideSchool");
    response = await http.get('https://ccc.akt.kz/portal/api/get_school_list/',
        headers: {'Content-Type': 'application/json'});
    print(response.statusCode);
    if (response.statusCode == 200) {
      Map object = convert.jsonDecode(convert.utf8.decode(response.bodyBytes));
      print("=====>>>> $object");
      return GuideSchool.parseList(object['dat']);
    } else {
      throw "Попробуйте позже";
    }
  }

  //Найти школу
  Future<GuideFindSchool> getGuideFindSchool(String name) async {
    Response response;
    print("GuideFindSchool");
    response = await http.post('https://ccc.akt.kz/portal/api/get_school_list/',
        headers: {'Content-Type': 'application/json'},
        body: convert.utf8.encode(convert.jsonEncode({'name': name})));
    print(response.statusCode);
    if (response.statusCode == 200) {
      Map object = convert.jsonDecode(convert.utf8.decode(response.bodyBytes));
      print(object);
      if (object['status'] != 200) throw object['error'];
      return GuideFindSchool.parseMap(object['dat']);
    }
    throw "Попробуйте позже";
  }

  //Вывести информацию детсад
  Future<List<GuideKindergarten>> getGuideKindergarten() async {
    Response response;
    print("GuideKindergarten");
    response = await http.get(
        "https://ccc.akt.kz/portal/api/get_kindergarten_list/",
        headers: {'Content-Type': 'application/json'});
    print(response.statusCode);
    if (response.statusCode == 200) {
      Map object = convert.jsonDecode(convert.utf8.decode(response.bodyBytes));
      print("=====>>>> $object");
      return GuideKindergarten.parseList(object['dat']);
    } else {
      throw "Попробуйте позже";
    }
  }

  //детсад search
  Future<GuideFindKindergarten> getGuideFindKindergarten(String name) async {
    Response response;
    print("GuideFindKindergarten");
    response = await http.post(
        'https://ccc.akt.kz/portal/api/get_kindergarten_list/',
        headers: {'Content-Type': 'application/json'},
        body: convert.utf8.encode(convert.jsonEncode({'name': name})));
    print(response.statusCode);

    if (response.statusCode == 200) {
      Map object = convert.jsonDecode(convert.utf8.decode(response.bodyBytes));
      print("=====>>>> $object");
      if (object['status'] != 200) throw object['error'];
      return GuideFindKindergarten.parseMap(object['dat']);
    }
    throw "Попробуйте позже";
  }
}
