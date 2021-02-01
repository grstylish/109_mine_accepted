import 'package:citizens01/pages/AuthApp/AuthAppBloc/authapp_bloc.dart';
import 'package:citizens01/pages/AuthApp/AuthAppBloc/authapp_event.dart';
import 'package:citizens01/pages/Language/bloc/language_bloc.dart';
import 'package:citizens01/pages/Language/model/language_profile_page.dart';
import 'package:citizens01/pages/Notification/bloc/notification_bloc.dart';
import 'package:citizens01/pages/Notification/bloc/notification_event.dart';
import 'package:citizens01/pages/Notification/bloc/notification_state.dart';
import 'package:citizens01/pages/Profile/bloc/profile_bloc.dart';
import 'package:citizens01/pages/Profile/bloc/profile_event.dart';
import 'package:citizens01/pages/Profile/bloc/profile_state.dart';
import 'package:citizens01/pages/Profile/models/profile_information.dart';
import 'package:citizens01/pages/Profile/ui/widgets/update_email.dart';
import 'package:citizens01/pages/Profile/ui/widgets/update_names.dart';
import 'package:citizens01/tablet&phone/device_bloc.dart';
import 'package:citizens01/util/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hexcolor/hexcolor.dart';

class BuildPageForm extends StatefulWidget {
  @override
  _BuildPageFormState createState() => _BuildPageFormState();
}

class _BuildPageFormState extends State<BuildPageForm> {
  double _addingSize = 0;
  double width;
  ProfileInformation profileInformation;
  ProfileBloc profileBloc;
  LanguageProfilePage _language;
  NotfActionBloc notfActionBloc;
  bool _hasBeenPressed2 = false;
  AuthAppBloc authBloc;

  @override
  void initState() {
    authBloc = BlocProvider.of<AuthAppBloc>(context);
    notfActionBloc = NotfActionBloc();
    notfActionBloc.add(CheckNotfActionEvent());
    profileBloc = BlocProvider.of<ProfileBloc>(context);
    profileBloc.add(LoadProfileEvent());
    final device = BlocProvider.of<DeviceBloc>(context).state;
    if (device.isTablet) _addingSize = 5;
    width = device.width;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LanguageBloc, LanguageState>(
      builder: (context, state) {
        if (state is FetchedLanguageState)
          _language = state.language.languageProfilePage;
        return BlocListener(
          cubit: notfActionBloc,
          listener: (context, state) {
            if (state is CheckedNotfActionState) {
              if (state.value != null)
                setState(() => _hasBeenPressed2 = !state.value);
            }
          },
          child: BlocBuilder<ProfileBloc, ProfileState>(
            builder: (context, state) {
              print('STATE FOR INFORMATION ');
              if (state is InitialProfileState) {
                return Center(
                  child: Text("No data received"),
                );
              }
              if (state is LoadingProfileState) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (state is LoadProfileState) {
                profileInformation = state.loadedprofileinformation;
                return buildBody();
              }
              if (state is FailureProfileState) {
                FlushbarManager(context, message: state.error).show();
              }
              return Container();
            },
          ),
        );
      },
    );
  }

  Widget buildBody() {
    return Column(
      children: [
        Padding(padding: EdgeInsets.all(10)),
        Container(
          child: Table(
            // defaultVerticalAlignment: TableCellVerticalAlignment.baseline,
            columnWidths: {
              0: FlexColumnWidth(2),
              1: FlexColumnWidth(4),
            },
            children: [
              TableRow(children: [
                buildTextFieldText(_language.firstName),
                buildTextFieldText(profileInformation.username),
              ]),
            ],
          ),
        ),
        Container(
          alignment: Alignment.centerRight,
          child: FlatButton(
              onPressed: () {
                Navigator.push(context,
                        MaterialPageRoute(builder: (context) => UpdateNames()))
                    .then((value) => profileBloc.add(LoadProfileEvent()));
              },
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  _language.change,
                  style: TextStyle(
                      fontWeight: FontWeight.normal,
                      color: Theme.of(context).accentColor,
                      fontSize: ScreenUtil().setSp(40) + _addingSize),
                ),
              )),
        ),
        Container(
          child: Table(
            // defaultVerticalAlignment: TableCellVerticalAlignment.baseline,
            columnWidths: {
              0: FlexColumnWidth(2),
              1: FlexColumnWidth(4),
            },
            children: [
              TableRow(
                children: [
                  buildTextFieldText(_language.lastName),
                  buildTextFieldText(profileInformation.lastname)
                ],
              ),
            ],
          ),
        ),
        Divider(
          color: Theme.of(context).accentColor,
          height: 30,
          thickness: 1,
          indent: 20,
          endIndent: 20,
        ),
        Container(
          child: Table(
            // defaultVerticalAlignment: TableCellVerticalAlignment.baseline,
            columnWidths: {
              0: FlexColumnWidth(2),
              1: FlexColumnWidth(4),
            },
            children: [
              TableRow(children: [
                buildTextFieldText("Email"),
                buildTextFieldText(profileInformation.email),
              ]),
            ],
          ),
        ),
        Container(
          alignment: Alignment.centerRight,
          child: FlatButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => UpdateEmail()),
              ).then((value) => profileBloc.add(LoadProfileEvent()));
            },
            child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  _language.change,
                  style: TextStyle(
                      fontWeight: FontWeight.normal,
                      color: Theme.of(context).accentColor,
                      fontSize: ScreenUtil().setSp(40) + _addingSize),
                )),
          ),
        ),
        Container(
          child: Table(
            // defaultVerticalAlignment: TableCellVerticalAlignment.baseline,
            columnWidths: {
              0: FlexColumnWidth(2),
              1: FlexColumnWidth(4),
            },
            children: [
              TableRow(
                children: [
                  buildTextFieldText(_language.phoneNumber),
                  buildTextFieldText(profileInformation.phone)
                ],
              ),
            ],
          ),
        ),
        Divider(
          color: Theme.of(context).accentColor,
          height: 30,
          thickness: 1,
          indent: 20,
          endIndent: 20,
        ),
        Container(
          child: Table(
            // defaultVerticalAlignment: TableCellVerticalAlignment.baseline,
            columnWidths: {
              0: FlexColumnWidth(1),
              1: FlexColumnWidth(1),
            },
            children: [
              TableRow(
                children: [
                  buildTextFieldText(_language.alerts),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          alignment: Alignment.centerRight,
                          child: FlatButton(
                            onPressed: () {
                              notfActionBloc
                                  .add(ConfigNotfActionEvent(_hasBeenPressed2));
                              setState(() {
                                _hasBeenPressed2 = !_hasBeenPressed2;
                              });
                            },
                            child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  _hasBeenPressed2
                                      ? _language.turnOn
                                      : _language.turnOff,
                                  style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    color: Theme.of(context).accentColor,
                                    fontSize:
                                        ScreenUtil().setSp(40) + _addingSize,
                                  ),
                                )),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        Divider(
          color: Theme.of(context).accentColor,
          height: 30,
          thickness: 1,
          indent: 20,
          endIndent: 20,
        ),
        Container(
          child: Table(
            columnWidths: {
              0: FlexColumnWidth(1),
              1: FlexColumnWidth(1),
            },
            children: [
              TableRow(
                children: [
                  buildTextFieldText(""),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          alignment: Alignment.centerRight,
                          child: FlatButton(
                            onPressed: () {
                              authBloc.add(LogoutAuthEvent());
                            },
                            child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  _language.logout,
                                  style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    color: Theme.of(context).accentColor,
                                    fontSize:
                                        ScreenUtil().setSp(40) + _addingSize,
                                  ),
                                )),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildTextFieldText(String text) {
    return Text(
      text,
      style: TextStyle(
          color: HexColor("#407296"),
          fontWeight: FontWeight.normal,
          fontSize: ScreenUtil().setSp(35) + _addingSize),
    );
  }
}
