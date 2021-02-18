import 'package:earth_quake/controller/earthDataController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'allExperiences.dart';

class EarthQuake extends StatelessWidget {
  final earthQuakeDataController = Get.put(EarthQuakeDataController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFC03823),
        title: Text(
          'EarthShaker',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: PopupMenuButton(itemBuilder: (context) {
              return [
                PopupMenuItem(
                  value: 1,
                  child: FlatButton(
                    onPressed: () {
                      Get.to(AllExperiences());
                    },
                    child: Text(
                      "All Experiences",
                    ),
                  ),
                ),
              ];
            }),
          ),
        ],
      ),
      body: GetX<EarthQuakeDataController>(
          init: EarthQuakeDataController(),
          builder: (controller) {
            return ModalProgressHUD(
              inAsyncCall: controller.showSpinner.value,
              child: Container(
                  child: ListView(
                children: [
                  Column(
                    children: controller.earthQuakeTiles,
                  ),
                ],
              )),
            );
          }),
    );
  }
}
