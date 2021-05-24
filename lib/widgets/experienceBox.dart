import 'package:earth_quake/screens/earthQuakeInfo.dart';
import 'package:earth_quake/screens/userExperience.dart';
import 'package:flutter/material.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class ExperienceBox extends StatelessWidget {
  const ExperienceBox(
      {Key key,
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
      this.token,
      @required this.context,
      @required this.isUserExp})
      : super(key: key);

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
                        ? TextButton(
                            onPressed: () async {
                              http.Response response = await http.delete(
                                  "${FlutterConfig.get('MY_SERVER_URL')}experiences/$expId",
                                  headers: {
                                    'Content-Type': 'application/json',
                                    'Accept': 'application/json',
                                    'Authorization': 'Bearer $token',
                                  });
                              print(response.statusCode);
                              if (response.statusCode == 200) {
                                print("Success");
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        UserExperience(),
                                  ),
                                  (route) => false,
                                );
                              } else {
                                print("Error");
                              }
                            },
                            child: Icon(Icons.delete, color: Colors.white),
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
