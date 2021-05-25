import 'package:earth_quake/controller/serverDataController.dart';
import 'package:earth_quake/screens/userExperience.dart';
import 'package:earth_quake/sizeConfig.dart';
import 'package:flutter/material.dart';
import 'package:flutter_config/flutter_config.dart';

// ignore: must_be_immutable
class ExperienceSheet extends StatelessWidget {
  bool isEdit;
  String userName;
  String experience;
  String earthQuakeId;
  String location;
  String userId;
  String link;
  String dayDate;
  String time;
  Color magColor;
  String mag;
  double lat;
  double lon;
  String locDes;
  String token;
  String experienceId;

  ExperienceSheet(
      {this.isEdit,
      this.userName,
      this.experience,
      this.earthQuakeId,
      this.location,
      this.userId,
      this.link,
      this.dayDate,
      this.time,
      this.magColor,
      this.mag,
      this.lat,
      this.lon,
      this.token,
      this.experienceId,
      this.locDes});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(
                top: getProportionateScreenHeight(20.0),
                left: getProportionateScreenWidth(20.0),
                right: getProportionateScreenWidth(20.0)),
            child: !isEdit
                ? Text(
                    "Hello, $userName! Feel free to share your experience!",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: getProportionateScreenHeight(14.0)),
                  )
                : SizedBox(height: 0.0),
          ),
          !isEdit
              ? Divider(
                  thickness: 1.0,
                  color: Colors.black38,
                  indent: getProportionateScreenWidth(20.0),
                  endIndent: getProportionateScreenWidth(20.0),
                )
              : SizedBox(height: 0.0),
          Expanded(
            flex: 2,
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: getProportionateScreenWidth(20.0)),
              child: TextField(
                onChanged: (exp) {
                  experience = exp;
                },
                keyboardType: TextInputType.multiline,
                maxLines: null,
                decoration: InputDecoration(
                    border: InputBorder.none, hintText: 'Write here'),
              ),
            ),
          ),
          SizedBox(
            height: getProportionateScreenHeight(40.0),
            width: getProportionateScreenWidth(240.0),
            child: TextButton(
              style: TextButton.styleFrom(backgroundColor: Colors.green),
              onPressed: () async {
                if (!isEdit) {
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
                  Navigator.pop(context);
                } else {
                  var res = await ServerDataController().editExperience(
                      url: FlutterConfig.get('MY_SERVER_URL') +
                          'experiences/$experienceId',
                      experience: experience,
                      token: token);
                  if (res) {
                    Navigator.pop(context);
                    print("Success");
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (BuildContext context) =>
                    //         UserExperience(),
                    //   ),
                    // );
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => UserExperience(),
                      ),
                    );
                  } else {
                    print("Error!");
                  }
                }
              },
              child: Text(
                "Done",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: getProportionateScreenHeight(18.0)),
              ),
            ),
          ),
          SizedBox(
            height: getProportionateScreenHeight(40.0),
          )
        ],
      ),
    );
  }
}
