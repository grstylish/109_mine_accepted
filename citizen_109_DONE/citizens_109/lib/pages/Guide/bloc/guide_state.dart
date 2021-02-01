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
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

abstract class GuideState extends Equatable {
  @override
  List<Object> get props => [];
}

class InitialGuideState extends GuideState {}

class LoadingGuideState extends GuideState {}

//Для получения image
class LoadedImageState extends GuideState {
  final List<GuideImages> loadedapplyimages;
  LoadedImageState({@required this.loadedapplyimages})
      : assert(loadedapplyimages != null);
}

class LoadedGuideState extends GuideState {
  //Для информации ГУ
  final Guide guide;
  LoadedGuideState({@required this.guide});
}

//Для поиска улицы
class LoadedGuideStreetState extends GuideState {
  final List<GuideSearch> loadedguidestreet;
  LoadedGuideStreetState({
    @required this.loadedguidestreet,
  }) : assert(loadedguidestreet != null);
}

//Для поиска номера дома
class LoadedGuideStreetNumberState extends GuideState {
  final List<GuideStreetNumber> loadedguidestreetnumber;
  LoadedGuideStreetNumberState({@required this.loadedguidestreetnumber})
      : assert(loadedguidestreetnumber != null);
}

//Для поиска КСК
class LoadGuideFindKskState extends GuideState {
  final GuideFindKsk loadedguidefindksk;
  LoadGuideFindKskState({@required this.loadedguidefindksk})
      : assert(loadedguidefindksk != null);
}

//Для получения информации об аптеке
class LoadedGuidePharmacyState extends GuideState {
  final List<GuidePharmacy> loadedguidepharmacy;

  LoadedGuidePharmacyState({@required this.loadedguidepharmacy});
}

//Для поиска информации об аптеке при нажатии
class LoadGuideFindPharmacyState extends GuideState {
  final GuideFindPharmacy loadedguidefindpharmacy;
  LoadGuideFindPharmacyState({@required this.loadedguidefindpharmacy})
      : assert(loadedguidefindpharmacy != null);
}

//Для получения инфо об лифте
class LoadedGuideLiftState extends GuideState {
  final List<GuideLift> loadedguidelift;
  LoadedGuideLiftState({@required this.loadedguidelift})
      : assert(loadedguidelift != null);
}

//Для получения инфо о поликлинике
class LoadedGuideHospitalState extends GuideState {
  final List<GuideHospital> loadedguidehospital;
  LoadedGuideHospitalState({@required this.loadedguidehospital});
}

//Для поииска поликлиник при нажатии
class LoadedGuideFindHospitalState extends GuideState {
  final GuideFindHospital loadedguidefindhospital;
  LoadedGuideFindHospitalState({@required this.loadedguidefindhospital})
      : assert(loadedguidefindhospital != null);
}

//Для получения инфо об доп образованиях
class LoadedGuideAddEducationState extends GuideState {
  final List<GuideAddEducation> loadedguideaddeducation;
  LoadedGuideAddEducationState({@required this.loadedguideaddeducation})
      : assert(loadedguideaddeducation != null);
}

// Для получения инфо о школе
class LoadedGuideSchoolState extends GuideState {
  final List<GuideSchool> loadedguideschool;
  LoadedGuideSchoolState({@required this.loadedguideschool})
      : assert(loadedguideschool != null);
}

// Для поиска школы
class LoadedGuideFindSchoolState extends GuideState {
  final GuideFindSchool loadedguidefindschool;
  LoadedGuideFindSchoolState({@required this.loadedguidefindschool})
      : assert(loadedguidefindschool != null);
}

// При ошибке
class FailureGuideState extends GuideState {
  final String error;

  FailureGuideState(this.error);
}

//Для получения инфо детсад
class LoadedGuideKinderState extends GuideState {
  final List<GuideKindergarten> loadedguidekinder;
  LoadedGuideKinderState({@required this.loadedguidekinder});
}

//Для поииска детсад при нажатии

class LoadedGuideFindKinderState extends GuideState {
  final GuideFindKindergarten loadedguidefindkinder;
  LoadedGuideFindKinderState({@required this.loadedguidefindkinder});
}
