import 'dart:io';

import 'package:citizens01/pages/Apply/models/apply_categories.dart';
import 'package:citizens01/pages/Apply/models/apply_images.dart';

import 'package:http/http.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:latlong/latlong.dart';

class ApplyProvider {
  Future<String> getLocationName(LatLng latLng) async {
    Response response;
    try {
      response = await get(
        'https://nominatim.openstreetmap.org/reverse?format=jsonv2&lat=${latLng.latitude}&lon=${latLng.longitude}',
      );
    } catch (e) {
      return null;
    }
    if (response.statusCode != 200) return null;
    Map object = convert.json.decode(convert.utf8.decode(response.bodyBytes));
    return object['display_name'];
  }

  Future<List<ApplyImages>> getApplyImages() async {
    Response response;
    print("GetImages");
    response = await http.get("https://ccc.akt.kz/portal/api/categories/",
        headers: {'Content-Type': 'application/json'});
    print(response.statusCode);
    if (response.statusCode == 200) {
      Map object = convert.jsonDecode(convert.utf8.decode(response.bodyBytes));
      print("=====>>>> $object");
      return ApplyImages.parseList(object['dat']);
    } else {
      throw "Попробуйте позже";
    }
  }

  Future<List<ApplyCategories>> getApplyCategories(int imageID) async {
    Response response;
    print("GetCategories");
    response = await http.get(
        "https://ccc.akt.kz/portal/api/sub_categories/$imageID",
        headers: {'Content-Type': 'application/json'});
    print(response.statusCode);
    if (response.statusCode == 200) {
      Map object = convert.jsonDecode(convert.utf8.decode(response.bodyBytes));
      print(object);
      return ApplyCategories.parseList(object['dat']);
    } else {
      throw "Попробуйте позже";
    }
  }

  Future<void> getSendRequest(
    category,
    sub_category,
    address,
    description,
    last_name,
    first_name,
    phone,
    agreement,
    group,
    List<File> images,
  ) async {
    var url = "https://ccc.akt.kz/portal/api/application/";
    var request = new http.MultipartRequest("post", Uri.parse(url));
    request.headers["Content-Type"] = "application/x-www-form-urlencoded";
    request.fields['category'] = category.toString();
    request.fields['sub_category'] = sub_category.toString();
    request.fields['address'] = address;
    request.fields['description'] = description;
    request.fields['last_name'] = last_name;
    request.fields['first_name'] = first_name;
    request.fields['phone'] = phone;
    request.fields['agreement'] = agreement.toString();
    if (group != null) request.fields['group'] = group.toString();
    for (var item in images) {
      request.files.add(await MultipartFile.fromPath('image', item.path));
    }

    var stream = await request.send();
    var response = await Response.fromStream(stream);
    print(response.body);

    if (response.statusCode == 200) {
      Map object = convert.jsonDecode(convert.utf8.decode(response.bodyBytes));
      print(object);
      if (object['status'] == 400) throw object['error'];
    }
  }
}
