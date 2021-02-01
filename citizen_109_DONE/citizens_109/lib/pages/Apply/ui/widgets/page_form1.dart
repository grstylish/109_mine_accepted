import 'dart:io';
import 'package:citizens01/pages/Apply/bloc/apply_bloc.dart';
import 'package:citizens01/pages/Apply/bloc/apply_event.dart';
import 'package:citizens01/pages/Apply/bloc/apply_state.dart';
import 'package:citizens01/pages/Apply/models/apply_categories.dart';
import 'package:citizens01/pages/Apply/ui/widgets/page_map.dart';
import 'package:citizens01/pages/Language/bloc/language_bloc.dart';
import 'package:citizens01/pages/Language/model/language_apply_page.dart';
import 'package:citizens01/tablet&phone/device_bloc.dart';
import 'package:citizens01/util/flushbar.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:hexcolor/hexcolor.dart';

class BuildPageForm1 extends StatefulWidget {
  final PageController pageController;
  final String category;
  final int categoryID;

  const BuildPageForm1({
    Key key,
    @required this.pageController,
    @required this.category,
    @required this.categoryID,
  }) : super(key: key);
  @override
  _BuildPageForm1State createState() => _BuildPageForm1State();
}

class _BuildPageForm1State extends State<BuildPageForm1> {
  PageController get pageController => widget.pageController;
  String get category => widget.category;
  double _addingSize = 0;
  TextEditingController addressController = TextEditingController();
  TextEditingController causeController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  List<File> files = [];
  LanguageApplyPage _language;
  String languageType;

  String fileName;
  String path;
  List<String> extensions;
  bool isLoadingPath = false;
  bool isMultiPick = true;
  FileType fileType;
  int count = 0;

  final _formKey = GlobalKey<FormState>();
  ApplyBloc applyBloc;
  List<ApplyCategories> categoryTitles = [];
  String categoryTitle;
  int subcategoryID;
  String groupName;
  int groupId;
  bool _btnEnabled = false;

  double width;
  bool isCheck = false;

  @override
  void initState() {
    applyBloc = BlocProvider.of<ApplyBloc>(context);
    final device = BlocProvider.of<DeviceBloc>(context).state;
    if (device.isTablet) _addingSize = 5;
    width = device.width;
    super.initState();
  }

  void clearPage() {
    setState(() {
      addressController.clear();
      causeController.clear();
      categoryController.clear();
      groupId = null;
      groupName = null;
      categoryTitle = null;
      subcategoryID = null;
      isCheck = false;
      files = [];
    });
  }

  void uploadFiles() async {
    setState(() => isLoadingPath = true);
    files = [];
    FilePickerResult results;

    try {
      results = await FilePicker.platform.pickFiles(
          allowMultiple: true,
          type: fileType != null ? fileType : FileType.any,
          allowedExtensions: extensions);
      for (var item in results.files) {
        var file = File(item.path);
        print("FILE $file");
        var bait = file.lengthSync();
        print("BAIT $bait");
        if (item.path.endsWith("jpg") && bait < 2097152 ||
            item.path.endsWith("mp4") && bait < 104857600) {
          print("РАЗМЕР: $bait");
          files.add(File(item.path));
          print("files here $files");
        }
      }
    } on PlatformException catch (e) {
      print("Unsupported operation" + e.toString());
    }
    if (!mounted) return;
    setState(() {
      isLoadingPath = false;
      // fileName = path != null
      //     ? path.split('/').last
      //     : paths != null
      //         ? paths.keys.toString()
      //         : '...';

      count = results.files.isNotEmpty ? files.length : 1;
    });
  }

  @override
  void dispose() {
    categoryController.clear();
    causeController.clear();
    addressController.clear();
    categoryController.dispose();
    causeController.dispose();
    addressController.dispose();
    super.dispose();
  }

  String validateAddress(String value) {
    if (value.isEmpty) {
      return languageType == 'KZ'
          ? "Оқиғаның мекен-жайын енгізіңіз"
          : "Введите адрес происшествия";
    } else if (value.length < 2) {
      return languageType == 'KZ'
          ? 'Мекен-жай 2 таңбадан артық болуы керек'
          : 'Адрес должен содержать более 2 символов';
    }
    return null;
  }

  String validateCause(String value) {
    if (value.isEmpty) {
      return languageType == 'KZ' ? "Себебін енгізіңіз" : "Введите причину";
    } else if (value.length < 2) {
      return languageType == 'KZ'
          ? "Себеп 2 таңбадан артық болуы керек"
          : 'Причина должна содержать более 2 символов';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LanguageBloc, LanguageState>(builder: (context, state) {
      if (state is FetchedLanguageState) {
        _language = state.language.languageApplyPage;
        languageType = state.type;
      }
      return BlocListener<ApplyBloc, ApplyState>(
          listener: (context, state) {
            if (state is LoadCategoriesState) {
              setState(() => categoryTitles = state.loadapplycategories);
            }
            if (state is RequestSendedApplyState) {
              flushbarText();
              clearPage();
            }
            if (state is FailureApplyState) {
              FlushbarManager(context, message: state.error).show();
            }
          },
          child: Form(
            key: _formKey,
            onChanged: () =>
                setState(() => _btnEnabled = _formKey.currentState.validate()),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildBackButton(),
                Padding(padding: EdgeInsets.only(top: 10)),
                Text(
                  _language.mustfield,
                  style: TextStyle(
                      fontSize: ScreenUtil().setSp(35) + _addingSize,
                      color: Theme.of(context).accentColor),
                  textAlign: TextAlign.start,
                ),
                Padding(padding: EdgeInsets.only(top: 5)),
                buildCategory(),
                Padding(padding: EdgeInsets.only(top: 5)),
                buildGroupCategory(),
                Padding(padding: EdgeInsets.only(top: 5)),
                buildCategoryTitles(),
                Padding(padding: EdgeInsets.only(top: 5)),
                buildTextFieldTitle(_language.address),
                TextFormField(
                  validator: validateAddress,
                  controller: addressController,
                  style: TextStyle(color: Theme.of(context).accentColor),
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    border: OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Theme.of(context).accentColor)),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  ),
                ),
                Container(
                  alignment: Alignment.centerRight,
                  child: ButtonBar(children: <Widget>[
                    FlatButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => BuildMap()),
                        ).then((value) {
                          if (value == null) return;
                          setState(() {
                            addressController.text = value;
                          });
                        });
                      },
                      textColor: Colors.blue,
                      child: Text(
                        _language.map,
                        style: TextStyle(
                            color: Theme.of(context).accentColor,
                            fontSize: ScreenUtil().setSp(35) + _addingSize),
                        textAlign: TextAlign.right,
                      ),
                    )
                  ]),
                ),
                buildTextFieldTitle(_language.cause),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Theme.of(context).accentColor,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      TextFormField(
                        validator: validateCause,
                        controller: causeController,
                        maxLines: 5,
                        style: TextStyle(color: Theme.of(context).accentColor),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        ),
                      ),
                      InkWell(
                        onTap: uploadFiles,
                        child: Container(
                          width: double.infinity,
                          padding:
                              EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                          decoration: BoxDecoration(
                            border: Border(
                              top: BorderSide(
                                  color: Theme.of(context).accentColor),
                            ),
                          ),
                          child: Row(
                            children: [
                              Image.asset('images/upload.png'),
                              SizedBox(width: ScreenUtil().setWidth(5)),
                              buildPickedImage(),
                              Text(
                                _language.addPhoto,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: HexColor("#C4C4C4"),
                                  fontSize:
                                      path == null ? 12 : 13 + _addingSize,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                FormField<bool>(
                  builder: (state) {
                    return Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Checkbox(
                                value: isCheck,
                                onChanged: (value) {
                                  setState(() {
                                    isCheck = value;
                                    state.didChange(value);
                                  });
                                }),
                            Flexible(
                                child: Text(_language.responsibility,
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                        fontSize: ScreenUtil().setSp(30) +
                                            _addingSize,
                                        color: HexColor("#407296")))),
                          ],
                        ),
                        Row(
                          children: [
                            Padding(padding: EdgeInsets.only(left: 15)),
                            Text(
                              state.errorText ?? '',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  color: Theme.of(context).errorColor,
                                  fontSize:
                                      ScreenUtil().setSp(25) + _addingSize),
                            ),
                          ],
                        )
                      ],
                    );
                  },
                  validator: (value) {
                    if (!isCheck) {
                      return languageType == 'KZ'
                          ? 'Міндетті өріс'
                          : 'Обязательное поле';
                    } else {
                      return null;
                    }
                  },
                ),
                Padding(padding: EdgeInsets.only(top: 20)),
                buildButton(),
              ],
            ),
          ));
    });
  }

  Widget buildBackButton() {
    return Center(
      child: Row(
        children: [
          MaterialButton(
            minWidth: 0,
            onPressed: () {
              applyBloc.add(LoadImageEvent());
              pageController.jumpToPage(0);
            },
            child: Image.asset(
              "images/Vector3.png",
              height: ScreenUtil().setHeight(90) + _addingSize,
              alignment: Alignment.topLeft,
            ),
          ),
          Padding(padding: EdgeInsets.all(1 + _addingSize)),
          Text(
            _language.changeCategory,
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

/////// Change text 2
  Widget buildCategoryTitles() {
    List<DropdownMenuItem> items = [];
    for (var item in categoryTitles) {
      if (widget.categoryID == 16 &&
          (groupId == null || groupId != item.groupID)) continue;
      // if (widget.categoryID != 16 &&
      //     (groupId == null || groupId != item.groupID)) continue;
      print("GROUP ID: $groupId");
      print("item GroupID: ${item.groupID}");
      items.add(
        DropdownMenuItem(
          value: item.name,
          onTap: () {
            setState(() => subcategoryID = item.id);
          },
          child: Container(
            padding: EdgeInsets.symmetric(vertical: ScreenUtil().setHeight(10)),
            child: Text(
              languageType == 'KZ' ? item.namekz : item.name,
              textAlign: TextAlign.justify,
              overflow: TextOverflow.clip,
              style: TextStyle(
                  height: ScreenUtil().setHeight(3),
                  color: Theme.of(context).accentColor,
                  fontSize: ScreenUtil().setSp(35) + _addingSize),
            ),
          ),
        ),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(padding: EdgeInsets.only(top: 5)),
        buildTextFieldTitle(_language.chooseCategoryName),
        Container(
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(horizontal: 7),
          decoration: BoxDecoration(
            border: Border.all(color: Theme.of(context).accentColor),
            borderRadius: BorderRadius.circular(5),
          ),
          child: DropdownButtonFormField(
            decoration: InputDecoration(
              enabledBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
            ),
            icon: Image.asset("images/vectordown.png"),
            // underline: Container(),
            isExpanded: true,
            value: categoryTitle,
            validator: (categoryTitle) {
              if (categoryTitle == null) {
                return languageType == 'KZ'
                    ? "Санатты таңдаңыз"
                    : "Выберите категорию";
              }
            },
            onChanged: (value) {
              setState(() {
                categoryTitle = value;
              });
            },
            items: items,
          ),
        ),
      ],
    );
  }

/////change text первая
  Widget buildGroupCategory() {
    if (categoryTitles.isNotEmpty && categoryTitles.first.groupName == null)
      return Container();
    List<DropdownMenuItem> items = [];
    String checkList = '';
    for (var item in categoryTitles) {
      if (checkList.contains('>${item.groupID}')) continue;
      print("This is ${item.groupID}");
      checkList += '>${item.groupID}';
      print("This is second $checkList");
      items.add(DropdownMenuItem(
        value: item.groupName,
        child: Container(
          padding: EdgeInsets.only(top: ScreenUtil().setHeight(10)),
          child: Text(
            languageType == 'KZ' ? item.groupNamekz : item.groupName,
            textAlign: TextAlign.justify,
            overflow: TextOverflow.clip,
            style: TextStyle(
              fontSize: ScreenUtil().setSp(35) + _addingSize,
              height: ScreenUtil().setHeight(3),
            ),
          ),
        ),
        onTap: () {
          setState(() {
            groupId = item.groupID;
          });
        },
      ));
    }
    print('buildGroupCategory: ${items.length}');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(padding: EdgeInsets.only(top: 5)),
        buildTextFieldTitle(_language.chooseCategoryName),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 7),
          decoration: BoxDecoration(
            border: Border.all(color: Theme.of(context).accentColor),
            borderRadius: BorderRadius.circular(5),
          ),
          child: DropdownButtonFormField(
            decoration: InputDecoration(
              enabledBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
            ),
            icon: Image.asset("images/vectordown.png"),
            // underline: Container(),
            isExpanded: true,
            value: groupName,
            validator: (groupName) {
              if (groupName == null) {
                return languageType == 'KZ'
                    ? "Санатты таңдаңыз"
                    : "Выберите категорию";
              }
            },
            style: TextStyle(color: Theme.of(context).accentColor),
            onChanged: (value) {
              print(value);
              setState(() {
                categoryTitle = null;
                groupName = value;
              });
            },
            items: items,
          ),
        ),
      ],
    );
  }

  Widget buildCategory() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildTextFieldTitle(_language.category),
        Container(
          width: ScreenUtil().uiWidthPx,
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          decoration: BoxDecoration(
            border: Border.all(color: Theme.of(context).accentColor),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Text(
            category,
            style: TextStyle(
                color: Theme.of(context).accentColor,
                fontSize: ScreenUtil().setSp(45) + _addingSize),
          ),
        ),
      ],
    );
  }

  Widget buildButton() {
    return ButtonTheme(
      minWidth: width,
      height: ScreenUtil().setHeight(150) + _addingSize,
      child: RaisedButton(
        child: Text(_language.applybtn,
            style: TextStyle(
                color: _btnEnabled ? Colors.white : HexColor("#999A9D"),
                fontSize: ScreenUtil().setSp(50) + _addingSize)),
        onPressed: _btnEnabled
            ? () {
                if (_formKey.currentState.validate() && isCheck == true) {
                  applyBloc.add(SendRequestEvent(
                    address: addressController.text,
                    group: groupId,
                    description: causeController.text,
                    category: widget.categoryID,
                    sub_category: subcategoryID,
                    agreement: isCheck,
                    image: files,
                  ));
                }
                if (_btnEnabled == true) {
                  setState(() => _btnEnabled = false);
                }
              }
            : null,
        disabledColor: Colors.white,
        color: HexColor("#407296"),
        shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(5.0),
            side: BorderSide(
                color: HexColor("#999A9D"), width: ScreenUtil().setWidth(4))),
      ),
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

  Widget buildPickedImage() {
    if (files.isEmpty) return Container();
    return Container(
      padding: EdgeInsets.only(right: 10), child: Text('Файл: $count'),
      // child: Image.file(
      //   File(path),
      //   width: ScreenUtil().setWidth(80) + _addingSize,
      //   height: ScreenUtil().setHeight(80) + _addingSize,
      //   fit: BoxFit.cover,
      // ),
    );
  }

  Widget buildTextFieldTitle(String title) {
    return Text(
      title,
      style: TextStyle(
          color: HexColor("#407296"),
          fontWeight: FontWeight.bold,
          fontSize: ScreenUtil().setSp(45) + _addingSize),
    );
  }
}
