import 'package:earth_quake/screens/earthQuakeExperience.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:earth_quake/controller/bottomSheetController.dart';
import 'package:get/get.dart';

class EarthQuakeInfoTile extends StatelessWidget {
  EarthQuakeInfoTile(
      {this.magColour,
      this.magnitude,
      this.locDes,
      this.location,
      this.dayDate,
      this.time,
      this.urlUSGS,
      this.id});

  final Color magColour;
  final String magnitude;
  final String locDes;
  final String location;
  final String dayDate;
  final String time;
  final String urlUSGS;
  final String id;

  String name = '';
  String exp = '';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FlatButton(
              onPressed: () {
                BottomSheetController().openBottomSheet(
                    name: name,
                    exp: exp,
                    id: id,
                    location: location,
                    dayDate: dayDate,
                    time: time,
                    magColour: magColour.toString());
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.edit,
                    color: magColour,
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  Text(
                    "Did you feel It? Share here",
                    style: TextStyle(color: magColour, fontSize: 20.0),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 40.0,
              width: 200.0,
              child: Divider(
                color: Colors.grey,
              ),
            ),
            FlatButton(
              onPressed: () {
                Get.to(EarthQuakeExperience(), arguments: [id, magColour]);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.receipt_sharp,
                    color: magColour,
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  Text(
                    "How others felt It?",
                    style: TextStyle(color: magColour, fontSize: 20.0),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 40.0,
              width: 200.0,
              child: Divider(
                color: Colors.grey,
              ),
            ),
            CircleAvatar(
              radius: 70.0,
              backgroundColor: magColour,
              child: Text(
                magnitude,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 50.0,
                ),
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            Text(
              locDes,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black, fontSize: 20.0),
            ),
            Text(
              location,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black, fontSize: 20.0),
            ),
            SizedBox(
              height: 40.0,
              width: 200.0,
              child: Divider(
                color: Colors.grey,
              ),
            ),
            Text(
              dayDate,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black54, fontSize: 20.0),
            ),
            Text(
              time,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black54, fontSize: 20.0),
            ),
            SizedBox(
              height: 40.0,
              width: 200.0,
              child: Divider(
                color: Colors.grey,
              ),
            ),
            FlatButton(
              onPressed: () async {
                var url = urlUSGS;
                if (await canLaunch(url)) {
                  await launch(url);
                } else {
                  throw 'Could not launch $url';
                }
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.near_me,
                    size: 30.0,
                    color: magColour,
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  Text(
                    "More Information",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 15.0, color: magColour),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
