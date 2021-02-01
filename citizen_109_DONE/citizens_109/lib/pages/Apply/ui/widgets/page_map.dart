import 'package:citizens01/pages/Apply/bloc/apply_bloc.dart';
import 'package:citizens01/pages/Apply/bloc/apply_event.dart';
import 'package:citizens01/pages/Apply/bloc/apply_state.dart';
import 'package:citizens01/pages/Language/bloc/language_bloc.dart';
import 'package:citizens01/pages/Language/model/language_apply_page.dart';
import 'package:citizens01/tablet&phone/device_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:latlong/latlong.dart';

class BuildMap extends StatefulWidget {
  @override
  _BuildMapState createState() => _BuildMapState();
}

class _BuildMapState extends State<BuildMap> {
  MapControlBloc mapBloc;
  MapController mapController = new MapController();
  List<Marker> markers = [];
  String locationName;
  LanguageApplyPage _language;
  double width;

  double _addingSize = 0;

  @override
  void initState() {
    mapBloc = MapControlBloc();
    final device = BlocProvider.of<DeviceBloc>(context).state;
    if (device.isTablet) _addingSize = ScreenUtil().setWidth(400);
    super.initState();
  }

  void onSelect() {
    Navigator.pop(context, locationName);
  }

  void onTapMap(LatLng latLng) {
    mapBloc.add(GetLocationName(latLng));
    setState(() {
      markers = [
        new Marker(
          width: 45.0,
          height: 60.0,
          point: latLng,
          builder: (ctx) => Center(
            child: ConstrainedBox(
              constraints: new BoxConstraints.expand(),
              child: Icon(
                Icons.location_on,
                color: Colors.deepOrange,
                size: 50,
              ),
            ),
          ),
        ),
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LanguageBloc, LanguageState>(builder: (context, state) {
      if (state is FetchedLanguageState) {
        _language = state.language.languageApplyPage;
      }
      return Scaffold(
        body: Stack(
          children: [
            new FlutterMap(
              mapController: mapController,
              options: new MapOptions(
                center: new LatLng(50.2877, 57.1873),
                zoom: 13.0,
                minZoom: 13.0,
                maxZoom: 18.0,
                onTap: onTapMap,
              ),
              layers: [
                new TileLayerOptions(
                  urlTemplate:
                      "https://maps.usmcontrol.com/osm/{z}/{x}/{y}.png",
                  subdomains: ['a', 'b', 'c'],
                ),
                new MarkerLayerOptions(markers: markers),
              ],
            ),
            buildButton(),
          ],
        ),
      );
    });
  }

  Widget buildButton() {
    if (markers.isEmpty) return Container();
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: ScreenUtil().setWidth(350) + _addingSize,
          ),
          child: BlocBuilder(
            cubit: mapBloc,
            builder: (context, state) {
              Function onPressed;
              Widget child = Container();
              if (state is FetchedMapState) {
                onPressed = onSelect;
                locationName = state.name;
                child = Text(_language.mapbtn);
              }
              if (state is LoadingMapState) {
                child = CircularProgressIndicator();
              }
              return Container(
                width: ScreenUtil().setWidth(500),
                height: ScreenUtil().setHeight(100),
                margin: EdgeInsets.only(bottom: 20),
                child: RaisedButton(
                  onPressed: onPressed,
                  color: HexColor('#4CADC7'),
                  disabledColor: Colors.white,
                  child: Container(
                    width: ScreenUtil().uiWidthPx,
                    alignment: Alignment.center,
                    child: child,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
