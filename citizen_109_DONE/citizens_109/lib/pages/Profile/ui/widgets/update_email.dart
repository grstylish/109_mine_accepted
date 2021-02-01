import 'package:citizens01/config.dart';
import 'package:citizens01/pages/Language/bloc/language_bloc.dart';
import 'package:citizens01/pages/Language/model/language_profile_page.dart';
import 'package:citizens01/pages/Profile/bloc/profile_bloc.dart';
import 'package:citizens01/pages/Profile/bloc/profile_event.dart';
import 'package:citizens01/pages/Profile/bloc/profile_state.dart';
import 'package:citizens01/tablet&phone/device_bloc.dart';
import 'package:citizens01/util/flushbar.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hexcolor/hexcolor.dart';

class UpdateEmail extends StatefulWidget {
  const UpdateEmail({Key key}) : super(key: key);

  @override
  _UpdateEmailState createState() => _UpdateEmailState();
}

class _UpdateEmailState extends State<UpdateEmail> {
  var width = DEVICE_WIDTH;
  var height = DEVICE_HEIGHT;
  double _addingSize = 0;
  bool isTablet = false;
  DeviceBloc deviceBloc;
  bool _btnEnabled = false;
  ProfileBloc profileBloc;
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailContoller = TextEditingController();
  LanguageProfilePage _language;

  @override
  void initState() {
    deviceBloc = BlocProvider.of<DeviceBloc>(context);
    profileBloc = ProfileBloc();
    super.initState();
  }

  @override
  void dispose() {
    emailContoller.dispose();
    super.dispose();
  }

  void pop() async {
    await Future.delayed(Duration(seconds: 1));
    Navigator.pop(context);
  }

  String validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value)) {
      return 'Введите правильный адрес электронной почты';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LanguageBloc, LanguageState>(
      builder: (context, state) {
        if (state is FetchedLanguageState) {
          _language = state.language.languageProfilePage;
          return BlocListener(
            cubit: profileBloc,
            listener: (context, state) {
              if (state is RequestSendedProfileState) {
                flushbarText();
                pop();
              }
              if (state is FailureProfileState) {
                FlushbarManager(context, message: 'Ошибка').show();
              }
            },
            child: buildBody(),
          );
        }
        return Container();
      },
    );
  }

  Widget buildBody() {
    var shortesSide = MediaQuery.of(context).size.shortestSide;
    if (shortesSide > 600) {
      width = TABLET_WIDTH;
      height = TABLET_HEIGHT;
      _addingSize = 5;
    }
    isTablet = shortesSide > 600;
    deviceBloc.add(
        FetchDeviceEvent(width: width, height: height, isTablet: isTablet));

    return Scaffold(
        body: Form(
            key: _formKey,
            onChanged: () =>
                setState(() => _btnEnabled = _formKey.currentState.validate()),
            child: Scaffold(
              appBar: buildAppBar(),
              body: Container(
                padding: EdgeInsets.all(10),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      buildForm(),
                      Padding(padding: EdgeInsets.only(top: 20)),
                      buildPageButton(),
                    ],
                  ),
                ),
              ),
            )));
  }

  Widget buildForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 20),
        ),
        Text(
          _language.mustfield,
          style: TextStyle(
              fontSize: ScreenUtil().setSp(35) + _addingSize,
              color: Theme.of(context).accentColor),
          textAlign: TextAlign.start,
        ),
        Padding(padding: EdgeInsets.only(top: 10)),
        buildTextFieldTitle("Email * "),
        TextFormField(
          autocorrect: true,
          validator: validateEmail,
          keyboardType: TextInputType.emailAddress,
          controller: emailContoller,
          style: TextStyle(color: HexColor("#407296")),
          decoration: InputDecoration(
            fillColor: Colors.white,
            filled: true,
            border: OutlineInputBorder(),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Theme.of(context).accentColor)),
            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          ),
        ),
      ],
    );
  }

  Widget buildAppBar() {
    return AppBar(
      centerTitle: false,
      elevation: 1,
      backgroundColor: Colors.white,
      automaticallyImplyLeading: false,
      flexibleSpace: buildFlexibleSpace(context),
    );
  }

  Widget buildFlexibleSpace(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 30),
      child: buildBackButton(),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).accentColor.withOpacity(0.8),
            Colors.white
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: [0, 0.9],
        ),
        border: Border(
          bottom: BorderSide(
              color: Theme.of(context).accentColor.withOpacity(0.4), width: 1),
        ),
      ),
    );
  }

  Widget buildBackButton() {
    return Center(
      child: Row(
        children: [
          MaterialButton(
            minWidth: 0,
            onPressed: () {
              Navigator.pop(context);
            },
            child: Image.asset(
              "images/Vector3.png",
              height: ScreenUtil().setHeight(90) + _addingSize,
              alignment: Alignment.topLeft,
            ),
          ),
          Padding(padding: EdgeInsets.all(1 + _addingSize)),
          Text(
            _language.changeProfile,
            style: TextStyle(
                fontSize: ScreenUtil().setSp(55) + _addingSize,
                color: HexColor("#407296"),
                fontWeight: FontWeight.normal),
          ),
          Padding(padding: EdgeInsets.all(15)),
        ],
      ),
    );
  }

  Widget buildTextFieldTitle(String title) {
    return Text(
      title,
      style: TextStyle(
          color: HexColor("#407296"),
          fontWeight: FontWeight.bold,
          fontSize: ScreenUtil().setSp(45) + _addingSize),
    );
  }

  Widget buildPageButton() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(0.0),
          child: ButtonTheme(
            height: ScreenUtil().setHeight(150),
            minWidth: isTablet
                ? ScreenUtil().setWidth(2000)
                : ScreenUtil().setWidth(1500),
            child: RaisedButton(
              child: Text(_language.btncontinue,
                  style: TextStyle(
                      color: _btnEnabled ? Colors.white : Colors.grey,
                      fontSize: ScreenUtil().setSp(50))),
              shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(5.0),
                  side: BorderSide(
                      color: HexColor("#999A9D"),
                      width: ScreenUtil().setWidth(4))),
              onPressed: _btnEnabled
                  ? () {
                      if (_formKey.currentState.validate()) {
                        _formKey.currentState.save();
                        profileBloc.add(
                            LoadUpdateEmailEvent(email: emailContoller.text));
                      }
                    }
                  : null,
              disabledColor: Colors.white,
              color: HexColor("#407296"),
            ),
          ),
        ),
      ],
    );
  }

  void flushbarText() {
    Flushbar(
      padding: EdgeInsets.all(30),
      icon: Icon(
        Icons.check,
        color: Colors.greenAccent,
        size: ScreenUtil().setSp(80) + _addingSize,
      ),
      flushbarStyle: FlushbarStyle.FLOATING,
      flushbarPosition: FlushbarPosition.BOTTOM,
      isDismissible: false,
      messageText: Text(
        _language.saved,
        style: TextStyle(
          fontSize: ScreenUtil().setSp(40) + _addingSize,
          fontStyle: FontStyle.normal,
          color: Colors.white,
        ),
      ),
      duration: Duration(seconds: 1),
    )..show(context);
  }
}
