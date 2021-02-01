import 'package:citizens01/config.dart';
import 'package:citizens01/pages/Language/bloc/language_bloc.dart';
import 'package:citizens01/pages/Language/model/language_trace_page.dart';
import 'package:citizens01/pages/Trace/models/search_tracename.dart';
import 'package:citizens01/tablet&phone/device_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hexcolor/hexcolor.dart';

class AppFile extends StatefulWidget {
  final SearchTraceName searchTraceName;

  const AppFile({Key key, @required this.searchTraceName}) : super(key: key);

  @override
  _AppFileState createState() => _AppFileState();
}

class _AppFileState extends State<AppFile> {
  var width = DEVICE_WIDTH;
  var height = DEVICE_HEIGHT;
  double _addingSize = 0;
  bool isTablet = false;
  DeviceBloc deviceBloc;
  bool _btnEnabled = false;
  LanguageTracePage _language;
  SearchTraceName get searchTraceName => widget.searchTraceName;

  @override
  void initState() {
    deviceBloc = BlocProvider.of<DeviceBloc>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LanguageBloc, LanguageState>(builder: (context, state) {
      if (state is FetchedLanguageState) {
        _language = state.language.languageTracePage;
      }
      return buildBody();
    });
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
      appBar: buildAppBar(),
      body: Container(
        padding: EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            children: [
              buildImage(),
              Padding(padding: EdgeInsets.only(top: 10)),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildImage() {
    List<Widget> children = [
      Text(
        _language.report,
        style: TextStyle(
          color: HexColor("#407296"),
          fontWeight: FontWeight.bold,
          fontSize: 20 + _addingSize,
        ),
      ),
      Padding(
          padding: EdgeInsets.only(
        top: 20,
      )),
    ];
    for (var item in searchTraceName.statuses.last.file) {
      children.add(Image.network('https://ccc.usmcontrol.com$item'));
    }
    return Center(
      child: Column(children: children),
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
            _language.returnback,
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
}
