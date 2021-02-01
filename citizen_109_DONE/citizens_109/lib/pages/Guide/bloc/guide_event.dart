import 'package:equatable/equatable.dart';

abstract class GuideEvent extends Equatable {
  const GuideEvent();
  @override
  List<Object> get props => [];
}

//Для получения image
class LoadImageEvent extends GuideEvent {}

//Для информации ГУ
class LoadGuideEvent extends GuideEvent {}

//Для поиска улицы
class LoadGuideStreetEvent extends GuideEvent {}

//Для поиска номера дома
class LoadGuideStreetNumberEvent extends GuideEvent {
  final String street;
  LoadGuideStreetNumberEvent(this.street);
}

//Для поиска КСК
class LoadGuideFindKskEvent extends GuideEvent {
  final String name;
  final String house;
  LoadGuideFindKskEvent(this.name, this.house);
}

//Для получения информации об аптеке
class LoadGuidePharmacyEvent extends GuideEvent {}

//Для поиска нформации об аптеке
class LoadGuideFindPharmacyEvent extends GuideEvent {
  final String name;
  final String address;

  LoadGuideFindPharmacyEvent(this.name, this.address);
}

//Для получения информации о поликлиниках
class LoadGuideHospitalEvent extends GuideEvent {}

//Для Для поиска нформации о поликлинике
class LoadGuideFindHospitalEvent extends GuideEvent {
  final String name;

  LoadGuideFindHospitalEvent(this.name);
}

//Для лифта
class LoadGuideLiftEvent extends GuideEvent {}

//Для доп образования
class LoadGuideAddEducationEvent extends GuideEvent {}

//Для получения информации о школе
class LoadGuideSchoolEvent extends GuideEvent {}

//Для поиска школы
class LoadGuideFindSchoolEvent extends GuideEvent {
  final String name;
  LoadGuideFindSchoolEvent(this.name);
}

//Для получения информации о детсад

class LoadGuideKinderEvent extends GuideEvent {}

//Для поиск детсад
class LoadGuideFindKinderEvent extends GuideEvent {
  final String name;
  LoadGuideFindKinderEvent(this.name);
}
