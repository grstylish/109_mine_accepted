import 'package:citizens01/pages/Guide/bloc/guide_bloc.dart';
import 'package:citizens01/pages/Guide/bloc/guide_event.dart';
import 'package:citizens01/pages/Guide/bloc/guide_state.dart';
import 'package:citizens01/pages/Guide/models/guide_findksk.dart';
import 'package:citizens01/pages/Guide/models/guide_search.dart';
import 'package:citizens01/pages/Guide/models/guide_street.dart';
import 'package:citizens01/pages/Language/bloc/language_bloc.dart';
import 'package:citizens01/pages/Language/model/language_guide_page.dart';
import 'package:citizens01/tablet&phone/device_bloc.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:url_launcher/url_launcher.dart';

class SearchPage extends StatefulWidget {
  final PageController controller;

  const SearchPage({Key key, @required this.controller}) : super(key: key);
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String _StreetVal;
  String _StreetNumberVal;
  // String _FindVal;
  bool isShow = false;
  double _addingSize = 0;
  double width;
  GuideBloc guideBloc;
  List<GuideSearch> streetNames = [];
  List<GuideStreetNumber> streetNumbers = [];
  GuideFindKsk findKsk;
  PageController get controller => widget.controller;
  bool _btnEnabled = false;
  LanguageGuidePage _language;

  final _formKey = GlobalKey<FormState>();

  void updatePage() {
    setState(() {
      isShow = true;
    });
  }

  void initState() {
    guideBloc = BlocProvider.of<GuideBloc>(context);
    final device = BlocProvider.of<DeviceBloc>(context).state;
    if (device.isTablet) _addingSize = 5;
    width = device.width;

    super.initState();
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
      return BlocConsumer<GuideBloc, GuideState>(
        listener: (context, state) {
          if (state is LoadedGuideStreetNumberState) {
            setState(() => streetNumbers = state.loadedguidestreetnumber);
            print("HERRR $streetNumbers");
            print(state.loadedguidestreetnumber);
          }
          if (state is LoadedGuideStreetState) {
            setState(() => streetNames = state.loadedguidestreet);
          }
          if (state is LoadGuideFindKskState) {
            setState(() => findKsk = state.loadedguidefindksk);
            print(findKsk.name);
            print("STTTATTATTA ${state.loadedguidefindksk}");
            updatePage();
          }
          //////////////////////////////// Здесь ошибку не работает
          if (state is FailureGuideState) {
            Flushbar(
              padding: EdgeInsets.all(30),
              icon: Icon(
                Icons.check,
                color: Colors.greenAccent,
                size: 30,
              ),
              flushbarStyle: FlushbarStyle.FLOATING,
              flushbarPosition: FlushbarPosition.BOTTOM,
              isDismissible: false,
              messageText: Text(
                "Повторите еще раз",
                style: TextStyle(
                  fontSize: 20,
                  fontStyle: FontStyle.normal,
                  color: Colors.white,
                ),
              ),
              duration: Duration(seconds: 3),
            );
          }
        },
        builder: (context, state) {
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
        },
      );
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
                buildTextFieldTitle(_language.chooseStreet),
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
                    value: _StreetVal,
                    validator: (_StreetVal) {
                      if (_StreetVal == null) {
                        return "Выберите категорию";
                      }
                    },
                    style: TextStyle(color: Theme.of(context).accentColor),
                    onChanged: (String value) {
                      print('VALUE $value');
                      setState(() {
                        _StreetVal = value;
                        _StreetNumberVal = null;
                      });
                      guideBloc.add(LoadGuideStreetNumberEvent(value));
                    },
                    items: streetNames.map((item) {
                      return DropdownMenuItem(
                        value: item.name,
                        child: Text(
                          item.name,
                        ),
                      );
                    }).toList(),
                  ),
                ),
                Padding(padding: EdgeInsets.only(top: 10)),
                buildTextFieldTitle(_language.chooseStreetNumber),
                Padding(padding: EdgeInsets.only(top: 10)),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                  decoration: BoxDecoration(
                    border: Border.all(color: Theme.of(context).accentColor),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: DropdownButtonFormField(
                    decoration: InputDecoration(
                      enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white)),
                    ),
                    icon: Image.asset("images/vectordown.png",
                        height: ScreenUtil().setHeight(100)),
                    // underline: Container(),
                    isExpanded: true,
                    value: _StreetNumberVal,
                    validator: (value) {
                      if (value == null) {
                        return "Выберите категорию";
                      }
                    },
                    style: TextStyle(color: Theme.of(context).accentColor),
                    onChanged: (value) {
                      setState(() {
                        _StreetNumberVal = value;
                      });
                    },
                    items: streetNumbers.map((value) {
                      return DropdownMenuItem(
                        value: value.number,
                        child: Text(
                          value.number,
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

  Widget buildButton() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ButtonTheme(
          minWidth: width,
          height: ScreenUtil().setHeight(150),
          child: RaisedButton(
            child: Text(_language.findKsk,
                style: TextStyle(
                    color: _btnEnabled ? Colors.white : HexColor("#999A9D"),
                    fontSize: ScreenUtil().setSp(50) + _addingSize)),
            onPressed: _btnEnabled
                ? () {
                    guideBloc.add(
                        LoadGuideFindKskEvent(_StreetVal, _StreetNumberVal));
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
    print(findKsk.name);
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
                  buildTextFieldText(_language.nameKsk),
                  buildTextFieldText(findKsk.name)
                ]),
                TableRow(children: [
                  buildTextFieldText(_language.addressKsk),
                  buildTextFieldText(findKsk.address)
                ]),
                TableRow(
                  children: [
                    buildTextFieldText(_language.phoneKsk),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        buildTextFieldText(findKsk.phone),
                        FlatButton(
                          onPressed: () => call(findKsk.phone),
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

  Widget buildTitle() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            _language.nameDirectoryKsk,
            style: TextStyle(
                fontSize: ScreenUtil().setSp(55) + _addingSize,
                color: HexColor("#407296"),
                fontWeight: FontWeight.normal),
          )
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
}
