import 'package:citizens01/pages/Profile/ApiProfileServices/profile_repository.dart';
import 'package:citizens01/pages/Profile/bloc/profile_event.dart';
import 'package:citizens01/pages/Profile/bloc/profile_state.dart';
import 'package:citizens01/pages/Profile/models/profile_information.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileRepository profileRepository = ProfileRepository();
  ProfileBloc() : super(InitialProfileState());

  FlutterSecureStorage storage = FlutterSecureStorage();

  @override
  Stream<ProfileState> mapEventToState(ProfileEvent event) async* {
    print("event $event");
    if (event is LoadProfileEvent) {
      yield LoadingProfileState();
      try {
        ProfileInformation _profileinformation =
            await profileRepository.getProfileInformationProvider();
        yield LoadProfileState(loadedprofileinformation: _profileinformation);
      } catch (e) {
        print(e);
        yield FailureProfileState(e.toString());
      }
    }

    if (event is LoadUpdateProfileEvent) {
      print('Profile');
      yield LoadingProfileState();
      try {
        await profileRepository.getUpdateProfileProvider(
            event.username, event.lastname);
        yield RequestSendedProfileState();
        // add(LoadProfileEvent());
      } catch (e) {
        print("Try Error: $e");
        yield FailureProfileState(e.toString());
      }
    }

    if (event is LoadUpdateEmailEvent) {
      print("Email Event");
      yield LoadingProfileState();
      try {
        await profileRepository.getUpdateEmailProvider(event.email);
        yield RequestSendedProfileState();
      } catch (e) {
        print("Try Error: $e");
        yield FailureProfileState(e.toString());
      }
    }
  }
}
