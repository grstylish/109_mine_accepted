import 'package:citizens01/pages/Guide/bloc/guide_bloc.dart';
import 'package:citizens01/pages/Guide/bloc/guide_event.dart';
import 'package:citizens01/pages/Guide/bloc/guide_state.dart';
import 'package:citizens01/pages/Guide/models/guide_images.dart';
import 'package:citizens01/pages/Guide/ui/addeducation.dart';
import 'package:citizens01/pages/Guide/ui/hospital.dart';
import 'package:citizens01/pages/Guide/ui/informationpage.dart';
import 'package:citizens01/pages/Guide/ui/kindergarten.dart';
import 'package:citizens01/pages/Guide/ui/lift.dart';
import 'package:citizens01/pages/Guide/ui/pharmacy.dart';
import 'package:citizens01/pages/Guide/ui/school.dart';
import 'package:citizens01/pages/Guide/ui/searchpage.dart';
import 'package:citizens01/pages/Language/bloc/language_bloc.dart';
import 'package:citizens01/pages/Language/model/language_guide_page.dart';
import 'package:citizens01/tablet&phone/device_bloc.dart';
import 'package:citizens01/util/CustomAppBar.dart';
import 'package:citizens01/util/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hexcolor/hexcolor.dart';

class GuidePage extends StatefulWidget {
  @override
  _GuidePageState createState() => _GuidePageState();
}

class _GuidePageState extends State<GuidePage> {
  PageController controller;
  double _addingSize = 0;
  double _addingAlign;
  GuideBloc guideBloc;
  LanguageGuidePage _language;
  String languageType;
  List<GuideImages> list = [];

  @override
  void initState() {
    guideBloc = GuideBloc();
    guideBloc.add(LoadImageEvent());
    controller = PageController();
    final device = BlocProvider.of<DeviceBloc>(context).state;
    if (device.isTablet) _addingSize = 5;
    _addingAlign =
        device.isTablet ? ScreenUtil().setSp(450) : ScreenUtil().setSp(150);
    super.initState();
  }

  @override
  void dispose() {
    guideBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LanguageBloc, LanguageState>(builder: (context, state) {
      if (state is FetchedLanguageState) {
        _language = state.language.languageGuidePage;
        languageType = state.type;
      }
      return Scaffold(
        appBar: buildAppBar(),
        body: BlocProvider(
          create: (context) => guideBloc,
          child: PageView(
            physics: NeverScrollableScrollPhysics(),
            controller: controller,
            children: [
              Container(
                padding: EdgeInsets.all(10),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(padding: EdgeInsets.only(top: 10)),
                      buildText(),
                      Padding(padding: EdgeInsets.only(top: 30)),
                      buildImages(),
                    ],
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(10),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(padding: EdgeInsets.only(top: 10)),
                      //указываем страницу

                      SearchPage(controller: controller)
                    ],
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(10),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(padding: EdgeInsets.only(top: 10)),
                      //указываем страницу

                      InformationBook(controller: controller),
                    ],
                  ),
                ),
              ),
              Container(
                // child: Text('3'),
                padding: EdgeInsets.all(10),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(padding: EdgeInsets.only(top: 10)),
                      //указываем страницу

                      PharmacyPage(controller: controller),
                    ],
                  ),
                ),
              ),
              //указываем страницу
              Container(
                // child: Text('4'),
                padding: EdgeInsets.all(10),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(padding: EdgeInsets.only(top: 10)),
                      //указываем страницу
                      LiftPage(controller: controller),
                    ],
                  ),
                ),
              ),
              Container(
                // child: Text('5'),
                padding: EdgeInsets.all(10),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(padding: EdgeInsets.only(top: 10)),
                      //указываем страницу
                      HospitalPage(controller: controller),
                    ],
                  ),
                ),
              ),
              Container(
                // child: Text('5'),
                padding: EdgeInsets.all(10),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(padding: EdgeInsets.only(top: 10)),
                      //указываем страницу
                      AddEducationPage(controller: controller),
                    ],
                  ),
                ),
              ),

              Container(
                // child: Text('5'),
                padding: EdgeInsets.all(10),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(padding: EdgeInsets.only(top: 10)),
                      //указываем страницу
                      SchoolPage(controller: controller),
                    ],
                  ),
                ),
              ),

              Container(
                // child: Text('5'),
                padding: EdgeInsets.all(10),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(padding: EdgeInsets.only(top: 10)),
                      //указываем страницу
                      KindergartenPage(controller: controller),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget buildText() {
    return Center(
        child: Column(
      children: [
        Text(
          _language.chooseDirectory,
          style: TextStyle(
              fontSize: ScreenUtil().setSp(55) + _addingSize,
              color: HexColor("#407296"),
              fontWeight: FontWeight.normal),
        )
      ],
    ));
  }

  Widget buildImages() {
    return BlocBuilder<GuideBloc, GuideState>(
      builder: (context, state) {
        print('STATE FOR INFORMATION ');
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
        if (state is LoadedImageState) {
          return buildAppImage(state.loadedapplyimages);
        }
        if (state is FailureGuideState) {
          FlushbarManager(context, message: state.error).show();
        }
        return Container();
      },
    );
  }

  buildAppImage(List<GuideImages> list) {
    List<Widget> buttons = [];
    for (var item in list) {
      String image = 'images/' + item.image.split('/').last;
      print("HERE $image");
      buttons.add(
        Column(
          // mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: ScreenUtil().setWidth(250) + _addingSize,
              height: ScreenUtil().setHeight(300) + _addingSize,
              child: FlatButton(
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: HexColor("#9DC2DC")),
                  borderRadius: new BorderRadius.circular(10.0 + _addingSize),
                ),
                onPressed: () {
                  print(item.id);
                  if (item.id == 1) guideBloc.add(LoadGuideStreetEvent());
                  if (item.id == 2) guideBloc.add(LoadGuideEvent());
                  if (item.id == 3) guideBloc.add(LoadGuidePharmacyEvent());
                  if (item.id == 6) {
                    controller.jumpToPage(4);
                    guideBloc.add(LoadGuideLiftEvent());
                  } else if (item.id == 9) {
                    controller.jumpToPage(5);
                    guideBloc.add(LoadGuideHospitalEvent());
                  } else if (item.id == 18) {
                    controller.jumpToPage(6);
                    guideBloc.add(LoadGuideAddEducationEvent());
                  } else if (item.id == 12) {
                    controller.jumpToPage(7);
                    guideBloc.add(LoadGuideSchoolEvent());
                  } else if (item.id == 15) {
                    controller.jumpToPage(8);
                    guideBloc.add(LoadGuideKinderEvent());
                  } else {
                    controller.jumpToPage(item.id);
                  }
                },
                color: HexColor("#407296"),
                padding: EdgeInsets.all(10.0),
                child: Image.asset(
                  image,
                  height: ScreenUtil().setHeight(350) + _addingSize,
                  width: ScreenUtil().setWidth(300) + _addingSize,
                ),
              ),
            ),
            Padding(padding: EdgeInsets.only(top: 5 + _addingSize)),
            FittedBox(
              child: Container(
                width: ScreenUtil().setWidth(300) + _addingAlign,
                child: Text(
                  languageType == 'KZ' ? item.name_kz : item.name,
                  style: TextStyle(
                      fontSize: ScreenUtil().setSp(35) + _addingSize,
                      color: HexColor("#407296")),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 1 + _addingSize,
      runSpacing: 15 + _addingSize,
      children: buttons,
    );
  }

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
