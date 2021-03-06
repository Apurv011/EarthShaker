import 'package:earth_quake/widgets/experienceSheet.dart';
import 'package:earth_quake/controller/serverDataController.dart';
import 'package:earth_quake/screens/earthQuakeInfo.dart';
import 'package:earth_quake/screens/userExperience.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:get/get.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:url_launcher/url_launcher.dart';

class ExperienceBox extends StatelessWidget {
  const ExperienceBox(
      {Key key,
      this.userId,
      @required this.colour,
      @required this.name,
      @required this.location,
      @required this.exp,
      @required this.earthquakeId,
      @required this.magnitudeValue,
      @required this.description,
      @required this.loc,
      @required this.dayInfo,
      @required this.timeInfo,
      @required this.USGSurl,
      @required this.eqId,
      @required this.longitude,
      @required this.latitude,
      @required this.expId,
      @required this.context,
      @required this.isUserExp,
      this.token})
      : super(key: key);

  final String userId;
  final Color colour;
  final String name;
  final String location;
  final String exp;
  final String earthquakeId;
  final String magnitudeValue;
  final String description;
  final String loc;
  final String dayInfo;
  final String timeInfo;
  final String USGSurl;
  final String eqId;
  final double longitude;
  final double latitude;
  final String expId;
  final String token;
  final BuildContext context;
  final bool isUserExp;

  @override
  Widget build(BuildContext context) {
    return Padding(
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
                padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
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
                      padding: const EdgeInsets.symmetric(vertical: 20.0),
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
                            style:
                                TextStyle(color: Colors.black, fontSize: 12.0),
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
                            style:
                                TextStyle(color: Colors.black, fontSize: 12.0),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 12.0,
                      child: Divider(
                        color: Colors.black38,
                        endIndent: 20.0,
                      ),
                    ),
                    isUserExp
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextButton(
                                onPressed: () {
                                  Scaffold.of(context).showBottomSheet(
                                    (context) {
                                      return ExperienceSheet(
                                          isEdit: true,
                                          token: token,
                                          experienceId: expId,
                                          userName: name,
                                          experience: exp,
                                          earthQuakeId: earthquakeId,
                                          location: location,
                                          userId: userId,
                                          link: USGSurl,
                                          dayDate: dayInfo,
                                          time: timeInfo,
                                          magColor: colour,
                                          mag: magnitudeValue,
                                          lat: latitude,
                                          lon: longitude,
                                          locDes: description);
                                    },
                                  );
                                },
                                child: Icon(Icons.edit, color: Colors.white),
                              ),
                              TextButton(
                                onPressed: () async {
                                  return Alert(
                                    context: context,
                                    title: "Delete this Experience?",
                                    buttons: [
                                      DialogButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        color: Colors.green,
                                        child: Text(
                                          "Cancel",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                      DialogButton(
                                        onPressed: () async {
                                          var response =
                                              await ServerDataController()
                                                  .deleteExperience(
                                                      url:
                                                          "${FlutterConfig.get('MY_SERVER_URL')}experiences/$expId",
                                                      token: token);
                                          Navigator.pop(context);
                                          if (response) {
                                            print("Success");
                                            Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                builder:
                                                    (BuildContext context) =>
                                                        UserExperience(),
                                              ),
                                            );
                                          } else {
                                            print("Error");
                                          }
                                        },
                                        color: Colors.red,
                                        child: Text(
                                          "Delete",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ],
                                  ).show();
                                },
                                child: Icon(Icons.delete, color: Colors.white),
                              ),
                            ],
                          )
                        : SizedBox(height: 0.0),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
