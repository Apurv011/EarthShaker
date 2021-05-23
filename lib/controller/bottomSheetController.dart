import 'package:earth_quake/controller/serverDataController.dart';
import 'package:flutter/material.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:get/get.dart';

class BottomSheetController {
  void openBottomSheet(
      {String earthQuakeId,
      String userName,
      String userId,
      String experience,
      String link,
      String location,
      String dayDate,
      String time,
      Color magColor,
      String locDes,
      double lat,
      double lon,
      String mag}) {
    Get.bottomSheet(
      Container(
        height: 900.0,
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextButton(
              onPressed: () {
                ServerDataController().addExperience(
                    url: FlutterConfig.get('MY_SERVER_URL') + 'experiences',
                    earthQuakeId: earthQuakeId,
                    userName: userName,
                    userId: userId,
                    experience: experience,
                    link: link,
                    location: location,
                    dayDate: dayDate,
                    time: time,
                    magColor: magColor,
                    locDes: locDes,
                    mag: mag,
                    lat: lat,
                    lon: lon);
                // ServerDataController()
                //     .addToSaved(name, exp, location, dayDate, time, magColour);
              },
              child: Text(
                "Done",
                style: TextStyle(color: Colors.green, fontSize: 18.0),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                userName,
                style: TextStyle(color: Colors.black, fontSize: 15.0),
              ),
            ),
            Divider(
              thickness: 1.0,
              color: Colors.black38,
              indent: 10.0,
              endIndent: 10.0,
            ),
            SizedBox(
              height: 15.0,
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: TextField(
                  onChanged: (exp) {
                    experience = exp;
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
