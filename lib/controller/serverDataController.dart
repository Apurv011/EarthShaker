import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class ServerDataController {
  Future<void> addExperience(
      {String url,
      String earthQuakeId,
      String userId,
      String userName,
      String experience,
      String link,
      String location,
      String dayDate,
      String time,
      String locDes,
      String mag,
      Color magColor,
      double lat,
      double lon}) async {
    http.Response response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'earthQuakeId': earthQuakeId,
        'userId': userId,
        'userName': userName,
        'experience': experience,
        'link': link,
        'location': location,
        'dayDate': dayDate,
        'time': time,
        'locDes': locDes,
        'mag': mag,
        'magColor': magColor.toString(),
        'lat': lat,
        'lon': lon
      }),
    );
    print(response.statusCode);
  }
}
