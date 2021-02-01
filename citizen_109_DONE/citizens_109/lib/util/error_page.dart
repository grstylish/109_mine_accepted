import 'package:citizens01/config.dart';
import 'package:citizens01/pages/AuthApp/AuthAppBloc/authapp_bloc.dart';
import 'package:citizens01/pages/AuthApp/AuthAppBloc/authapp_event.dart';

import 'package:citizens01/tablet&phone/device_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ErrorPage extends StatefulWidget {
  final int errorCode;
  const ErrorPage(this.errorCode);
  @override
  _ErrorPageState createState() => _ErrorPageState();
}

class _ErrorPageState extends State<ErrorPage> {
  int get errorCode => widget.errorCode;
  double _addingSize = 0;
  bool isTablet = false;
  // AuthBloc authBloc;
  AuthAppBloc authAppBloc;

  @override
  void initState() {
    authAppBloc = BlocProvider.of<AuthAppBloc>(context);
    final device = BlocProvider.of<DeviceBloc>(context).state;
    if (device.isTablet) _addingSize = 5;
    isTablet = device.isTablet;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            buildTitle(),
            buildText(),
            buildButton(),
          ],
        ),
      ),
    );
  }

  Widget buildButton() {
    if (errorCode == 500) return Container();
    return FlatButton(
      onPressed: () => authAppBloc.add(AppStartedAuthEvent()),
      color: Colors.grey.withOpacity(0.1),
      padding: EdgeInsets.symmetric(
        horizontal: ScreenUtil().setWidth(40),
        vertical: ScreenUtil().setHeight(10),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(ScreenUtil().setSp(10)),
      ),
      child: Text(
        'Попробуйте снова',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Theme.of(context).accentColor,
          fontSize: ScreenUtil().setSp(42),
          fontFamily: 'Kurale',
        ),
      ),
    );
  }

  Widget buildText() {
    String text =
        'Нет соединения с интернетом.'; // Проверьте соединение и попробуйте снова
    if (errorCode == 500)
      text = 'Произошла внутренняя ошибка сервера. Попробуйте позже';
    return Container(
      alignment: Alignment.center,
      width: ScreenUtil().setWidth(DEVICE_WIDTH),
      margin: EdgeInsets.symmetric(
        horizontal: ScreenUtil().setWidth(isTablet ? 100 : 20),
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Theme.of(context).accentColor,
          fontSize: ScreenUtil().setSp(42),
          fontFamily: 'Kurale',
        ),
      ),
    );
  }

  Widget buildTitle() {
    return Container(
      alignment: Alignment.center,
      child: Text(
        'Opps!',
        style: TextStyle(
          color: Theme.of(context).accentColor,
          fontSize: ScreenUtil().setSp(60),
          fontStyle: FontStyle.italic,
          fontFamily: 'Kurale',
        ),
      ),
    );
  }

  Widget buildAppBar() {
    return AppBar(
      centerTitle: true,
      elevation: 1,
      backgroundColor: Colors.white,
      flexibleSpace: buildFlexibleSpace(context),
      title: Stack(
        alignment: Alignment.bottomRight,
        children: [
          Text(
            'Актобе - 109',
            style: TextStyle(
              color: Theme.of(context).primaryColor.withOpacity(0.9),
              fontSize: ScreenUtil().setSp(25 + _addingSize),
              fontWeight: FontWeight.w600,
              fontFamily: 'Kurale',
            ),
          ),
        ],
      ),
    );
  }

  Widget buildFlexibleSpace(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).accentColor.withOpacity(0.8),
            Colors.white
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: [0, 0.8],
        ),
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).accentColor.withOpacity(0.3),
          ),
        ),
      ),
    );
  }
}
