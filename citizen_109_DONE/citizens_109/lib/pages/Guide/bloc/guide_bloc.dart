import 'package:citizens01/pages/Guide/ApiGuideServices/guide_repository.dart';
import 'package:citizens01/pages/Guide/bloc/guide_event.dart';
import 'package:citizens01/pages/Guide/bloc/guide_state.dart';
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
import 'package:flutter_bloc/flutter_bloc.dart';

class GuideBloc extends Bloc<GuideEvent, GuideState> {
  GuideRepository guideRepository = GuideRepository();
  GuideBloc() : super(InitialGuideState());

  @override
  Stream<GuideState> mapEventToState(GuideEvent event) async* {
    print('Bloc1 Testing LoadImageEvent');
    if (event is LoadImageEvent) {
      yield LoadingGuideState();
      try {
        print('Bloc Testing LoadImageEvent');
        final List<GuideImages> _guideImages =
            await guideRepository.getGuideImagesProvider();
        yield LoadedImageState(loadedapplyimages: _guideImages);
      } catch (e) {
        print(e);
        yield FailureGuideState(e.toString());
      }
    }

    // Справочник ГУ
    if (event is LoadGuideEvent) {
      print('TEST1 Bloc LoadGuideEvent');

      yield LoadingGuideState();
      try {
        print('TEST Bloc LoadGuideEvent');
        Guide _guideInformation =
            await guideRepository.getGuideInformationProvider();
        yield LoadedGuideState(guide: _guideInformation);
      } catch (e) {
        print(e);
        yield FailureGuideState(e.toString());
      }
    }
    // Для поиска улицы
    if (event is LoadGuideStreetEvent) {
      yield LoadingGuideState();
      try {
        print('TEST Bloc LoadGuideStreetEvent');
        final List<GuideSearch> _guidesearch =
            await guideRepository.getGuideSearchProvider();
        yield LoadedGuideStreetState(loadedguidestreet: _guidesearch);
      } catch (e) {
        print(e);
        yield FailureGuideState(e.toString());
      }
    }

    // Для поиска номера дома
    if (event is LoadGuideStreetNumberEvent) {
      yield LoadingGuideState();
      try {
        print("Testing Bloc LoadGuideStreerNumberEvent");
        final List<GuideStreetNumber> _guidestreetnumber =
            await guideRepository.getGuideStreetProvider(event.street);
        yield LoadedGuideStreetNumberState(
            loadedguidestreetnumber: _guidestreetnumber);
      } catch (e) {
        print(e);
        yield FailureGuideState(e.toString());
      }
    }

    //Для поиска КСК
    if (event is LoadGuideFindKskEvent) {
      yield LoadingGuideState();
      try {
        print("Testing LoadGuideFindKskEvent");
        final GuideFindKsk _guidefindksk = await guideRepository
            .getGuideFindKskProvider(event.name, event.house);
        yield LoadGuideFindKskState(loadedguidefindksk: _guidefindksk);
      } catch (e) {
        print(e);
        yield FailureGuideState(e.toString());
      }
    }

    //Для получения инфо об аптеках

    if (event is LoadGuidePharmacyEvent) {
      print("Testing1 LoadedGuidePharmacyState");

      yield LoadingGuideState();
      try {
        print("Testing LoadedGuidePharmacyState");
        final List<GuidePharmacy> _guidepharmacy =
            await guideRepository.getGuidePharmacyProvider();
        yield LoadedGuidePharmacyState(loadedguidepharmacy: _guidepharmacy);
      } catch (e) {
        print(e);
        yield FailureGuideState(e.toString());
      }
    }

    //Для получения инфо об аптеках при нажатии на кнопку

    if (event is LoadGuideFindPharmacyEvent) {
      print("TEST LoadGuideFindPharmacyEvent");
      yield LoadingGuideState();
      try {
        final GuideFindPharmacy _guidefindpharmacy = await guideRepository
            .getGuideFindPharmacyProvider(event.name, event.address);
        yield LoadGuideFindPharmacyState(
            loadedguidefindpharmacy: _guidefindpharmacy);
      } catch (e) {
        print(e);
        yield FailureGuideState(e.toString());
      }
    }

    //Для получения инфо об лифтах

    if (event is LoadGuideLiftEvent) {
      print("TEST LoadGuideLiftEvent");
      yield LoadingGuideState();
      try {
        final List<GuideLift> _getguideLift =
            await guideRepository.getGuideLiftProvider();
        yield LoadedGuideLiftState(loadedguidelift: _getguideLift);
      } catch (e) {
        print(e);
        yield FailureGuideState(e.toString());
      }
    }

    //Для получения инфо о поликлинике
    if (event is LoadGuideHospitalEvent) {
      print("TEST LoadGuideHospitalEvent");
      yield LoadingGuideState();
      try {
        final List<GuideHospital> _guidehospital =
            await guideRepository.getGuideHospitalProvider();
        yield LoadedGuideHospitalState(loadedguidehospital: _guidehospital);
      } catch (e) {
        print(e);
        yield FailureGuideState(e.toString());
      }
    }

//Для поиска поликлиники
    if (event is LoadGuideFindHospitalEvent) {
      print("LoadGuideFindHospitalEvent");
      yield LoadingGuideState();
      try {
        final GuideFindHospital _guidefindhospital =
            await guideRepository.getGuideFindHospitalProvider(event.name);
        yield LoadedGuideFindHospitalState(
            loadedguidefindhospital: _guidefindhospital);
      } catch (e) {
        print(e);
        yield FailureGuideState(e.toString());
      }
    }
//Для получения доп обучения
    if (event is LoadGuideAddEducationEvent) {
      print("LoadGuideAddEducationEvent");
      yield LoadingGuideState();
      try {
        final List<GuideAddEducation> _getGuideAddEducation =
            await guideRepository.getGuideAddEducationProvider();
        yield LoadedGuideAddEducationState(
            loadedguideaddeducation: _getGuideAddEducation);
      } catch (e) {
        print(e);
        yield FailureGuideState(e.toString());
      }
    }

    //Для получения инфо о школе
    if (event is LoadGuideSchoolEvent) {
      print("Testing1 LoadGuideSchoolEvent");
      yield LoadingGuideState();
      try {
        print("Testing1 LoadGuideSchoolEvent");
        final List<GuideSchool> _guideschool =
            await guideRepository.getGuideSchoolProvider();
        yield LoadedGuideSchoolState(loadedguideschool: _guideschool);
      } catch (e) {
        print(e);
        yield FailureGuideState(e.toString());
      }
    }

    //Для получения инфо о школе при нажатии на кнопку
    if (event is LoadGuideFindSchoolEvent) {
      print("TEST LoadGuideFindSchoolEvent");
      yield LoadingGuideState();

      try {
        final GuideFindSchool _guidefindschool =
            await guideRepository.getGuideFindSchoolProvider(event.name);
        yield LoadedGuideFindSchoolState(
            loadedguidefindschool: _guidefindschool);
      } catch (e) {
        print(e);
        yield FailureGuideState(e.toString());
      }
    }

    // Для получения инфо о детсад
    if (event is LoadGuideKinderEvent) {
      print("Testing1 LoadGuideKinderEvent");
      yield LoadingGuideState();
      try {
        final List<GuideKindergarten> _guidekinder =
            await guideRepository.getGuideKinderProvider();
        yield LoadedGuideKinderState(loadedguidekinder: _guidekinder);
      } catch (e) {
        print(e);
        yield FailureGuideState(e.toString());
      }
    }

    //  Для получения инфо о детсад при нажатии на кнопку
    if (event is LoadGuideFindKinderEvent) {
      print("TEST LoadGuideFindKinderEvent");
      yield LoadingGuideState();
      try {
        final GuideFindKindergarten _guidefindkinder =
            await guideRepository.getGuideFindKinderProvider(event.name);
        yield LoadedGuideFindKinderState(
            loadedguidefindkinder: _guidefindkinder);
      } catch (e) {
        print(e);
        yield FailureGuideState(e.toString());
      }
    }
  }
}
