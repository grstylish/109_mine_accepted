import 'package:citizens01/pages/Guide/bloc/guide_bloc.dart';
import 'package:citizens01/pages/Guide/bloc/guide_event.dart';
import 'package:citizens01/pages/Guide/bloc/guide_state.dart';
import 'package:citizens01/pages/Guide/models/guide_findSchool.dart';
import 'package:citizens01/pages/Guide/models/guide_school.dart';
import 'package:citizens01/pages/Language/bloc/language_bloc.dart';
import 'package:citizens01/pages/Language/model/language_guide_page.dart';
import 'package:citizens01/tablet&phone/device_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:url_launcher/url_launcher.dart';

class SchoolPage extends StatefulWidget {
  final PageController controller;

  const SchoolPage({Key key, @required this.controller}) : super(key: key);
  @override
  _SchoolPageState createState() => _SchoolPageState();
}

class _SchoolPageState extends State<SchoolPage> {
  PageController get controller => widget.controller;
  LanguageGuidePage _language;
  double _addingSize = 0;
  double width;
  bool isShow = false;
  GuideBloc guideBloc;
  bool _btnEnabled = false;
  String schoolName;
  GuideFindSchool findSchool;
  List<GuideSchool> schoolNames = [];

  final _formKey = GlobalKey<FormState>();

  void initState() {
    guideBloc = BlocProvider.of<GuideBloc>(context);
    final device = BlocProvider.of<DeviceBloc>(context).state;
    if (device.isTablet) _addingSize = 5;
    width = device.width;

    super.initState();
  }

  void updatePage() {
    setState(() {
      isShow = true;
    });
  }

  void call(String phone) async {
    String url = 'tel:$phone';
    if (await canLaunch(url)) {
      await launch(url);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LanguageBloc, LanguageState>(builder: (context, state) {
      if (state is FetchedLanguageState) {
        _language = state.language.languageGuidePage;
      }
      return BlocConsumer<GuideBloc, GuideState>(listener: (context, state) {
        if (state is LoadedGuideSchoolState) {
          setState(() => schoolNames = state.loadedguideschool);
          print(schoolNames);
          print(state.loadedguideschool);
        }
        if (state is LoadedGuideFindSchoolState) {
          setState(() => findSchool = state.loadedguidefindschool);
          updatePage();
        }
      }, builder: (context, state) {
        print('STATE for SEARCH $state');
        if (state is InitialGuideState) {
          return Center(
            child: Text("Нет данных для выбора улицы"),
          );
        }
        if (state is LoadingGuideState) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        return buildBody();
      });
    });
  }

  Widget buildBody() {
    return SingleChildScrollView(
        child: Container(
      child: Form(
        key: _formKey,
        onChanged: () =>
            setState(() => _btnEnabled = _formKey.currentState.validate()),
        child: Column(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildChangePage1(),
                Padding(padding: EdgeInsets.only(top: 10)),
                buildTitle(),
                Padding(padding: EdgeInsets.only(top: 15)),
                buildTextFieldTitle(_language.chooseguideSchoolName),
                Padding(padding: EdgeInsets.only(top: 5)),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 7),
                  decoration: BoxDecoration(
                    border: Border.all(color: Theme.of(context).accentColor),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: DropdownButtonFormField(
                    decoration: InputDecoration(
                      enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white)),
                    ),
                    icon: Image.asset(
                      "images/vectordown.png",
                      height: ScreenUtil().setHeight(100),
                    ),
                    // underline: Container(),
                    isExpanded: true,
                    value: schoolName,
                    validator: (schoolName) {
                      if (schoolName == null) {
                        return "Выберите категорию";
                      }
                    },
                    style: TextStyle(
                      color: Theme.of(context).accentColor,
                      height: ScreenUtil().setHeight(6),
                    ),

                    onChanged: (String value) {
                      print('VALUE $value');
                      setState(() {
                        schoolName = value;
                      });
                    },
                    items: schoolNames.map((item) {
                      return DropdownMenuItem(
                        value: item.name,
                        child: Text(
                          item.name,
                        ),
                      );
                    }).toList(),
                  ),
                ),
                Padding(padding: EdgeInsets.only(top: 20)),
                buildButton(),
                Padding(padding: EdgeInsets.only(top: 20)),
                getInformation(),
              ],
            )
          ],
        ),
      ),
    ));
  }

  Widget buildButton() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ButtonTheme(
          minWidth: width,
          height: ScreenUtil().setHeight(150),
          child: RaisedButton(
            child: Text(_language.findPharmacy,
                style: TextStyle(
                    color: _btnEnabled ? Colors.white : HexColor("#999A9D"),
                    fontSize: ScreenUtil().setSp(50) + _addingSize)),
            onPressed: _btnEnabled
                ? () {
                    guideBloc.add(LoadGuideFindSchoolEvent(schoolName));
                  }
                : null,
            disabledColor: Colors.white,
            color: HexColor("#407296"),
            shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(5.0),
                side: BorderSide(
                    color: HexColor("#999A9D"),
                    width: ScreenUtil().setWidth(4))),
          ),
        ),
      ],
    );
  }

  Widget getInformation() {
    if (!isShow) return Column();
    print(findSchool.name);
    return Column(
      children: [
        Padding(padding: EdgeInsets.only(top: 20)),
        Column(
          children: [
            Container(
                child: Table(
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              columnWidths: {
                0: FlexColumnWidth(4),
                1: FlexColumnWidth(7),
              },
              children: [
                TableRow(children: [
                  buildTextFieldText(_language.nameGu),
                  buildTextFieldText(findSchool.name)
                ]),
                TableRow(children: [
                  buildTextFieldText(_language.addressKsk),
                  buildTextFieldText(findSchool.address)
                ]),
                TableRow(children: [
                  buildTextFieldText(_language.boss),
                  buildTextFieldText(findSchool.executive)
                ]),
                TableRow(children: [
                  buildTextFieldText("Email"),
                  buildTextFieldText(findSchool.email)
                ]),
                TableRow(
                  children: [
                    buildTextFieldText(_language.phoneKsk),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        buildTextFieldText(findSchool.phone),
                        FlatButton(
                          onPressed: () => call(findSchool.phone),
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              _language.call,
                              style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  color: Theme.of(context).accentColor,
                                  fontSize:
                                      ScreenUtil().setSp(38) + _addingSize),
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ],
            )),
          ],
        ),
      ],
    );
  }

  Widget buildChangePage1() {
    return Center(
      child: Row(
        children: [
          MaterialButton(
            minWidth: 0,
            onPressed: () {
              guideBloc.add(LoadImageEvent());
              controller.jumpToPage(0);
            },
            child: Image.asset(
              "images/Vector3.png",
              height: ScreenUtil().setHeight(90),
              alignment: Alignment.topLeft,
            ),
          ),
          Padding(padding: EdgeInsets.all(5 + _addingSize)),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              _language.changeDirectory,
              style: TextStyle(
                  fontSize: ScreenUtil().setSp(55) + _addingSize,
                  color: HexColor("#407296"),
                  fontWeight: FontWeight.normal),
            ),
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
          fontWeight: FontWeight.normal,
          fontSize: ScreenUtil().setSp(45) + _addingSize),
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

  Widget buildTitle() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            _language.guideSchool,
            style: TextStyle(
                fontSize: ScreenUtil().setSp(55) + _addingSize,
                color: HexColor("#407296"),
                fontWeight: FontWeight.normal),
          )
        ],
      ),
    );
  }
}
