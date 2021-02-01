import 'package:citizens01/pages/Language/bloc/language_bloc.dart';
import 'package:citizens01/pages/Language/model/language_profile_page.dart';
import 'package:citizens01/pages/Profile/bloc/profile_bloc.dart';
import 'package:citizens01/pages/Profile/ui/widgets/page_form.dart';
import 'package:citizens01/tablet&phone/device_bloc.dart';
import 'package:citizens01/util/CustomAppBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hexcolor/hexcolor.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  double _addingSize = 0;
  double _addingAlign;
  ProfileBloc profileBloc;
  LanguageProfilePage _language;

  @override
  void initState() {
    final device = BlocProvider.of<DeviceBloc>(context).state;
    if (device.isTablet) _addingSize = 5;
    _addingAlign =
        device.isTablet ? ScreenUtil().setSp(450) : ScreenUtil().setSp(150);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LanguageBloc, LanguageState>(builder: (context, state) {
      if (state is FetchedLanguageState) {
        _language = state.language.languageProfilePage;
        return buildBody();
      }
      return Scaffold();
    });
  }

  Widget buildBody() {
    return Scaffold(
        appBar: buildAppBar(context),
        body: PageView(
          physics: NeverScrollableScrollPhysics(),
          children: [
            Container(
              padding: EdgeInsets.all(10),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(padding: EdgeInsets.only(top: 10)),
                    buildText(),
                    Padding(padding: EdgeInsets.only(top: 10)),
                    BuildPageForm(),
                  ],
                ),
              ),
            ),
          ],
        ));
  }

  Widget buildText() {
    return Center(
        child: Column(
      children: [
        Text(
          _language.yourProfile,
          style: TextStyle(
              fontSize: ScreenUtil().setSp(55) + _addingSize,
              color: HexColor("#407296"),
              fontWeight: FontWeight.normal),
        )
      ],
    ));
  }

  Widget buildAppBar(context) {
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
            child: Image.asset("images/109aktobe.png"),
          )),
        )
      ],
    )));
  }
}
