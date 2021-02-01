import 'package:citizens01/pages/AuthApp/AuthAppBloc/authapp_bloc.dart';
import 'package:citizens01/pages/AuthApp/AuthAppBloc/authapp_event.dart';
import 'package:citizens01/pages/Authentication/ApiServices/api_repository.dart';
import 'package:citizens01/pages/Authentication/bloc/auth_event.dart';
import 'package:citizens01/pages/Authentication/bloc/auth_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthAppBloc authAppBloc;
  AuthBloc(this.authAppBloc) : super(AuthInitial());
  ApiRepository apiRepository = ApiRepository();

  @override
  Stream<AuthState> mapEventToState(AuthEvent event) async* {
    // if (event is AppLoadedEvent) {
    //   yield LoadingAuthState();
    //   try {
    //     bool _loadToken = await apiRepository.getAccessProvider();
    //     if (_loadToken) {
    //       String jwtToken = await apiRepository.checkJwtToken();

    //       if (jwtToken != null) {
    //         yield LoadedAuthState();
    //       } else {
    //         yield UnAuthState();
    //       }
    //     } else {
    //       yield LoadingAuthState();
    //     }

    //     print(_loadToken);
    //   } catch (e) {
    //     print("Try Error: $e");
    //   }
    // }
    if (event is GetCodeAuthEvent) {
      print('GetCodeAuthEvent');
      yield UnAuthState();
      try {
        await apiRepository.getStatusProvider(
            event.username, event.lastname, event.email, event.phone);
        yield UnAuthState();
      } catch (e) {
        print("Try Error: $e");
        yield FailureLoginState(e.toString());
      }
    }
    if (event is ConfirmCodeAuthEvent) {
      yield UnAuthState();
      try {
        bool _loadjwt = await apiRepository.getCodeProvider(event.code);
        yield LoadedAuthState();
        authAppBloc.add(AuthenticateAuthAppEvent());
        print(_loadjwt);
      } catch (e) {
        print("Try Error: $e");
        yield FailureLoginState(e.toString());
      }
    }
  }
}
