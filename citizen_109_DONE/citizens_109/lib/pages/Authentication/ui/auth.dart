import 'dart:async';
import 'package:citizens01/config.dart';
import 'package:citizens01/pages/AuthApp/AuthAppBloc/authapp_bloc.dart';
import 'package:citizens01/pages/Authentication/bloc/auth_bloc.dart';
import 'package:citizens01/pages/Authentication/bloc/auth_event.dart';
import 'package:citizens01/pages/Authentication/bloc/auth_state.dart';

import 'package:citizens01/pages/Language/bloc/language_bloc.dart';
import 'package:citizens01/pages/Language/model/language_auth_page.dart';
import 'package:citizens01/tablet&phone/device_bloc.dart';
import 'package:citizens01/util/CustomAppBar.dart';
import 'package:citizens01/util/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
// import 'package:sms/sms.dart';

class AuthenticationPage extends StatefulWidget {
  @override
  _AuthenticationPageState createState() => _AuthenticationPageState();
}

class _AuthenticationPageState extends State<AuthenticationPage> {
  TextEditingController phoneController = TextEditingController();
  TextEditingController codeContoller = TextEditingController();
  TextEditingController emailContoller = TextEditingController();
  TextEditingController usernameContoller = TextEditingController();
  TextEditingController lastnameContoller = TextEditingController();
  MaskTextInputFormatter phoneFormatter;
  MaskTextInputFormatter codeFormatter;
  bool isGetCode = false;
  bool isWaitCode = false;
  bool isLoading = false;
  // SmsReceiver receiver = SmsReceiver();
  LanguageAuthPage _language;

  DeviceBloc deviceBloc;
  AuthBloc authBloc;
  bool isShow = false;
  bool isTablet = false;
  double _addingSize = 0;
  var width = DEVICE_WIDTH;
  var height = DEVICE_HEIGHT;
  int _timecounter = 59;
  Timer _timer;
  bool _btnEnabled = false;

  @override
  void initState() {
    authBloc = AuthBloc(BlocProvider.of<AuthAppBloc>(context));
    deviceBloc = BlocProvider.of<DeviceBloc>(context);

    phoneFormatter = MaskTextInputFormatter(
        mask: '+7 (###) ### ####', filter: {"#": RegExp(r'[0-9]')});
    codeFormatter = MaskTextInputFormatter(
        mask: '### ###', filter: {"#": RegExp(r'[0-9]')});
    // startSMSListener();

    super.initState();
  }

  // void startSMSListener() {
  //   receiver.onSmsReceived.listen((SmsMessage message) async {
  //     if (message.sender == 'SMSC.KZ') {
  //       String code = message.body.split(' ').first;
  //       code = '${code.substring(0, 3)} ${code.substring(3)}';
  //       setState(() {
  //         codeContoller.text = code;
  //         codeFormatter = MaskTextInputFormatter(
  //             mask: '### ###',
  //             filter: {"#": RegExp(r'[0-9]')},
  //             initialText: code);
  //       });
  //       getCode();
  //       return;
  //     }
  //   });
  // }

  void getCode() {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
    String code = codeFormatter.getUnmaskedText();
    if (code.length != 6) {
      print("Неправильный код ");
      return;
    }
    authBloc.add(ConfirmCodeAuthEvent(code));
  }

  void _startTimer() {
    _timecounter = 59;
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (mounted && _timecounter > 0) {
          _timecounter--;
        } else {
          _timer.cancel();
        }
      });
    });
  }

  void updatePage() {
    String username = usernameContoller.text;
    String lastname = lastnameContoller.text;
    String email = emailContoller.text;
    String phone = '7' + phoneFormatter.getUnmaskedText();
    authBloc.add(GetCodeAuthEvent(username, lastname, email, phone));
    _startTimer();
    setState(() {
      isShow = true;
    });
  }

  @override
  void dispose() {
    phoneFormatter.clear();
    codeFormatter.clear();

    usernameContoller.dispose();
    lastnameContoller.dispose();
    emailContoller.dispose();
    phoneController.dispose();
    codeContoller.dispose();

    super.dispose();
  }

  final _formKey = GlobalKey<FormState>();

  String validateName(String value) {
    if (value.isEmpty) {
      return "Введите имя";
    } else if (value.length <= 1) {
      return 'Имя должно содержать более 1 символа';
    } else
      return null;
  }

  String validateSurname(String value) {
    print(value);
    if (value.isEmpty) {
      return "Введите фамилию";
    } else if (value.length <= 1) {
      return 'Фамилия должна содержать более 1 символа';
    } else
      return null;
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

  String validatePhone(String value) {
    if (value.length != 17) {
      return 'Введите номер телефона';
    } else
      return null;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LanguageBloc, LanguageState>(builder: (context, state) {
      if (state is FetchedLanguageState) {
        _language = state.language.languageAuthPage;
        var shortesSide = MediaQuery.of(context).size.shortestSide;
        if (shortesSide > 600) {
          width = TABLET_WIDTH;
          height = TABLET_HEIGHT;
          _addingSize = 5;
        }
        isTablet = shortesSide > 600;
        deviceBloc.add(
            FetchDeviceEvent(width: width, height: height, isTablet: isTablet));
        ScreenUtil.init(context,
            width: width, height: height, allowFontScaling: true);

        return BlocListener(
          cubit: authBloc,
          listener: (context, state) {
            if (state is FailureLoginState) {
              FlushbarManager(context, message: state.error).show();
            }
          },
          child: Form(
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
                      buildText(),
                      buildPageForm(),
                      Padding(padding: EdgeInsets.only(top: 20)),
                      buildPageButton(),
                      buildGetCode()
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      }
      return Container();
    });
  }

  Widget buildText() {
    return Column(
      children: [
        Text(
          _language.title1,
          style: TextStyle(
              fontSize: ScreenUtil().setSp(60) + _addingSize,
              color: HexColor("#407296"),
              fontWeight: FontWeight.bold),
        ),
        Text(_language.title2,
            style: TextStyle(
                fontSize: ScreenUtil().setSp(60) + _addingSize,
                color: HexColor("#407296"),
                fontWeight: FontWeight.bold)),
        Text(_language.title3,
            style: TextStyle(
                fontSize: ScreenUtil().setSp(60) + _addingSize,
                color: HexColor("#407296"),
                fontWeight: FontWeight.bold))
      ],
    );
  }

  Widget buildPageForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(padding: EdgeInsets.only(top: 20)),
        Text(
          _language.mustfield,
          style: TextStyle(
              fontSize: ScreenUtil().setSp(35) + _addingSize,
              color: Theme.of(context).accentColor),
          textAlign: TextAlign.start,
        ),
        Padding(padding: EdgeInsets.only(top: 10)),
        buildTextFieldTitle(_language.firstName),
        TextFormField(
          textCapitalization: TextCapitalization.sentences,
          autocorrect: true,
          validator: validateName,
          keyboardType: TextInputType.text,
          controller: usernameContoller,
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
        Padding(padding: EdgeInsets.only(top: 5)),
        buildTextFieldTitle(_language.lastName),
        TextFormField(
          textCapitalization: TextCapitalization.sentences,
          autocorrect: true,
          validator: validateSurname,
          keyboardType: TextInputType.text,
          controller: lastnameContoller,
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
        Padding(padding: EdgeInsets.only(top: 5)),
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
        Padding(padding: EdgeInsets.only(top: 5)),
        buildTextFieldTitle(_language.phoneNumber),
        Focus(
          child: TextFormField(
            validator: validatePhone,
            controller: phoneController,
            inputFormatters: [phoneFormatter],
            keyboardType: TextInputType.phone,
            style: TextStyle(color: HexColor("#407296")),
            decoration: InputDecoration(
              hintText: '+7 (- - -) - - -  - - - -',
              fillColor: Colors.white,
              filled: true,
              border: OutlineInputBorder(),
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Theme.of(context).accentColor)),
              contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            ),
          ),
        ),
      ],
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
              child: Text(_language.getCode,
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
                        updatePage();
                      }
                      if (_btnEnabled == true) {
                        setState(() => _btnEnabled = false);
                      }
                    }
                  : null,
              disabledColor: Colors.white,
              color: HexColor("#407296"),
            ),
          ),
        ),
        buildtimer(),
        FlatButton(
          onPressed: () {
            if (_formKey.currentState.validate()) {
              _formKey.currentState.save();
              updatePage();
            }
          },
          padding: EdgeInsets.only(right: 10.0),
          child: buildTextFieldTitle(_language.resend), //TextStyle
        ), //Text
      ],
    );
  }

  Widget buildtimer() {
    if (!isShow) return Column();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        (_timecounter > 0)
            ? Text(
                "${_language.timertext1} $_timecounter сек ${_language.timertext3} ",
                style: TextStyle(
                    color: Colors.red,
                    fontSize: ScreenUtil().setSp(45) + _addingSize),
              )
            : Text(_language.timertext2,
                style: TextStyle(
                    color: Colors.red,
                    fontSize: ScreenUtil().setSp(45) + _addingSize)),
      ],
    );
  }

  Widget buildGetCode() {
    if (!isShow) return Column();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      // Padding(padding: EdgeInsets.only(top: 30)),
      buildTextFieldTitle(_language.enterCode),
      TextField(
        controller: codeContoller,
        inputFormatters: [codeFormatter],
        style: TextStyle(color: HexColor("#407296")),
        decoration: InputDecoration(
          fillColor: Colors.white,
          hintText: '- - - - - -',
          filled: true,
          border: OutlineInputBorder(),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Theme.of(context).accentColor)),
          contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        ),
      ),
      Padding(padding: EdgeInsets.only(top: 30)),
      ButtonTheme(
        minWidth: isTablet
            ? ScreenUtil().setWidth(2000)
            : ScreenUtil().setWidth(1500),
        height: 50.0,
        child: RaisedButton(
          child: Text(_language.registration,
              style: TextStyle(
                  color: Colors.white, fontSize: ScreenUtil().setSp(50))),
          onPressed: () => getCode(),
          color: HexColor("#407296"),
          shape: RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(5.0),
              side: BorderSide(
                  color: HexColor("#407296"), width: ScreenUtil().setWidth(4))),
        ),
      )
    ]);
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
              height: ScreenUtil().setSp(60) + _addingSize,
              width: ScreenUtil().setSp(60) + _addingSize,
            ),
            Padding(padding: EdgeInsets.only(left: 5)),
            Image.asset(
              "images/logo12.png",
              height: ScreenUtil().setSp(60) + _addingSize,
              width: ScreenUtil().setSp(60) + _addingSize,
            )
          ],
        ),
        Container(
          padding: EdgeInsets.only(
              right:
                  isTablet ? ScreenUtil().setSp(450) : ScreenUtil().setSp(150)),
          child: Center(
              child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Image.asset("images/109aktobe.png"))),
        )
      ],
    )));
  }
}
