import 'package:citizens01/config.dart';
import 'package:citizens01/navigation/bottom_bar.dart';
import 'package:citizens01/pages/AuthApp/AuthAppBloc/authapp_bloc.dart';
import 'package:citizens01/pages/AuthApp/AuthAppBloc/authapp_event.dart';
import 'package:citizens01/pages/AuthApp/AuthAppBloc/authapp_state.dart';

import 'package:citizens01/pages/Authentication/ui/auth.dart';

import 'package:citizens01/pages/Language/bloc/language_bloc.dart';
import 'package:citizens01/tablet&phone/device_bloc.dart';
import 'package:citizens01/util/error_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hexcolor/hexcolor.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(MyApp());
}

ThemeData THEME = ThemeData(accentColor: HexColor("#4CADC7"));

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  DeviceBloc deviceBloc;
  AuthAppBloc authAppBloc;
  LanguageBloc languageBloc;

  @override
  void initState() {
    deviceBloc = DeviceBloc();
    authAppBloc = AuthAppBloc();
    authAppBloc.add(AppStartedAuthEvent());
    languageBloc = LanguageBloc();
    languageBloc.add(FetchLanguageEvent());
    super.initState();
  }

  @override
  void dispose() {
    deviceBloc.close();
    authAppBloc.close();
    languageBloc.close();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => languageBloc),
        BlocProvider(create: (context) => deviceBloc),
        BlocProvider(create: (context) => authAppBloc)
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        themeMode: ThemeMode.light,
        theme: THEME,
        home: BlocBuilder<AuthAppBloc, AuthAppState>(
          builder: (context, state) {
            print('STATE: $state');
            //
            if (state is UnauthAppState) return AuthenticationPage();
            // if (state is LoadingAuthState) return BottomBar();
            if (state is AuthenticatedAppState) return BottomBar();
            if (state is FailureAppAuthState) return ErrorPage(state.error);
            return EmptyApp();
          },
        ),
      ),
    );
  }
}

class EmptyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var shortestSide = MediaQuery.of(context).size.shortestSide;
    var width = DEVICE_WIDTH;
    var height = DEVICE_HEIGHT;
    if (shortestSide > 600) {
      width = TABLET_WIDTH;
      height = TABLET_HEIGHT;
    }

    ScreenUtil.init(context,
        width: width, height: height, allowFontScaling: true);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.light,
      theme: THEME,
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Container(
              padding: EdgeInsets.only(top: 250),
              child: Column(
                children: [
                  Image.asset("images/logo_new.png"),
                ],
              )),
        ),
      ),
    );
  }
}
