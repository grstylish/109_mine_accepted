import 'package:citizens01/config.dart';
import 'package:citizens01/pages/Language/bloc/language_bloc.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FlushbarManager {
  final BuildContext context;
  String title;
  String message;

  FlushbarManager(
    this.context, {
    this.title = 'Ошибка',
    @required this.message,
  });

  void show() {
    double width = DEVICE_WIDTH;
    var shortestSide = MediaQuery.of(context).size.shortestSide;
    bool isTablet = shortestSide > 600;
    if (isTablet) width = TABLET_WIDTH;

    Flushbar(
      backgroundColor: Colors.red,
      flushbarPosition: FlushbarPosition.TOP,
      flushbarStyle: FlushbarStyle.FLOATING,
      forwardAnimationCurve: Curves.fastLinearToSlowEaseIn,
      reverseAnimationCurve: Curves.decelerate,
      isDismissible: true,
      dismissDirection: FlushbarDismissDirection.HORIZONTAL,
      duration: Duration(seconds: 3),
      maxWidth: ScreenUtil().setWidth(width * 0.9),
      // margin: EdgeInsets.symmetric(
      //   horizontal: ScreenUtil().setWidth(DEVICE_WIDTH * 0.05),
      // ),
      borderRadius: ScreenUtil().setSp(20),
      // title: title,
      titleText: BlocBuilder<LanguageBloc, LanguageState>(
        builder: (context, state) {
          if (state is FetchedLanguageState && title == 'Ошибка') {
            title = state.language.languageAuthPage.error;
          }
          return Text(
            title,
            style: TextStyle(
              fontSize: ScreenUtil().setSp(isTablet ? 42 : 38),
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          );
        },
      ),
      messageText: Text(
        message,
        style: TextStyle(
          fontSize: ScreenUtil().setSp(isTablet ? 40 : 35),
          color: Colors.white,
          letterSpacing: -0.2,
        ),
      ),
    )..show(context);
  }
}
