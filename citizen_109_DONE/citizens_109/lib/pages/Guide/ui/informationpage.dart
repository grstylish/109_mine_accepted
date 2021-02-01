import 'package:citizens01/pages/Guide/bloc/guide_bloc.dart';
import 'package:citizens01/pages/Guide/bloc/guide_event.dart';
import 'package:citizens01/pages/Guide/bloc/guide_state.dart';
import 'package:citizens01/pages/Guide/models/guide_information.dart';
import 'package:citizens01/pages/Language/bloc/language_bloc.dart';
import 'package:citizens01/pages/Language/model/language_guide_page.dart';
import 'package:citizens01/tablet&phone/device_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:url_launcher/url_launcher.dart';

class InformationBook extends StatefulWidget {
  final PageController controller;

  const InformationBook({Key key, @required this.controller}) : super(key: key);

  @override
  _InformationBookState createState() => _InformationBookState();
}

class _InformationBookState extends State<InformationBook> {
  GuideBloc guideBloc;
  PageController get controller => widget.controller;
  LanguageGuidePage _language;
  List<GuideInformation> list = [];
  String languageType;

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
    super.initState();
  }

  Widget build(BuildContext context) {
    return BlocBuilder<LanguageBloc, LanguageState>(builder: (context, state) {
      if (state is FetchedLanguageState) {
        _language = state.language.languageGuidePage;
        languageType = state.type;
      }
      return Column(children: [
        buildChangePage1(),
        buildText(),
        buildInformation(),
        Padding(padding: EdgeInsets.only(top: 20)),
      ]);
    });
  }

  Widget buildInformation() {
    return BlocBuilder<GuideBloc, GuideState>(builder: (context, state) {
      print('STATE FOR GU $state');
      if (state is InitialGuideState) {
        return Center(
          child: Text("No data received"),
        );
      }
      if (state is LoadingGuideState) {
        return Center(
          child: CircularProgressIndicator(),
        );
      }
      if (state is LoadedGuideState) {
        list = state.guide.rus;
        if (languageType == 'KZ') list = state.guide.kaz;
        return buildBody();
      }
      return Container();
    });
  }

  Widget buildBody() {
    List<Widget> children = [];
    for (int i = 0; i < list.length; i++) {
      for (int j = 0; j < list[i].executives.length; j++) {
        children.addAll([
          // buildChangePage1(),
          // buildText(),
          Padding(padding: EdgeInsets.only(top: 20)),
          Container(
            child: Table(
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              columnWidths: {
                0: FlexColumnWidth(2),
                1: FlexColumnWidth(3),
              },
              children: [
                TableRow(children: [
                  buildTextFieldText(_language.nameGu),
                  buildTextFieldText(list[i].name)
                ]),
                TableRow(children: [
                  buildTextFieldText(_language.boss),
                  buildTextFieldText(list[i].executives[j].fullName)
                ]),
                TableRow(children: [
                  buildTextFieldText(_language.addressKsk),
                  buildTextFieldText(list[i].executives[j].address)
                ]),
                TableRow(
                  children: [
                    buildTextFieldText(_language.phoneKsk),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        buildTextFieldText(list[i].executives[j].phone),
                        Padding(padding: EdgeInsets.only(left: 10)),
                        FlatButton(
                            onPressed: () => call(list[i].executives[j].phone),
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
                            )),
                      ],
                    )
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
        ]);
      }
    }
    return SingleChildScrollView(
      child: Column(children: children),
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

  Widget buildText() {
    return Column(
      children: [
        Padding(padding: EdgeInsets.only(top: 5)),
        Text(
          _language.nameDirectoryGu,
          style: TextStyle(
              fontSize: ScreenUtil().setSp(55) + _addingSize,
              color: HexColor("#407296"),
              fontWeight: FontWeight.normal),
        )
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
