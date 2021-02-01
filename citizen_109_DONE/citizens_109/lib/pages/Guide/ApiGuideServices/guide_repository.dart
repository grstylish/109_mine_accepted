import 'package:citizens01/pages/Guide/ApiGuideServices/guide_provider.dart';
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
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class GuideRepository {
  final GuideProvider guideProvider = GuideProvider();
  final FlutterSecureStorage storage = FlutterSecureStorage();

//Для получения информации

  Future<List<GuideImages>> getGuideImagesProvider() async {
    return await guideProvider.getGuideImages();
  }

  //Для информации ГУ
  Future<Guide> getGuideInformationProvider() async {
    return await guideProvider.getGuideInformation();
  }

  //Для поиска улицы
  Future<List<GuideSearch>> getGuideSearchProvider() async {
    return await guideProvider.getGuideSearch();
  }

//Для поиска номера дома
  Future<List<GuideStreetNumber>> getGuideStreetProvider(String street) async {
    return await guideProvider.getGuideStreetNumber(street);
  }

//Для поиска КСК
  Future<GuideFindKsk> getGuideFindKskProvider(
      String name, String house) async {
    return await guideProvider.getGuideFindKsk(name, house);
  }

//Для получения информации об аптеке
  Future<List<GuidePharmacy>> getGuidePharmacyProvider() async {
    return await guideProvider.getGuidePharmacy();
  }

//Для поиска аптек
  Future<GuideFindPharmacy> getGuideFindPharmacyProvider(
      String name, String address) async {
    return await guideProvider.getGuideFindPharmacy(name, address);
  }

//Для информации Лифта
  Future<List<GuideLift>> getGuideLiftProvider() async {
    return await guideProvider.getGuideLift();
  }

  //Для информации поликлинике

  Future<List<GuideHospital>> getGuideHospitalProvider() async {
    return await guideProvider.getGuideHospital();
  }

  //Для поиска поликлинике

  Future<GuideFindHospital> getGuideFindHospitalProvider(String name) async {
    return await guideProvider.getGuideFindHospital(name);
  }

//Для информации Доп образования

  Future<List<GuideAddEducation>> getGuideAddEducationProvider() async {
    return await guideProvider.getGuideAddEducation();
  }

//Для школы
  Future<List<GuideSchool>> getGuideSchoolProvider() async {
    return await guideProvider.getGuideSchool();
  }

//Для поиска школы
  Future<GuideFindSchool> getGuideFindSchoolProvider(String name) async {
    return await guideProvider.getGuideFindSchool(name);
  }

  //Для получения информации детсад
  Future<List<GuideKindergarten>> getGuideKinderProvider() async {
    return await guideProvider.getGuideKindergarten();
  }

//Для поиска детсад
  Future<GuideFindKindergarten> getGuideFindKinderProvider(String name) async {
    return await guideProvider.getGuideFindKindergarten(name);
  }
}
