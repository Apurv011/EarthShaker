import 'dart:convert';
import 'package:earth_quake/screens/userExperience.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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

  Future<bool> editExperience({
    String url,
    String experience,
    String token,
  }) async {
    http.Response response = await http.patch(url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'experience': experience,
        }));
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> deleteExperience({String url, String token}) async {
    http.Response response = await http.delete(url, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });
    print(response.statusCode);
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}
