import 'dart:convert';
import 'package:earth_quake/widgets/experienceBox.dart';
import 'package:flutter/material.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:http/http.dart' as http;

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
      backgroundColor: Colors.white,
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
          for (int i = data["count"] - 1; i >= 0; i--) {
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
