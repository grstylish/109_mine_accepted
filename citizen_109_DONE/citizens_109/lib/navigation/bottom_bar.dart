import 'dart:io';

import 'package:citizens01/config.dart';
import 'package:citizens01/pages/Apply/ui/ApplyPage.dart';
import 'package:citizens01/pages/Guide/GuidePage.dart';
import 'package:citizens01/pages/Notification/ui/NotificationPage.dart';
import 'package:citizens01/pages/Profile/bloc/profile_bloc.dart';
import 'package:citizens01/pages/Profile/ui/ProfilePage.dart';
import 'package:citizens01/pages/Trace/TracePage.dart';
import 'package:citizens01/tablet&phone/device_bloc.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hexcolor/hexcolor.dart';

class BottomBar extends StatefulWidget {
  @override
  _BottomVarState createState() => _BottomVarState();
}

class _BottomVarState extends State<BottomBar> {
  DeviceBloc deviceBloc;
  bool isTablet = false;
  double _addingSize = 0;
  var width = DEVICE_WIDTH;
  var height = DEVICE_HEIGHT;
  ProfileBloc profileBloc;
  FlutterSecureStorage storage = FlutterSecureStorage();

  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  @override
  void initState() {
    deviceBloc = BlocProvider.of<DeviceBloc>(context);
    profileBloc = ProfileBloc();
    show(context);
    super.initState();
  }

  show(BuildContext context) {
    _firebaseMessaging.configure(
      // onBackgroundMessage: onBackgroundMessage,
      //foreground
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text(
                  message['notification']['title'],
                  style: TextStyle(
                      fontSize: ScreenUtil().setSp(55),
                      fontWeight: FontWeight.bold),
                ),
                content: Text(message['notification']['body'],
                    style: TextStyle(fontSize: ScreenUtil().setSp(45))),
                actions: [
                  FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      setState(() => currentPage = 3);
                    },
                    child: Container(
                      color: Theme.of(context).accentColor,
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Text('ok',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: ScreenUtil().setSp(35))),
                      ),
                    ),
                  ),
                ],
              );
            });
      },
      //back
      onResume: (Map<String, dynamic> message) async {
        print('RESUME');
        setState(() => currentPage = 3);
      },
      onLaunch: (Map<String, dynamic> message) async {
        print('onLaunch');
      },
    );
    _firebaseMessaging.getToken().then((token) {
      print("HEEERREEE DEEEVVVIIICEEE TOKEN $token");
      if (token != null) {
        storage.write(key: 'token', value: token);
        print("Device TOKEN STORAGE: $token");
      }
    });
  }

  @override
  void dispose() {
    profileBloc.close();
    super.dispose();
  }

  int currentPage = 0;
  final pages = [
    NotificationPage(),
    GuidePage(),
    ApplyPage(),
    TracePage(),
    ProfilePage(),
  ];

  void onTappedBar(int index) {
    setState(() {
      currentPage = index;
    });
  }

  Widget build(BuildContext context) {
    var shortesSide = MediaQuery.of(context).size.shortestSide;
    if (shortesSide > 600) {
      width = TABLET_WIDTH;
      height = TABLET_HEIGHT;
      _addingSize = 10;
    }
    isTablet = shortesSide > 600;
    deviceBloc.add(
        FetchDeviceEvent(width: width, height: height, isTablet: isTablet));

    return GestureDetector(
      onTap: () {
        FocusScopeNode focus = FocusScope.of(context);
        if (!focus.hasPrimaryFocus) focus.unfocus();
      },
      child: Scaffold(
        body: BlocProvider(
          create: (context) => profileBloc,
          child: pages[currentPage],
        ),
        bottomNavigationBar: Container(
          // + 40 iphone height bottom bar
          height: kBottomNavigationBarHeight + (Platform.isIOS ? 40 : 0),
          decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [HexColor("#4CADC7").withOpacity(0.8), Colors.white],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                stops: [0, 0.85]),
            border: Border(
              top: BorderSide(
                  color: Theme.of(context).accentColor.withOpacity(0.3),
                  width: 1),
            ),
          ),
          child: Row(children: barItems),
        ),
      ),
    );
  }

  List<Widget> get barItems {
    return [
      buildBarItem(index: 0, image: 'bell.png'),
      buildBarItem(index: 1, image: 'agenda.png'),
      buildBarItem(index: 2, image: 'submitreq.png'),
      buildBarItem(index: 3, image: 'track.png'),
      buildBarItem(index: 4, image: 'user.png'),
    ];
  }

  Widget buildBarItem({@required int index, @required String image}) {
    return Expanded(
        child: AnimatedContainer(
            duration: Duration(milliseconds: 200),
            alignment: Alignment.center,
            child: FlatButton(
              onPressed: () => onTappedBar(index),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _buildImage(image, index),
                ],
              ),
            )));
  }

// Colors.limeAccent[50];
// Theme.of(context).accentColor
  Widget _buildImage(String image, int index) {
    Color color = HexColor("407296");
    if (currentPage != index) color = HexColor("7BA0BA");
    return AnimatedContainer(
      duration: Duration(milliseconds: 50),
      child: Image.asset(
        'images/$image',
        color: color,
        height: ScreenUtil().setHeight(Platform.isIOS ? 80 : 100) + _addingSize,
      ),
    );
  }
}
