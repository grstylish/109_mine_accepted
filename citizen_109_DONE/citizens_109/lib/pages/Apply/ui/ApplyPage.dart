import 'package:citizens01/pages/Apply/bloc/apply_bloc.dart';
import 'package:citizens01/pages/Apply/bloc/apply_event.dart';
import 'package:citizens01/pages/Apply/bloc/apply_state.dart';
import 'package:citizens01/pages/Apply/models/apply_images.dart';
import 'package:citizens01/pages/Apply/ui/widgets/page_form1.dart';
import 'package:citizens01/pages/Language/bloc/language_bloc.dart';
import 'package:citizens01/pages/Language/model/language_apply_page.dart';
import 'package:citizens01/tablet&phone/device_bloc.dart';
import 'package:citizens01/util/CustomAppBar.dart';
import 'package:citizens01/util/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hexcolor/hexcolor.dart';

class ApplyPage extends StatefulWidget {
  @override
  _ApplyPageState createState() => _ApplyPageState();
}

class _ApplyPageState extends State<ApplyPage> {
  PageController controller;
  bool isShow = false;
  double _addingSize = 0;
  double _addingAlign;
  ApplyBloc applyBloc;
  String selectedCategory;
  int selectedCategoryID;
  LanguageApplyPage _language;
  String languageType;

  @override
  void initState() {
    applyBloc = ApplyBloc();
    applyBloc.add(LoadImageEvent());
    controller = PageController();
    final device = BlocProvider.of<DeviceBloc>(context).state;
    if (device.isTablet) _addingSize = 5;
    _addingAlign =
        device.isTablet ? ScreenUtil().setSp(450) : ScreenUtil().setSp(150);
    super.initState();
  }

  void checkUp(bool newValue) {
    setState(() {
      isShow = newValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LanguageBloc, LanguageState>(builder: (context, state) {
      if (state is FetchedLanguageState) {
        _language = state.language.languageApplyPage;
        languageType = state.type;
      }
      return Scaffold(
        appBar: buildAppBar(),
        body: BlocProvider(
          create: (context) => applyBloc,
          child: BlocListener<ApplyBloc, ApplyState>(
            listener: (context, state) {
              print(state);
              if (state is RequestSendedApplyState) {
                applyBloc.add(LoadImageEvent());
                controller.jumpToPage(0);
              }
            },
            child: PageView(
              physics: NeverScrollableScrollPhysics(),
              controller: controller,
              children: [
                Container(
                  padding: EdgeInsets.all(10),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 10),
                        ),
                        buildText(),
                        Padding(padding: EdgeInsets.only(top: 30)),
                        buildImages(context)
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  child: SingleChildScrollView(
                    child: BuildPageForm1(
                        pageController: controller,
                        category: selectedCategory,
                        categoryID: selectedCategoryID),
                  ),
                ),
              ],
            ),
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
          _language.chooseCategory,
          style: TextStyle(
              fontSize: ScreenUtil().setSp(55) + _addingSize,
              color: HexColor("#407296"),
              fontWeight: FontWeight.normal),
        )
      ],
    ));
  }

  /// Images
  Widget buildImages(BuildContext context) {
    return BlocBuilder<ApplyBloc, ApplyState>(
      builder: (context, state) {
        print('STATE FOR INFORMATION ');
        if (state is InitialApplyState) {
          return Center(
            child: Text("No data received"),
          );
        }
        if (state is LoadingApplyState) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        if (state is LoadImageState) {
          return buildAppImage(state.loadapplyimages);
        }
        if (state is FailureApplyState) {
          FlushbarManager(context, message: state.error).show();
        }
        return Container();
      },
    );
  }

  buildAppImage(List<ApplyImages> list) {
    List<Widget> buttons = [];
    for (var item in list) {
      String image = 'images/' + item.image.split('/').last;
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
                  applyBloc.add(LoadApplyCategories(item.id));
                  setState(() {
                    languageType == 'KZ'
                        ? selectedCategory = item.namekz
                        : selectedCategory = item.name;
                    selectedCategoryID = item.id;
                  });
                  controller.jumpToPage(1);
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
                  languageType == 'KZ' ? item.namekz : item.name,
                  style: TextStyle(
                      fontSize: ScreenUtil().setSp(35) + _addingSize,
                      color: HexColor("#407296")),
                  textAlign: TextAlign.center,
                ),
              ),
            )

            // SizedBox(
            //   width: ScreenUtil().setWidth(300) + _addingAlign,
            //   child: Text(
            //     item.name,
            //     style: TextStyle(
            //         fontSize: ScreenUtil().setSp(35) + _addingSize,
            //         color: HexColor("#407296")),
            //     textAlign: TextAlign.center,
            //   ),
            // ),
          ],
        ),
      );
    }

    return Wrap(
      alignment: WrapAlignment.spaceAround,
      spacing: 1 + _addingSize,
      runSpacing: 15 + _addingSize,
      children: buttons,
    );
  }

  /// -------AppBar-----------------------
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
              child: FittedBox(child: Image.asset("images/109aktobe.png"))),
        ),
      ],
    )));
  }
}
