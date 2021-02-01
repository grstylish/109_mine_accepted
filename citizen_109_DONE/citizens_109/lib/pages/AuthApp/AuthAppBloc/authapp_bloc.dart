import 'package:citizens01/pages/AuthApp/AuthApiServices/api_repository.dart';
import 'package:citizens01/pages/AuthApp/AuthAppBloc/authapp_event.dart';
import 'package:citizens01/pages/AuthApp/AuthAppBloc/authapp_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthAppBloc extends Bloc<AuthAppEvent, AuthAppState> {
  AuthAppBloc() : super(AuthAppInitialState());
  AuthAppRepository authAppRepository = AuthAppRepository();

  @override
  Stream<AuthAppState> mapEventToState(AuthAppEvent event) async* {
    if (event is AppStartedAuthEvent) {
      yield AuthAppInitialState();
      try {
        bool _loadToken = await authAppRepository.getAccessProvider();
        if (_loadToken) {
          String jwtToken = await authAppRepository.checkJwtToken();
          if (jwtToken != null) {
            yield AuthenticatedAppState();
          } else {
            yield UnauthAppState();
          }
        } else {
          yield LoadingAppAuthState();
        }

        print(_loadToken);
      } catch (e) {
        print("Try Error: $e");
      }
    }
    if (event is AuthenticateAuthAppEvent) {
      yield AuthenticatedAppState();
    }

    if (event is LogoutAuthEvent) {
      yield UnauthAppState();
      await authAppRepository.removeUser();
    }
  }
}
