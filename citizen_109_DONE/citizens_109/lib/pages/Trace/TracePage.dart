import 'package:citizens01/pages/Language/bloc/language_bloc.dart';
import 'package:citizens01/pages/Language/model/language_trace_page.dart';
import 'package:citizens01/pages/Trace/bloc/trace_bloc.dart';
import 'package:citizens01/pages/Trace/bloc/trace_event.dart';
import 'package:citizens01/pages/Trace/bloc/trace_state.dart';
import 'package:citizens01/pages/Trace/models/active_tracename.dart';
import 'package:citizens01/pages/Trace/models/search_tracename.dart';
import 'package:citizens01/pages/Trace/widgets/animal_active_information.dart';
import 'package:citizens01/pages/Trace/widgets/animal_search_information.dart';
import 'package:citizens01/pages/Trace/widgets/animal_active_status.dart';
import 'package:citizens01/pages/Trace/widgets/animal_search_status.dart';
import 'package:citizens01/tablet&phone/device_bloc.dart';
import 'package:citizens01/util/flushbar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:citizens01/util/CustomAppBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TracePage extends StatefulWidget {
  @override
  _TracePageState createState() => _TracePageState();
}

class _TracePageState extends State<TracePage> {
  bool isShow = false;
  int groupValue;
  double _addingSize = 0;
  double _addingAlign;
  TraceBloc traceBloc;
  List<ActiveTraceName> activeTraceName = [];
  List<SearchTraceName> searchTraceName = [];
  TextEditingController tracknumberController = TextEditingController();
  double width;
  bool _btnEnabled = false;
  final _formKey = GlobalKey<FormState>();
  LanguageTracePage _language;
  String languageType;

  void updatePage() {
    String track_number = tracknumberController.text;
    traceBloc.add(LoadSearchTraceNameEvent(track_number));

    setState(() {
      isShow = true;
    });
  }

  String validateCode(String value) {
    if (value.isEmpty) {
      return "Введите номер заявки";
    }
    if (value.length != 10) {
      return 'Введите правильный номер';
    } else
      return null;
  }

  @override
  void initState() {
    traceBloc = TraceBloc();
    traceBloc.add(LoadTraceNameEvent());
    final device = BlocProvider.of<DeviceBloc>(context).state;
    if (device.isTablet) _addingSize = 5;
    _addingAlign =
        device.isTablet ? ScreenUtil().setSp(450) : ScreenUtil().setSp(150);
    width = device.width;
    super.initState();
  }

  @override
  void dispose() {
    tracknumberController.dispose();
    tracknumberController.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LanguageBloc, LanguageState>(builder: (context, state) {
      if (state is FetchedLanguageState) {
        _language = state.language.languageTracePage;
        languageType = state.type;
      }
      return Form(
          key: _formKey,
          onChanged: () =>
              setState(() => _btnEnabled = _formKey.currentState.validate()),
          child: Scaffold(
            appBar: buildAppBar(),
            body: BlocProvider(
              create: (context) => traceBloc,
              child: BlocListener<TraceBloc, TraceState>(
                listener: (context, state) {
                  if (state is LoadActiveTraceNameState) {
                    setState(() {
                      activeTraceName = state.loadedactivetracename;
                    });
                  }
                  if (state is LoadSearchTraceNameState) {
                    setState(() {
                      searchTraceName = state.loadedsearchtracename;
                    });
                  }
                  if (state is FailureTraceState) {
                    FlushbarManager(context, message: state.error).show();
                  }
                },
                child: Container(
                  padding: EdgeInsets.all(10),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Padding(padding: EdgeInsets.only(top: 10)),
                        buildPageTitle(),
                        Padding(padding: EdgeInsets.only(top: 20)),
                        traceTextField(),
                        Padding(padding: EdgeInsets.only(top: 10)),
                        buildTraceButton(),
                        Padding(padding: EdgeInsets.only(top: 20)),
                        buildSearchButtons(),
                        Padding(padding: EdgeInsets.only(top: 20)),
                        buildTextTitle(),
                        Padding(padding: EdgeInsets.only(top: 10)),
                        buildButtons(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ));
    });
  }

  ///Для поиска по номеру при нажатии на кнопку
  Widget buildSearchButtons() {
    if (!isShow) return Column();
    List<Widget> children = [];
    for (var item in searchTraceName) {
      print("ITEMMM FROM SEARCH $item");
      children.add(
        buildButtonContainer(
          languageType == 'KZ' ? item.namekz : item.name,
          languageType == 'KZ' ? item.subnamakz : item.subname,
          () {
            Widget child = AnimalSearchInformation(searchTraceName: item);
            bool isScrollControlled = false;
            if (item.statuses.isNotEmpty &&
                item.statuses.last.status == 'Завершено' &&
                item.israted == false) {
              child = AnimalStatus1(
                searchTraceName: item,
              );
              isScrollControlled = true;
            }
            if (item.israted == true) {
              child = AnimalSearchInformation(searchTraceName: item);
              print(item.israted);
              isScrollControlled = false;
            }
            showBottomModal(
                child: child, isScrollControlled: isScrollControlled);
          },
        ),
      );
    }

    return GestureDetector(
        onTap: () {
          FocusScopeNode focus = FocusScope.of(context);
          if (!focus.hasPrimaryFocus) focus.unfocus();
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: children,
        ));
  }

  // //Сразу показывает при открытии страницы
  Widget buildButtons() {
    List<Widget> children = [];
    for (var item in activeTraceName) {
      children.add(
        buildButtonContainer(
          languageType == 'KZ' ? item.namekz : item.name,
          languageType == 'KZ' ? item.subnamakz : item.subname,
          () {
            Widget child = AnimalInformation(activeTraceName: item);
            bool isScrollControlled = false;
            if (item.statuses.isNotEmpty &&
                item.statuses.last.status == 'Завершено' &&
                item.israted == false) {
              child = AnimalStatus(
                activeTraceName: item,
              );
              isScrollControlled = true;
            }
            if (item.israted == true) {
              child = AnimalInformation(activeTraceName: item);
              print(item.israted);
              isScrollControlled = false;
            }
            showBottomModal(
                child: child, isScrollControlled: isScrollControlled);
          },
        ),
      );
    }

    return GestureDetector(
        onTap: () {
          FocusScopeNode focus = FocusScope.of(context);
          if (!focus.hasPrimaryFocus) focus.unfocus();
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: children,
        ));
  }

  Widget buildPageTitle() {
    return Column(
      children: [
        Text(
          _language.track,
          style: TextStyle(
              fontSize: ScreenUtil().setSp(55) + _addingSize,
              color: HexColor("#407296"),
              fontWeight: FontWeight.normal),
        )
      ],
    );
  }

  Widget buildTextTitle() {
    return GestureDetector(
        onTap: () {
          FocusScopeNode focus = FocusScope.of(context);
          if (!focus.hasPrimaryFocus) focus.unfocus();
        },
        child: Column(
          children: [
            Text(
              _language.activeTrack,
              style: TextStyle(
                  fontSize: ScreenUtil().setSp(55) + _addingSize,
                  color: HexColor("#4CADC7"),
                  fontWeight: FontWeight.normal),
            )
          ],
        ));
  }

  Widget traceTextField() {
    return GestureDetector(
        onTap: () {
          FocusScopeNode focus = FocusScope.of(context);
          if (!focus.hasPrimaryFocus) focus.unfocus();
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildTextFieldTitle(_language.addNumberTrack),
            Padding(padding: EdgeInsets.only(top: 5)),
            TextFormField(
              validator: validateCode,
              maxLength: 10,
              keyboardType: TextInputType.number,
              controller: tracknumberController,
              style: TextStyle(color: HexColor("#407296")),
              decoration: InputDecoration(
                counter: Container(),
                fillColor: Colors.white,
                filled: true,
                border: OutlineInputBorder(),
                enabledBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Theme.of(context).accentColor)),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                hintText: _language.addNumberTrack,
                hintStyle: TextStyle(
                  color: HexColor("#999A9D"),
                ),
              ),
            )
          ],
        ));
  }

  Widget buildTraceButton() {
    return GestureDetector(
        onTap: () {
          FocusScopeNode focus = FocusScope.of(context);
          if (!focus.hasPrimaryFocus) focus.unfocus();
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ButtonTheme(
              minWidth: width,
              height: ScreenUtil().setHeight(150),
              child: RaisedButton(
                child: Text(_language.findtrack,
                    style: TextStyle(
                        color: _btnEnabled ? Colors.white : Colors.grey,
                        fontSize: 20 + _addingSize)),
                onPressed: _btnEnabled
                    ? () {
                        if (_formKey.currentState.validate()) {
                          _formKey.currentState.save();
                          updatePage();
                        }
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
        ));
  }

  Widget buildButtonContainer(String title, String title1, Function onPress) {
    var shortesSide = MediaQuery.of(context).size.shortestSide;
    Widget message = Container();
    print("Here title $title");
    // if (title.isNotEmpty) {
    //   message = Icon(
    //     Icons.error,
    //     color: Colors.red,
    //   );
    // }
    return GestureDetector(
        onTap: () {
          FocusScopeNode focus = FocusScope.of(context);
          if (!focus.hasPrimaryFocus) focus.unfocus();
        },
        child: InkWell(
          onTap: onPress,
          child: Container(
            width: shortesSide,
            child: Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                      child: RichText(
                    text: TextSpan(
                      style: TextStyle(
                          color: HexColor("#407296"),
                          fontSize: ScreenUtil().setSp(40),
                          fontWeight: FontWeight.bold),
                      children: <TextSpan>[
                        TextSpan(
                          text: title,
                        ),
                        TextSpan(text: " / "),
                        TextSpan(text: title1),
                      ],
                    ),
                  )),
                  message,
                  Icon(
                    Icons.keyboard_arrow_down,
                    color: Theme.of(context).accentColor,
                    size: ScreenUtil().setSp(150),
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  void showBottomModal(
      {@required Widget child, bool isScrollControlled = true}) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: isScrollControlled,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      backgroundColor: Colors.white,
      builder: (context) {
        Widget widgetChild = child;
        if (isScrollControlled) {
          widgetChild = SingleChildScrollView(child: child);
        }
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: widgetChild,
        );
      },
    ).then((value) {
      if (value != null) {
        String track_number = tracknumberController.text;
        if (track_number.isNotEmpty)
          traceBloc.add(LoadSearchTraceNameEvent(track_number));
        traceBloc.add(LoadTraceNameEvent());
      }
    });
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

// //.....................Врехняя часть-Done................................
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
              height: ScreenUtil().setSp(80) + _addingSize,
              width: ScreenUtil().setSp(80) + _addingSize,
            ),
            Padding(padding: EdgeInsets.only(left: 5)),
            Image.asset(
              "images/logo12.png",
              height: ScreenUtil().setSp(80) + _addingSize,
              width: ScreenUtil().setSp(80) + _addingSize,
            )
          ],
        ),
        Container(
          padding: EdgeInsets.only(right: _addingAlign),
          child: Center(
              child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Image.asset("images/109aktobe.png"),
          )),
        )
      ],
    )));
  }
}
