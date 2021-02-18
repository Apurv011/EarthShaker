import 'package:earth_quake/controller/firestoreController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BottomSheetController {
  void openBottomSheet(
      {String name,
      String exp,
      String id,
      String location,
      String dayDate,
      String time,
      String magColour}) {
    Get.bottomSheet(
      Container(
        height: 900.0,
        color: Colors.white,
        child: Column(
          children: [
            FlatButton(
              onPressed: () {
                FireStoreController().addExperience(name, exp, id);
                FireStoreController()
                    .addToSaved(name, exp, location, dayDate, time, magColour);
              },
              padding: EdgeInsets.only(right: 350.0),
              child: Text(
                "Done",
                style: TextStyle(
                  color: Colors.green,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: TextField(
                onChanged: (nameTyped) {
                  name = nameTyped;
                },
                decoration: InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black38),
                    ),
                    labelText: "Name",
                    hintText: 'Enter your name here'),
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: TextField(
                  onChanged: (experience) {
                    exp = experience;
                  },
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Share your Experience here'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
