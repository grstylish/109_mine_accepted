import 'package:citizens01/pages/Authentication/ApiServices/api_repository.dart';
import 'package:citizens01/pages/Trace/ApiTraceServices/trace_provider.dart';
import 'package:citizens01/pages/Trace/models/active_tracename.dart';
import 'package:citizens01/pages/Trace/models/search_tracename.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TraceRepository {
  final TraceProvider traceProvider = TraceProvider();
  final ApiRepository apiRepository = ApiRepository();
  FlutterSecureStorage storage = FlutterSecureStorage();

  Future<List<ActiveTraceName>> getActiveTraceNameProvider() async {
    final getPhone = await apiRepository.getProfileInformation();
    return await traceProvider.getActiveTraceName(getPhone.phone);
  }

  Future<List<SearchTraceName>> getSearchNameProvider(
      String track_number) async {
    return await traceProvider.getSearchTraceName(track_number);
  }

  Future<void> getSendRequest(rating, comment, track_number) async {
    final profile = await apiRepository.getProfileInformation();
    await traceProvider.getSendRequest(
        profile.phone, profile.token, rating, comment, track_number);
  }
}
