import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:url_launcher/url_launcher.dart';
import 'earthQuakeInfo.dart';

class EarthQuakeExperience extends StatefulWidget {
  @override
  _EarthQuakeExperienceState createState() => _EarthQuakeExperienceState();
}

class _EarthQuakeExperienceState extends State<EarthQuakeExperience> {
  String expId;
  String name = 'name';
  String exp = 'Exp';
  String location = "location";
  String magColour = "colour";
  String dayDate;
  String time;
  String earthquakeId;
  String infoLink;
  String locDes;
  String mag;
  double lat;
  double lon;
  List<Widget> experiences = [];
  bool showSpinner = true;

  @override
  void initState() {
    super.initState();
    getExperiences();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Experiences",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xFFC03823),
      ),
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Container(
          child: ListView(children: [
            Column(
              children: experiences,
            ),
          ]),
        ),
      ),
    );
  }

  Future<void> getExperiences() async {
    http.Response response = await http.get(
        "${FlutterConfig.get('MY_SERVER_URL')}experiences/earthquakeexp/${Get.arguments[0]}");

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);

      setState(() {
        for (int i = 0; i < data.length; i++) {
          expId = data[i]['_id'];
          exp = data[i]['experience'];
          name = data[i]['userName'];
          location = data[i]['location'];
          dayDate = data[i]['dayDate'];
          time = data[i]['time'];
          magColour = data[i]['magColor'];
          infoLink = data[i]['link'];
          earthquakeId = data[i]['earthQuakeId'];
          lat = data[i]['lat'];
          lon = data[i]['lon'];
          locDes = data[i]['locDes'];
          mag = data[i]['mag'];

          String valueString = magColour.split('(0x')[1].split(')')[0];
          int value = int.parse(valueString, radix: 16);
          Color colour = new Color(value);

          String magnitudeValue = mag;
          String description = locDes;
          String loc = location;
          String dayInfo = dayDate;
          String timeInfo = time;
          String USGSurl = infoLink;
          String eqId = earthquakeId;
          double longitude = lon;
          double latitude = lat;

          experiences.add(
            Padding(
              padding: EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Material(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      elevation: 5.0,
                      color: colour,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Author: " + name,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 15.0,
                              ),
                            ),
                            Text(
                              "Location: " + location,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 15.0,
                              ),
                            ),
                            SizedBox(
                              height: 12.0,
                              child: Divider(
                                color: Colors.black38,
                                endIndent: 20.0,
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 20.0),
                              child: Text(
                                exp,
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18.0,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 12.0,
                              child: Divider(
                                color: Colors.black38,
                                endIndent: 20.0,
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextButton(
                                  onPressed: () async {
                                    print(earthquakeId);
                                    Get.to(EarthQuakeInfoPage(), arguments: [
                                      colour,
                                      magnitudeValue,
                                      description,
                                      loc,
                                      dayInfo,
                                      timeInfo,
                                      USGSurl,
                                      eqId,
                                      longitude,
                                      latitude
                                    ]);
                                  },
                                  child: Text(
                                    "About this EarthQuake",
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 12.0),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    var url = USGSurl;
                                    if (await canLaunch(url)) {
                                      await launch(url);
                                    } else {
                                      throw 'Could not launch $url';
                                    }
                                  },
                                  child: Text(
                                    "EarthQuake Details",
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 12.0),
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                ],
              ),
            ),
          );
        }
      });
      print(jsonDecode(response.body));
    } else {
      print(response.statusCode);
    }
    showSpinner = false;

    // await for (var snapshot in FirebaseFirestore.instance
    //     .collection(Get.arguments[0])
    //     .snapshots()) {
    //   setState(() {
    //     for (var experience in snapshot.docs) {
    //       name = experience.data()['name'];
    //       exp = experience.data()['exp'];
    //
    //       experiences.add(
    //         new ExperienceBubble(
    //           name: name,
    //           exp: exp,
    //           colour: Get.arguments[1],
    //         ),
    //       );
    //     }
    //     showSpinner = false;
    //   });
    // }
  }
}
