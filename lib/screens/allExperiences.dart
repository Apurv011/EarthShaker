import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'earthQuakeInfo.dart';

class AllExperiences extends StatefulWidget {
  @override
  _AllExperiencesState createState() => _AllExperiencesState();
}

class _AllExperiencesState extends State<AllExperiences> {
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
    http.Response response =
        await http.get("${FlutterConfig.get('MY_SERVER_URL')}experiences");
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);

      setState(() {
        for (int i = 0; i < data["count"]; i++) {
          expId = data['experiences'][i]['_id'];
          exp = data['experiences'][i]['experience'];
          name = data['experiences'][i]['userName'];
          location = data['experiences'][i]['location'];
          dayDate = data['experiences'][i]['dayDate'];
          time = data['experiences'][i]['time'];
          magColour = data['experiences'][i]['magColor'];
          infoLink = data['experiences'][i]['link'];
          earthquakeId = data['experiences'][i]['earthQuakeId'];
          lat = data['experiences'][i]['lat'];
          lon = data['experiences'][i]['lon'];
          locDes = data['experiences'][i]['locDes'];
          mag = data['experiences'][i]['mag'];

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
  }
}
