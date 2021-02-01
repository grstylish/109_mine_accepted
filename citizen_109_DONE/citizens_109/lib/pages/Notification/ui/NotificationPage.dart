import 'package:citizens01/pages/Language/bloc/language_bloc.dart';
import 'package:citizens01/pages/Language/model/language_notification_page.dart';
import 'package:citizens01/pages/Language/model/language_profile_page.dart';
import 'package:citizens01/pages/Notification/bloc/notification_bloc.dart';
import 'package:citizens01/pages/Notification/bloc/notification_event.dart';
import 'package:citizens01/pages/Notification/bloc/notification_state.dart';
import 'package:citizens01/pages/Notification/models/notification_news.dart';
import 'package:citizens01/tablet&phone/device_bloc.dart';
import 'package:citizens01/util/CustomAppBar.dart';
import 'package:citizens01/util/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hexcolor/hexcolor.dart';

class NotificationPage extends StatefulWidget {
  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  ScrollController _controller;
  double _addingSize = 0;
  double _addingAlign;
  List<LanguageNotificationPage> _language;
  LanguageProfilePage languageProfilePage;
  NotificationBloc notificationBloc;
  NotfActionBloc notfActionBloc;
  String languageType;

  @override
  void initState() {
    notificationBloc = NotificationBloc();
    notfActionBloc = NotfActionBloc();
    notfActionBloc.add(CheckNotfActionEvent());
    notificationBloc.add(LoadNotificationEvent());
    _controller = ScrollController();

    final device = BlocProvider.of<DeviceBloc>(context).state;
    if (device.isTablet) _addingSize = 5;
    _addingAlign =
        device.isTablet ? ScreenUtil().setSp(450) : ScreenUtil().setSp(150);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LanguageBloc, LanguageState>(builder: (context, state) {
      if (state is FetchedLanguageState) {
        _language = state.language.languageNotificationPage;
        languageProfilePage = state.language.languageProfilePage;
        languageType = state.type;
      }

      return Scaffold(
        appBar: buildAppBar(),
        body: buildbody(),
      );
    });
  }

  // Widget buildbody() {
  //   return DecoratedBox(
  //     decoration: BoxDecoration(
  //       image: DecorationImage(
  //           image: AssetImage("images/bg.png"), fit: BoxFit.cover),
  //     ),
  //     child: BlocProvider(
  //         create: (context) => notificationBloc, child: buildScrollView()),
  //   );
  // }
  Widget buildbody() {
    return BlocConsumer(
      cubit: notfActionBloc,
      listener: (context, state) {
        if (state is CheckedNotfActionState) {
          if (state.value == null) showAlert(context);
        }
      },
      builder: (context, state) {
        return BlocProvider(
          create: (context) => notificationBloc,
          child: buildScrollView(),
        );
      },
    );
  }

  void showAlert(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text(languageProfilePage.receivenatification),
          actions: <Widget>[
            FlatButton(
              child: Text(
                languageProfilePage.yes,
                style: Theme.of(context).textTheme.caption.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Colors.blue,
                    fontSize: 18),
              ),
              onPressed: () {
                // notificationBloc.add(LoadSendAgreementEvent());
                notfActionBloc.add(ConfigNotfActionEvent(true));
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text(
                languageProfilePage.no,
                style: Theme.of(context).textTheme.caption.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Colors.blue,
                    fontSize: 18),
              ),
              onPressed: () {
                // notificationBloc.add(LoadSendRejectEvent());
                notfActionBloc.add(ConfigNotfActionEvent(false));
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget buildScrollView() {
    return BlocBuilder<NotificationBloc, NotificationState>(
      builder: (context, state) {
        if (state is InitialNotificationState) {
          return Center(
            child: Text("No data received"),
          );
        }
        if (state is LoadingNotificationState) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        if (state is FailureNotificationState) {
          FlushbarManager(context, message: state.error).show();
        }
        if (state is LoadedNotificationState) {
          return buildAppScrollView(state.loadnotificationnews);
        }
        return Container();
      },
    );
  }

  buildAppScrollView(List<NotificationNews> list) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(top: 15),
        ),
        Center(
          child: Text(
            languageProfilePage.alertsnot,
            style: TextStyle(
                fontSize: ScreenUtil().setSp(55) + _addingSize,
                color: HexColor("#407296"),
                fontWeight: FontWeight.normal),
          ),
          // child: MaterialButton(
          //   minWidth: 0,
          //   onPressed: () {
          //     _controller.animateTo(_controller.offset + list.length,
          //         curve: Curves.linear, duration: Duration(milliseconds: 5));
          //   },
          //   // child: Image.asset(
          //   //   "images/v2.png",
          //   //   height: 25,
          //   //   alignment: Alignment.topCenter,
          //   // ),
          // ),
        ),
        Expanded(
            child: ListView.builder(
                controller: _controller,
                itemCount: list.length,
                itemBuilder: (context, index) {
                  return ListTile(
                      title: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 20),
                      ),
                      Text(
                        "${list[index].getFrom}"
                        "  -  "
                        "${list[index].getTo}",
                        style: TextStyle(
                            color: HexColor("#407296"),
                            fontWeight: FontWeight.bold,
                            fontSize: ScreenUtil().setSp(40) + _addingSize),
                        textAlign: TextAlign.center,
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 5),
                      ),
                      Text(
                        languageType == 'KZ'
                            ? list[index].lblkz
                            : list[index].lbl,
                        style: TextStyle(
                            color: HexColor("#4C8B0D"),
                            fontSize: ScreenUtil().setSp(38) + _addingSize),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ));
                })),

        Padding(
          padding: EdgeInsets.only(top: 15),
        ),

        // MaterialButton(
        //   minWidth: 0,
        //   onPressed: () {
        //     _controller.animateTo(_controller.offset - list.length,
        //         curve: Curves.linear, duration: Duration(milliseconds: 5));
        //   },
        //   child: Image.asset(
        //     "images/v1.png",
        //     height: 25,
        //     alignment: Alignment.topCenter,
        //   ),
        // ),
      ],
    );
  }

  // buildAppScrollView(List<NotificationNews> list) {
  //   return ListWheelScrollView.useDelegate(
  //     itemExtent: 150,

  //     diameterRatio: 1,
  //     // overAndUnderCenterOpacity: 0,
  //     renderChildrenOutsideViewport: true,
  //     clipBehavior: Clip.none,
  //     controller: _controller,
  //     // perspective: 0.010,

  //     // overAndUnderCenterOpacity: 0.50,
  //     physics: ClampingScrollPhysics(),
  //     childDelegate: ListWheelChildBuilderDelegate(
  //       childCount: list.length,
  //       builder: (context, index) => Container(
  //           padding: EdgeInsets.all(5),
  //           alignment: Alignment.center,
  //           color: Colors.white,
  //           child: Column(
  //             children: [
  //               Padding(
  //                 padding: EdgeInsets.only(top: 5),
  //               ),
  // Text(
  //   "${list[index].from}" "  -  " "${list[index].to}",
  //   style: TextStyle(
  //       color: HexColor("#407296"),
  //       fontWeight: FontWeight.bold,
  //       fontSize: ScreenUtil().setSp(40) + _addingSize),
  //   textAlign: TextAlign.center,
  // ),
  // Padding(
  //   padding: EdgeInsets.only(top: 5),
  // ),
  // Text(
  //   languageType == 'KZ' ? list[index].lblkz : list[index].lbl,
  //   style: TextStyle(
  //       color: HexColor("#4C8B0D"),
  //       fontSize: ScreenUtil().setSp(38) + _addingSize),
  //   textAlign: TextAlign.center,
  // ),
  //             ],
  //           )),
  //     ),
  //   );
  // }

  Widget buildAppBar() {
    return CustomAppBar(
        leading: Container(
            child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: <Widget>[
            Image.asset(
              "images/logo.png",
              height: ScreenUtil().setSp(80) + _addingSize,
              width: ScreenUtil().setSp(80) + _addingSize,
            ),
            Padding(padding: EdgeInsets.only(left: 5)),
            Image.asset(
              "images/logo12.png",
              height: ScreenUtil().setSp(80) + _addingSize,
              width: ScreenUtil().setSp(80) + _addingSize,
            )
          ],
        ),
        Container(
          padding: EdgeInsets.only(right: _addingAlign),
          child: Center(
              child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Image.asset("images/109aktobe.png"),
            alignment: Alignment.bottomCenter,
          )),
        )
      ],
    )));
  }
}

// Widget buildScrollView() {
//   Padding(padding: EdgeInsets.all(10));
//   return ListWheelScrollView.useDelegate(
//     itemExtent: 100,

//     diameterRatio: 1.6,
//     // squeeze: 2.0,
//     renderChildrenOutsideViewport: true,
//     clipBehavior: Clip.none,

//     // useMagnifier: true,
//     // magnification: 1.1,
//     controller: _controller,
//     physics: ClampingScrollPhysics(),
//     childDelegate: ListWheelChildBuilderDelegate(
//       childCount: _language.length,
//       // newList.length,
//       builder: (context, index) => Container(
//           padding: EdgeInsets.all(10),
//           color: Colors.white,
//           child: Center(
//             child: Text(
//               "${_language[index].text}",
//               style: TextStyle(
//                   color: HexColor("#4C8B0D"),
//                   fontSize: ScreenUtil().setSp(40) + _addingSize),
//               textAlign: TextAlign.center,
//             ),
//           )),
//     ),
//   );
// }
