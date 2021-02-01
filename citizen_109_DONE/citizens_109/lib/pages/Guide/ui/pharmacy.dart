import 'package:citizens01/pages/Guide/bloc/guide_bloc.dart';
import 'package:citizens01/pages/Guide/bloc/guide_event.dart';
import 'package:citizens01/pages/Guide/bloc/guide_state.dart';
import 'package:citizens01/pages/Guide/models/guide_findPharmacy.dart';
import 'package:citizens01/pages/Guide/models/guide_pharmacy.dart';

import 'package:citizens01/pages/Language/bloc/language_bloc.dart';
import 'package:citizens01/pages/Language/model/language_guide_page.dart';
import 'package:citizens01/tablet&phone/device_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:url_launcher/url_launcher.dart';

class PharmacyPage extends StatefulWidget {
  final PageController controller;

  const PharmacyPage({Key key, @required this.controller}) : super(key: key);
  @override
  _PharmacyPageState createState() => _PharmacyPageState();
}

class _PharmacyPageState extends State<PharmacyPage> {
  GuideBloc guideBloc;
  PageController get controller => widget.controller;
  LanguageGuidePage _language;
  String languageType;
  double width;
  String pharmacyName;
  String pharmacyAddress;
  List<GuidePharmacy> unsorted = [];
  List<GuidePharmacy> list = [];
  List<String> pharmNames = [];
  GuideFindPharmacy guideFindPharmacy;
  final _formKey = GlobalKey<FormState>();
  bool _btnEnabled = false;
  bool isShow = false;

  void initPharmNames() {
    for (var item in list) {
      if (!pharmNames.contains(item.name)) {
        pharmNames.add(item.name);
      }
    }
  }

  void updatePage() {
    setState(() {
      isShow = true;
    });
  }

  void sortPharms() {
    setState(() {
      unsorted = [];
      for (var item in list) {
        if (item.name == pharmacyName) {
          unsorted.add(item);
        }
      }
    });
  }

  void call(String phone) async {
    String url = 'tel:$phone';
    if (await canLaunch(url)) {
      await launch(url);
    }
  }

  double _addingSize = 0;
  void initState() {
    guideBloc = BlocProvider.of<GuideBloc>(context);
    final device = BlocProvider.of<DeviceBloc>(context).state;
    if (device.isTablet) _addingSize = 5;
    width = device.width;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LanguageBloc, LanguageState>(builder: (context, state) {
      if (state is FetchedLanguageState) {
        _language = state.language.languageGuidePage;
        languageType = state.type;
      }
      return BlocConsumer<GuideBloc, GuideState>(listener: (context, state) {
        if (state is LoadedGuidePharmacyState) {
          setState(() => list = state.loadedguidepharmacy);
          initPharmNames();
        }
        if (state is LoadGuideFindPharmacyState) {
          setState(() => guideFindPharmacy = state.loadedguidefindpharmacy);
          print(guideFindPharmacy.phone);
          updatePage();
        }
      }, builder: (context, state) {
        print('STATE for SEARCH $state');
        if (state is InitialGuideState) {
          return Center(
            child: Text("No data"),
          );
        }
        if (state is LoadingGuideState) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        return buildbody();
      });
    });
  }

  Widget buildbody() {
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
                buildTextFieldTitle(_language.chooseNamePharmacy),
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
                    isExpanded: true,
                    value: pharmacyName,
                    validator: (pharmacyName) {
                      if (pharmacyName == null) {
                        return "Ошибка";
                      }
                    },
                    style: TextStyle(
                      color: Theme.of(context).accentColor,
                      height: ScreenUtil().setHeight(6),
                    ),
                    onChanged: (String value) {
                      print('VALUE $value');
                      setState(() {
                        pharmacyName = value;
                        pharmacyAddress = null;
                      });
                      sortPharms();
                    },
                    items: pharmNames.map((item) {
                      return DropdownMenuItem(
                        value: item,
                        child: Text(
                          item,
                        ),
                      );
                    }).toList(),
                  ),
                ),
                Padding(padding: EdgeInsets.only(top: 10)),
                buildTextFieldTitle(_language.choosePharmacyAddress),
                Padding(padding: EdgeInsets.only(top: 10)),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                  decoration: BoxDecoration(
                    border: Border.all(color: Theme.of(context).accentColor),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: DropdownButtonFormField(
                    decoration: InputDecoration(
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                    ),
                    icon: Image.asset("images/vectordown.png",
                        height: ScreenUtil().setHeight(100)),
                    isExpanded: true,
                    value: pharmacyAddress,
                    validator: (pharmacyAddress) {
                      if (pharmacyAddress == null) {
                        return " ";
                      }
                    },
                    style: TextStyle(
                      color: Theme.of(context).accentColor,
                      height: ScreenUtil().setHeight(6),
                    ),
                    onChanged: (value) {
                      setState(() {
                        pharmacyAddress = value;
                      });
                    },
                    items: unsorted.map((value) {
                      return DropdownMenuItem(
                        value: value.address,
                        child: Text(
                          value.address,
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
                    guideBloc.add(LoadGuideFindPharmacyEvent(
                        pharmacyName, pharmacyAddress));
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
    print(guideFindPharmacy.address);
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
                  buildTextFieldText(guideFindPharmacy.name)
                ]),
                TableRow(children: [
                  buildTextFieldText(_language.addressKsk),
                  buildTextFieldText(guideFindPharmacy.address)
                ]),
                TableRow(children: [
                  buildTextFieldText(_language.contact),
                  buildTextFieldText(guideFindPharmacy.contact)
                ]),
                TableRow(children: [
                  buildTextFieldText(_language.saleType),
                  buildTextFieldText(guideFindPharmacy.saleType)
                ]),
                TableRow(
                  children: [
                    buildTextFieldText(_language.phoneKsk),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        buildTextFieldText(guideFindPharmacy.phone),
                        FlatButton(
                          onPressed: () => call(guideFindPharmacy.phone),
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
          Padding(padding: EdgeInsets.all(15 + _addingSize)),
        ],
      ),
    );
  }

  Widget buildTitle() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            _language.nameApteka,
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
          fontSize: 12 + _addingSize),
    );
  }
}
