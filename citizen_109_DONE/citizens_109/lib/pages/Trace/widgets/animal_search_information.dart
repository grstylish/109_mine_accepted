import 'package:citizens01/pages/Language/bloc/language_bloc.dart';
import 'package:citizens01/pages/Language/model/language_trace_page.dart';
import 'package:citizens01/pages/Trace/models/search_tracename.dart';
import 'package:citizens01/pages/Trace/widgets/app_search_files.dart';
import 'package:citizens01/tablet&phone/device_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:steps/steps.dart';

class AnimalSearchInformation extends StatefulWidget {
  final SearchTraceName searchTraceName;

  const AnimalSearchInformation({Key key, @required this.searchTraceName})
      : super(key: key);
  @override
  _AnimalSearchInformationState createState() =>
      _AnimalSearchInformationState();
}

class _AnimalSearchInformationState extends State<AnimalSearchInformation> {
  double _addingSize = 0;
  LanguageTracePage _language;
  SearchTraceName get searchTraceName => widget.searchTraceName;
  String languageType;

  @override
  void initState() {
    final device = BlocProvider.of<DeviceBloc>(context).state;
    if (device.isTablet) _addingSize = 5;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LanguageBloc, LanguageState>(
      builder: (context, state) {
        if (state is FetchedLanguageState)
          _language = state.language.languageTracePage;
        languageType = state.type;

        return Padding(
          padding: EdgeInsets.only(top: 0, left: 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildCloseHeader(context),
              Text(
                _language.status,
                style: TextStyle(
                  fontWeight: FontWeight.normal,
                  color: HexColor("#407296"),
                  fontSize: 20 + _addingSize,
                ),
              ),
              Padding(padding: EdgeInsets.only(top: 5)),
              Text(
                "${_language.subtext} ${searchTraceName.getDeadline}",
                style: TextStyle(
                  color: HexColor("#407296"),
                  fontWeight: FontWeight.normal,
                  fontSize: 14 + _addingSize,
                ),
              ),
              buildBody(),
              buildCommentOperator(),
              Padding(padding: EdgeInsets.only(top: 3)),
            ],
          ),
        );
      },
    );
  }

  Widget buildBody() {
    List<Map> steps = [];
    int len = searchTraceName.statuses.length;
    for (int j = 0; j < len; j++) {
      Color color = HexColor("#C4C4C4");
      DateTime date =
          DateTime.parse(searchTraceName.statuses[j].date).toLocal();
      bool isAfter = DateTime.now().toLocal().isAfter(date);
      bool isCurrent = false;
      if (j != len - 1 && isAfter) {
        DateTime nextDate =
            DateTime.parse(searchTraceName.statuses[j].date).toLocal();
        isAfter = DateTime.now().toLocal().isAfter(nextDate);
        if (!isAfter) isCurrent = true;
      } else if (j == len - 1 && !isCurrent) isCurrent = true;

      steps.add({
        'color': Colors.white,
        'background': isCurrent ? Colors.green : color,
        'label': '1',
        'content': Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              searchTraceName.statuses[j].getDate,
              style: TextStyle(
                  fontSize: 12.0 + _addingSize,
                  color: Theme.of(context).accentColor),
            ),
            Text(
              languageType == 'KZ'
                  ? searchTraceName.statuses[j].lblkz
                  : searchTraceName.statuses[j].lbl,
              style: TextStyle(
                  fontSize: 12.0 + _addingSize, color: HexColor("#407296")),
            ),
          ],
        ),
      });
    }
    return Expanded(
      child: Steps(
        direction: Axis.vertical,
        size: 5.0 + _addingSize,
        path: {'color': HexColor("#C4C4C4"), 'width': 4.0},
        steps: steps,
      ),
    );
  }

  Widget buildCommentOperator() {
    if (searchTraceName.israted == true) {
      return Container(
        padding: EdgeInsets.symmetric(
          horizontal: ScreenUtil().setWidth(25 + _addingSize),
          vertical: ScreenUtil().setHeight(30),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                searchTraceName.comment == null || searchTraceName.comment == ""
                    ? ""
                    : searchTraceName.comment,
                style: TextStyle(
                  color: Theme.of(context).accentColor,
                  fontSize: ScreenUtil().setSp(25 + _addingSize),
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
    if (searchTraceName.israted == true) {
      return InkWell(
        onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => AppFile(
                      searchTraceName: searchTraceName,
                    ))),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: ScreenUtil().setWidth(20 + _addingSize),
            vertical: ScreenUtil().setHeight(20 + _addingSize),
          ),
          decoration: BoxDecoration(
            border: Border.all(color: Theme.of(context).accentColor),
          ),
          child: Text(
            'Файл',
            style: TextStyle(
              color: Theme.of(context).accentColor,
              fontSize: ScreenUtil().setSp(30 + _addingSize),
            ),
          ),
        ),
      );
    }
  }

  Widget buildCloseHeader(BuildContext context) {
    return Container(
      alignment: Alignment.centerRight,
      child: InkWell(
        onTap: () => Navigator.pop(context),
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Icon(
            Icons.close,
            color: Theme.of(context).accentColor,
          ),
        ),
      ),
    );
  }
}
