import 'package:citizens01/pages/Apply/ApiApplyServices/apply_repository.dart';
import 'package:citizens01/pages/Apply/bloc/apply_event.dart';
import 'package:citizens01/pages/Apply/bloc/apply_state.dart';
import 'package:citizens01/pages/Apply/models/apply_categories.dart';
import 'package:citizens01/pages/Apply/models/apply_images.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ApplyBloc extends Bloc<ApplyEvent, ApplyState> {
  ApplyRepository applyRepository = ApplyRepository();
  ApplyBloc() : super(InitialApplyState());

  @override
  //Для получения фотографии
  Stream<ApplyState> mapEventToState(ApplyEvent event) async* {
    print('EVENT $event');
    if (event is LoadImageEvent) {
      yield LoadingApplyState();
      try {
        final List<ApplyImages> _getApplyImages =
            await applyRepository.getApplyImagesProvider();
        yield LoadImageState(loadapplyimages: _getApplyImages);
      } catch (e) {
        print(e);
        yield FailureApplyState(e.toString());
      }
    }

    //Для получения категории
    if (event is LoadApplyCategories) {
      yield LoadingApplyState();
      try {
        final List<ApplyCategories> _getApplyCategories =
            await applyRepository.getApplyCategories(event.imageID);
        yield LoadCategoriesState(loadapplycategories: _getApplyCategories);
      } catch (e) {
        yield FailureApplyState(e.toString());
      }
    }

    if (event is SendRequestEvent) {
      yield LoadingApplyState();
      try {
        await applyRepository.getSendRequest(
            event.category,
            event.sub_category,
            event.address,
            event.description,
            event.agreement,
            event.group,
            event.image);
        yield RequestSendedApplyState();
      } catch (e) {
        yield FailureApplyState(e.toString());
      }
    }
  }
}

///
///
///
///Для карты

class MapControlBloc extends Bloc<MapControlEvent, MapControlState> {
  MapControlBloc() : super(InitialMapState());
  ApplyRepository _repository = ApplyRepository();

  @override
  Stream<MapControlState> mapEventToState(MapControlEvent event) async* {
    if (event is GetLocationName) {
      yield LoadingMapState();
      try {
        final name = await _repository.getLocationName(event.latLng);
        print("NAMEEEEEEE");
        print(name.substring(0, name.length - 54));
        print("$name");
        yield FetchedMapState(name.substring(0, name.length - 54));
      } catch (e) {}
    }
  }
}
