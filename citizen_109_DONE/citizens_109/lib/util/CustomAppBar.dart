import 'package:citizens01/pages/Language/bloc/language_bloc.dart';
import 'package:citizens01/pages/Language/model/language.dart';
import 'package:citizens01/tablet&phone/device_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomAppBar extends StatefulWidget with PreferredSizeWidget {
  final Widget leading;
  const CustomAppBar({Key key, this.leading}) : super(key: key);

  @override
  _CustomAppBarState createState() => _CustomAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _CustomAppBarState extends State<CustomAppBar> {
  LanguageBloc languageBloc;
  // AuthBloc authBloc;
  String currentLanguage;
  bool isTablet = false;
  double _addingSize = 0;

  void call(String phone) async {
    String url = 'tel:$phone';
    if (await canLaunch(url)) {
      await launch(url);
    }
  }

  @override
  void initState() {
    // authBloc = BlocProvider.of<AuthBloc>(context);

    languageBloc = BlocProvider.of<LanguageBloc>(context);
    final device = BlocProvider.of<DeviceBloc>(context).state;
    if (device.isTablet) _addingSize = 5;
    isTablet = device.isTablet;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: false,
      elevation: 1,
      backgroundColor: Colors.white,
      title: widget.leading,
      automaticallyImplyLeading: false,
      actions: [buildLangButton(context), buildCallButton1()],
      flexibleSpace: buildFlexibleSpace(context),
    );
  }

  Widget buildFlexibleSpace(BuildContext context) {
    return Container(
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

  Widget buildLangButton(BuildContext context) {
    return BlocBuilder<LanguageBloc, LanguageState>(
      builder: (context, state) {
        currentLanguage = state.type;
        return MaterialButton(
          minWidth: 0,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          onPressed: () {
            showSelector();
          },
          child: Text(
            state.type,
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.normal,
                color: Theme.of(context).accentColor),
          ),
        );
      },
    );
  }

  void showSelector() async {
    await showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.white,
          insetPadding: EdgeInsets.symmetric(
            horizontal: 30,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            width: 20,
            padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 10),
                Text(
                  'Выберите язык',
                  style: TextStyle(
                      color: Theme.of(context).accentColor,
                      fontSize: 20 + _addingSize,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                buildLanguageButtons(context),
              ],
            ),
          ),
        );
      },
    ).then((value) {
      if (value != null) languageBloc.add(ChangeLanguageEvent(value));
    });
  }

  Widget buildLanguageButtons(BuildContext context) {
    Widget button(String language) {
      return FlatButton(
        onPressed: () {
          Navigator.pop(context, language);
        },
        child: Text(
          language,
          style: TextStyle(
            color: Theme.of(context).accentColor,
            fontSize: 18 + _addingSize,
          ),
        ),
      );
    }

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 3,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // button(Language.en),
          button(Language.ru),
          button(Language.kz),
        ],
      ),
    );
  }

  Widget buildCallButton1() {
    return MaterialButton(
      minWidth: 0,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      onPressed: () => call('109'),
      child: Image.asset(
        "images/phone.png",
        height: ScreenUtil().setHeight(80),
        alignment: Alignment.bottomRight,
      ),
    );
  }
}
