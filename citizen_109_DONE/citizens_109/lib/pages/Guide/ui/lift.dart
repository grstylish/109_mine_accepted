import 'package:citizens01/pages/Guide/bloc/guide_bloc.dart';
import 'package:citizens01/pages/Guide/bloc/guide_event.dart';
import 'package:citizens01/pages/Guide/bloc/guide_state.dart';
import 'package:citizens01/pages/Guide/models/guide_lift.dart';
import 'package:citizens01/pages/Language/bloc/language_bloc.dart';
import 'package:citizens01/pages/Language/model/language_guide_page.dart';
import 'package:citizens01/tablet&phone/device_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:url_launcher/url_launcher.dart';

class LiftPage extends StatefulWidget {
  @override
  final PageController controller;

  const LiftPage({Key key, @required this.controller}) : super(key: key);
  _LiftPageState createState() => _LiftPageState();
}

class _LiftPageState extends State<LiftPage> {
  GuideBloc guideBloc;
  PageController get controller => widget.controller;
  LanguageGuidePage _language;
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

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LanguageBloc, LanguageState>(builder: (context, state) {
      if (state is FetchedLanguageState) {
        _language = state.language.languageGuidePage;
      }
      return Column(
        children: [
          buildChangePage1(),
          buildText(),
          buildLiftInformation(),
        ],
      );
    });
  }

  Widget buildLiftInformation() {
    return BlocBuilder<GuideBloc, GuideState>(builder: (context, state) {
      print("Pharmacy Information $state");
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
      if (state is LoadedGuideLiftState) {
        return buildLiftBody(state.loadedguidelift);
      }
      return Container();
    });
  }

  buildLiftBody(List<GuideLift> list) {
    List<Widget> children = [];
    print("HERE LIFT $list");
    for (var item in list) {
      children.addAll([
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
                buildTextFieldText(item.name)
              ]),
              TableRow(children: [
                buildTextFieldText(_language.boss),
                buildTextFieldText(item.executive)
              ]),
              TableRow(children: [
                buildTextFieldText(_language.contact),
                buildTextFieldText(item.contact)
              ]),
              TableRow(
                children: [
                  buildTextFieldText(_language.phoneKsk),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      buildTextFieldText(item.phone),
                      Padding(padding: EdgeInsets.only(left: 10)),
                      FlatButton(
                          onPressed: () => call(item.phone),
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
        Text(
          _language.guideLift,
          style: TextStyle(
              fontSize: 20 + _addingSize,
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
          fontSize: 12 + _addingSize),
    );
  }
}
