import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:earth_quake/model/earthQuakeInfoTile.dart';

class EarthQuakeInfoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'EarthShaker',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Color(0xFFC03823),
      ),
      body: EarthQuakeInfoTile(
          magColour: Get.arguments[0],
          magnitude: Get.arguments[1],
          locDes: Get.arguments[2],
          location: Get.arguments[3],
          dayDate: Get.arguments[4],
          time: Get.arguments[5],
          urlUSGS: Get.arguments[6],
          id: Get.arguments[7]),
    );
  }
}
