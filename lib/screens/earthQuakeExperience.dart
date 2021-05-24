import 'dart:convert';
import 'package:earth_quake/widgets/experienceBox.dart';
import 'package:flutter/material.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:modal_progress_hud/modal_progress_hud.dart';

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

      if (data.length == 0) {
        setState(() {
          experiences.add(SizedBox(
            height: 80.0,
          ));
          experiences.add(new Image.asset(
            "images/no_experience.jpg",
          ));
          experiences.add(SizedBox(
            height: 30.0,
          ));
          experiences.add(Text(
            "No Experience Shared Yet!",
            style: TextStyle(fontSize: 20.0),
          ));
        });
      } else {
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
              ExperienceBox(
                colour: colour,
                name: name,
                location: location,
                exp: exp,
                earthquakeId: earthquakeId,
                magnitudeValue: magnitudeValue,
                description: description,
                loc: loc,
                dayInfo: dayInfo,
                timeInfo: timeInfo,
                USGSurl: USGSurl,
                eqId: eqId,
                longitude: longitude,
                latitude: latitude,
                expId: expId,
                context: context,
                isUserExp: false,
              ),
            );
          }
        });
        print(jsonDecode(response.body));
      }
    } else {
      print(response.statusCode);
    }
    showSpinner = false;
  }
}
