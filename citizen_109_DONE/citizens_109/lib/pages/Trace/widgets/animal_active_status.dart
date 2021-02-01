import 'package:citizens01/pages/Language/bloc/language_bloc.dart';
import 'package:citizens01/pages/Language/model/language_trace_page.dart';
import 'package:citizens01/pages/Trace/bloc/trace_bloc.dart';
import 'package:citizens01/pages/Trace/bloc/trace_event.dart';
import 'package:citizens01/pages/Trace/bloc/trace_state.dart';
import 'package:citizens01/pages/Trace/models/active_tracename.dart';
import 'package:citizens01/pages/Trace/widgets/app_active_files.dart';
import 'package:citizens01/tablet&phone/device_bloc.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:hexcolor/hexcolor.dart';

class AnimalStatus extends StatefulWidget {
  final ActiveTraceName activeTraceName;

  const AnimalStatus({Key key, @required this.activeTraceName})
      : super(key: key);

  @override
  _AnimalStatusState createState() => _AnimalStatusState();
}

class _AnimalStatusState extends State<AnimalStatus> {
  ActiveTraceName get activeTraceName => widget.activeTraceName;

  int groupValue;
  bool isShow = false;
  LanguageTracePage _language;
  String languageType;
  bool _btnEnabled = false;
  TraceBloc traceBloc;
  int rating;

  final _formKey = GlobalKey<FormState>();

  TextEditingController commentContoller = TextEditingController();

  void changebutton(int e) {
    setState(() {
      // rating = '$e';
      rating = e;
      groupValue = e;
      isShow = e == 1;
      _btnEnabled = true;
    });
  }

  double _addingSize = 0;
  double width;

  @override
  void initState() {
    traceBloc = TraceBloc();
    final device = BlocProvider.of<DeviceBloc>(context).state;
    if (device.isTablet) _addingSize = 5;
    width = device.width;
    super.initState();
  }

  String validateComment(String value) {
    if (value.isEmpty) {
      return "Напишите отзыв";
    } else if (value.length <= 2) {
      return 'Отзыв должен содержать более 2 символов';
    } else
      return null;
  }

  void updateComment() {
    String comment = commentContoller.text;
    Navigator.pop(context, true);
    flushbarText();
  }

  @override
  void dispose() {
    commentContoller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LanguageBloc, LanguageState>(
      builder: (context, state) {
        if (state is FetchedLanguageState)
          _language = state.language.languageTracePage;
        return BlocConsumer(
          cubit: traceBloc,
          listener: (context, state) {
            if (state is LoadSendRequestState) {
              updateComment();
            }
          },
          builder: (context, state) {
            if (state is LoadingTraceState) {
              return Container(
                alignment: Alignment.center,
                height: ScreenUtil().setHeight(300),
                child: CircularProgressIndicator(),
              );
            }
            return buildBody();
          },
        );
      },
    );
  }

  Widget buildBody() {
    return Form(
      key: _formKey,
      onChanged: () =>
          setState(() => _btnEnabled = _formKey.currentState.validate()),
      child: Padding(
        padding: EdgeInsets.only(top: 15, left: 15, right: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // buildCloseHeader(context),
            Padding(padding: EdgeInsets.all(15)),
            Text(
              _language.status,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: HexColor("#DC2B1A"),
                fontSize: 20 + _addingSize,
              ),
            ),
            Padding(padding: EdgeInsets.only(top: 5)),
            Text(
              _language.subtext1,
              style: TextStyle(
                color: HexColor("#DC2B1A"),
                fontWeight: FontWeight.bold,
                fontSize: 14 + _addingSize,
              ),
            ),
            Padding(padding: EdgeInsets.only(top: 10)),
            Text(
              _language.rate,
              style: TextStyle(
                color: HexColor("#407296"),
                fontWeight: FontWeight.bold,
                fontSize: 14 + _addingSize,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Radio(
                    value: 1,
                    groupValue: groupValue,
                    onChanged: (int e) => changebutton(e),
                  ),
                  buildTextStyle("1"),
                  Radio(
                      value: 2,
                      groupValue: groupValue,
                      onChanged: (int e) => changebutton(e)),
                  buildTextStyle("2"),
                  Radio(
                      value: 3,
                      groupValue: groupValue,
                      onChanged: (int e) => changebutton(e)),
                  buildTextStyle("3"),
                  Radio(
                      value: 4,
                      groupValue: groupValue,
                      onChanged: (int e) => changebutton(e)),
                  buildTextStyle("4"),
                  Radio(
                      value: 5,
                      groupValue: groupValue,
                      onChanged: (int e) => changebutton(e)),
                  buildTextStyle("5"),
                ],
              ),
            ),
            buildComment(),
            Padding(padding: EdgeInsets.only(top: 10)),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ButtonTheme(
                  minWidth: width,
                  height: ScreenUtil().setHeight(150),
                  child: RaisedButton(
                    child: Text(_language.closebtn,
                        style: TextStyle(
                            color: _btnEnabled ? Colors.white : Colors.grey,
                            fontSize: 20 + _addingSize)),
                    onPressed: _btnEnabled
                        ? () {
                            if (_formKey.currentState.validate() ||
                                groupValue < 0) {
                              _formKey.currentState.save();
                              traceBloc.add(LoadSendEvaluationEvent(
                                  rating: rating,
                                  comment: commentContoller.text,
                                  track_number: activeTraceName.track_number));
                            }
                          }
                        : null,
                    disabledColor: Colors.white,
                    color: HexColor("#407296"),
                    shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(5.0),
                        side: BorderSide(color: HexColor("#999A9D"), width: 2)),
                  ),
                ),
                buildCommentOperator()
              ],
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  //Comment from operator
  Widget buildCommentOperator() {
    if (activeTraceName.comment == '' || activeTraceName.comment != null) {
      return Container(
        padding: EdgeInsets.symmetric(
          horizontal: ScreenUtil().setWidth(25 + _addingSize),
          vertical: ScreenUtil().setHeight(30),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                activeTraceName.comment,
                style: TextStyle(
                  color: Theme.of(context).accentColor,
                  fontSize: ScreenUtil().setSp(40 + _addingSize),
                ),
              ),
            ),
            SizedBox(width: ScreenUtil().setWidth(20)),
            buildCommentFilesButton(),
          ],
        ),
      );
    }
    return Container(
      padding: EdgeInsets.only(top: 10),
      alignment: Alignment.bottomRight,
      child: buildCommentFilesButton(),
    );
  }

  //File from operator
  Widget buildCommentFilesButton() {
    return InkWell(
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => AppActiveFile(
                    activeTraceName: activeTraceName,
                  ))),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: ScreenUtil().setWidth(35 + _addingSize),
          vertical: ScreenUtil().setHeight(30 + _addingSize),
        ),
        decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).accentColor),
        ),
        child: Text(
          'Файл',
          style: TextStyle(
            color: Theme.of(context).accentColor,
            fontSize: ScreenUtil().setSp(32 + _addingSize),
          ),
        ),
      ),
    );
  }

//Коммент
  Widget buildComment() {
    if (!isShow) return Column();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          keyboardType: TextInputType.text,
          validator: validateComment,
          controller: commentContoller,
          style: TextStyle(color: HexColor("#407296")),
          decoration: InputDecoration(
            fillColor: Colors.white,
            filled: true,
            hintText: _language.comment,
            border: OutlineInputBorder(),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Theme.of(context).accentColor)),
            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          ),
        )
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
        _language.accepted,
        style: TextStyle(
          fontSize: ScreenUtil().setSp(55) + _addingSize,
          fontStyle: FontStyle.normal,
          color: Colors.white,
        ),
      ),
      duration: Duration(seconds: 2),
    )..show(context);
  }

  Widget buildTextStyle(String text) {
    return Text(
      text,
      style: TextStyle(
          color: HexColor("#4CADC7"),
          fontWeight: FontWeight.normal,
          fontSize: 14 + _addingSize),
    );
  }
}
