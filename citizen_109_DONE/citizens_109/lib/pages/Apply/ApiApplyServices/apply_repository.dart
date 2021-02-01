import 'package:citizens01/pages/Apply/ApiApplyServices/apply_provider.dart';
import 'package:citizens01/pages/Apply/models/apply_categories.dart';
import 'package:citizens01/pages/Apply/models/apply_images.dart';
import 'package:citizens01/pages/Authentication/ApiServices/api_repository.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:latlong/latlong.dart';

class ApplyRepository {
  final ApplyProvider applyProvider = ApplyProvider();
  FlutterSecureStorage storage = FlutterSecureStorage();
  final ApiRepository _apiRepository = ApiRepository();

  Future<String> getLocationName(LatLng latLng) async {
    return await applyProvider.getLocationName(latLng);
  }

  Future<List<ApplyImages>> getApplyImagesProvider() async {
    return await applyProvider.getApplyImages();
  }

  Future<List<ApplyCategories>> getApplyCategories(int imageID) async {
    return await applyProvider.getApplyCategories(imageID);
  }

  Future<void> getSendRequest(category, sub_category, address, description,
      agreement, group, images) async {
    // String accToken = await storage.read(key: 'access_token');
    // print('ACCTKN =>>>>> $accToken');

    final profile = await _apiRepository.getProfileInformation();
    await applyProvider.getSendRequest(
      category,
      sub_category,
      address,
      description,
      profile.lastname,
      profile.username,
      profile.phone,
      agreement,
      group,
      images,
    );
  }
}
