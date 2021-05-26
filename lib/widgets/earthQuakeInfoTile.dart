import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:earth_quake/screens/earthQuakeExperience.dart';
import 'package:flutter/material.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:earth_quake/widgets/experienceSheet.dart';
import 'package:get/get.dart';
import '../sizeConfig.dart';
import '../screens/locationPage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:earth_quake/screens/earth_quakes.dart';

class EarthQuakeInfoTile extends StatefulWidget {
  EarthQuakeInfoTile(
      {this.magColour,
      this.magnitude,
      this.locDes,
      this.location,
      this.dayDate,
      this.time,
      this.urlUSGS,
      this.id,
      this.lon,
      this.lat});

  final Color magColour;
  final String magnitude;
  final String locDes;
  final String location;
  final String dayDate;
  final String time;
  final String urlUSGS;
  final String id;
  final double lon;
  final double lat;

  @override
  _EarthQuakeInfoTileState createState() => _EarthQuakeInfoTileState();
}

class _EarthQuakeInfoTileState extends State<EarthQuakeInfoTile> {
  String errorMsg = "";
  String exp = '';
  bool isLoggedIn = false;
  String uEmail = "";
  String uName = "";
  String uPassword = "";

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: getProportionateScreenHeight(40.0),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.edit,
                  color: widget.magColour,
                ),
                SizedBox(
                  width: getProportionateScreenWidth(10.0),
                ),
                TextButton(
                  onPressed: () async {
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    var email = prefs.getString("email");
                    var id = prefs.getString("id");
                    var token = prefs.getString("token");
                    var name = prefs.getString("username");

                    isLoggedIn =
                        await isLoggedInAndAuth(email, id, token, name);

                    if (isLoggedIn) {
                      Scaffold.of(context).showBottomSheet(
                        (context) {
                          return ExperienceSheet(
                              isEdit: false,
                              userName: name,
                              experience: exp,
                              earthQuakeId: widget.id,
                              location: widget.location,
                              userId: id,
                              link: widget.urlUSGS,
                              dayDate: widget.dayDate,
                              time: widget.time,
                              magColor: widget.magColour,
                              mag: widget.magnitude,
                              lat: widget.lat,
                              lon: widget.lon,
                              locDes: widget.locDes);
                        },
                        elevation: 20.0,
                      );
                    } else {
                      return _loginAlert(context);
                    }
                  },
                  child: Text(
                    "Did you feel It? Share here",
                    style: TextStyle(
                        color: widget.magColour,
                        fontSize: getProportionateScreenHeight(20.0)),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: getProportionateScreenHeight(40.0),
              width: getProportionateScreenWidth(200.0),
              child: Divider(
                color: Colors.grey,
                indent: getProportionateScreenWidth(40.0),
                endIndent: getProportionateScreenWidth(40.0),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.receipt_sharp,
                  color: widget.magColour,
                ),
                SizedBox(
                  width: getProportionateScreenWidth(10.0),
                ),
                TextButton(
                  onPressed: () async {
                    Get.to(EarthQuakeExperience(),
                        arguments: [widget.id, widget.magColour]);
                  },
                  child: Text(
                    "How others felt It?",
                    style: TextStyle(
                        color: widget.magColour,
                        fontSize: getProportionateScreenHeight(20.0)),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: getProportionateScreenHeight(40.0),
              width: getProportionateScreenWidth(200.0),
              child: Divider(
                indent: getProportionateScreenWidth(40.0),
                endIndent: getProportionateScreenWidth(40.0),
                color: Colors.grey,
              ),
            ),
            CircleAvatar(
              radius: getProportionateScreenWidth(70.0),
              backgroundColor: widget.magColour,
              child: Text(
                widget.magnitude,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: getProportionateScreenHeight(50.0),
                ),
              ),
            ),
            SizedBox(
              height: getProportionateScreenHeight(20.0),
            ),
            Text(
              widget.locDes,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: getProportionateScreenHeight(20.0)),
            ),
            Text(
              widget.location,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: getProportionateScreenHeight(20.0)),
            ),
            SizedBox(
              height: getProportionateScreenHeight(40.0),
              width: getProportionateScreenWidth(200.0),
              child: Divider(
                indent: getProportionateScreenWidth(40.0),
                endIndent: getProportionateScreenWidth(40.0),
                color: Colors.grey,
              ),
            ),
            Text(
              widget.dayDate,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.black54,
                  fontSize: getProportionateScreenHeight(20.0)),
            ),
            Text(
              widget.time,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.black54,
                  fontSize: getProportionateScreenHeight(20.0)),
            ),
            SizedBox(
              height: getProportionateScreenHeight(40.0),
              width: getProportionateScreenWidth(200.0),
              child: Divider(
                indent: getProportionateScreenWidth(40.0),
                endIndent: getProportionateScreenWidth(40.0),
                color: Colors.grey,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.location_on_outlined,
                  color: widget.magColour,
                  size: getProportionateScreenHeight(25.0),
                ),
                SizedBox(
                  width: getProportionateScreenWidth(5.0),
                ),
                TextButton(
                  onPressed: () {
                    Get.to(LocationPage(), arguments: [widget.lon, widget.lat]);
                  },
                  child: Text(
                    "View Location",
                    style: TextStyle(
                        fontSize: getProportionateScreenHeight(20.0),
                        color: widget.magColour),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: getProportionateScreenHeight(40.0),
              width: getProportionateScreenWidth(200.0),
              child: Divider(
                indent: getProportionateScreenWidth(40.0),
                endIndent: getProportionateScreenWidth(40.0),
                color: Colors.grey,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.near_me,
                  size: getProportionateScreenHeight(30.0),
                  color: widget.magColour,
                ),
                SizedBox(
                  width: getProportionateScreenWidth(10.0),
                ),
                TextButton(
                  onPressed: () async {
                    var url = widget.urlUSGS;
                    if (await canLaunch(url)) {
                      await launch(url);
                    } else {
                      throw 'Could not launch $url';
                    }
                  },
                  child: Text(
                    "More Information",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: getProportionateScreenHeight(15.0),
                        color: widget.magColour),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: getProportionateScreenHeight(20.0),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> isLoggedInAndAuth(
      String email, String id, String token, String name) async {
    http.Response response = await http
        .get(FlutterConfig.get('MY_SERVER_URL') + 'user/$id', headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });
    if (response.statusCode == 200 && email != null && name != null) {
      return true;
    } else {
      return false;
    }
  }

  _loginAlert(context) {
    Alert(
      style: AlertStyle(titleStyle: TextStyle(color: widget.magColour)),
      context: context,
      title: "Please Login",
      content: Column(
        children: <Widget>[
          TextField(
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
                labelStyle: TextStyle(color: widget.magColour),
                icon: Icon(
                  Icons.email,
                  color: widget.magColour,
                ),
                labelText: 'Email',
                hintText: "Enter your Email address"),
            onChanged: (value) {
              uEmail = value;
            },
          ),
          TextField(
            obscureText: true,
            decoration: InputDecoration(
                icon: Icon(Icons.lock, color: widget.magColour),
                labelStyle: TextStyle(color: widget.magColour),
                labelText: 'Password',
                hintText: "Enter your Password"),
            onChanged: (value) {
              uPassword = value;
            },
          ),
          Text(
            errorMsg,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.red, fontSize: 15.0),
          ),
          SizedBox(
            height: getProportionateScreenHeight(12.0),
          ),
          TextButton(
            onPressed: () {
              return _signupAlert(context);
            },
            child: Text(
              "New user? SignUp Now!",
              style: TextStyle(
                color: widget.magColour,
              ),
            ),
          ),
        ],
      ),
      buttons: [
        DialogButton(
          color: widget.magColour,
          child: Text(
            "LOGIN",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          onPressed: () async {
            var res = await http.post(
              FlutterConfig.get('MY_SERVER_URL') + 'user/login',
              headers: <String, String>{
                'Content-Type': 'application/json; charset=UTF-8',
              },
              body: jsonEncode({'email': uEmail, 'password': uPassword}),
            );
            if (res.statusCode == 404) {
              setState(() {
                errorMsg = "No user found!";
              });
            } else if (res.statusCode == 200) {
              var data = jsonDecode(res.body);
              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.setString("email", uEmail);
              prefs.setString("id", data["user"]["_id"]);
              prefs.setString("token", data["token"]);
              prefs.setString("username", data["user"]["name"]);
              setState(() {
                isLoggedIn = true;
              });
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => EarthQuake(),
                ),
                (route) => false,
              );
            } else {
              setState(() {
                errorMsg = "Invalid Email or Password!";
              });
            }
          },
        ),
      ],
    ).show();
  }

  _signupAlert(context) {
    Alert(
      style: AlertStyle(titleStyle: TextStyle(color: widget.magColour)),
      context: context,
      title: "Create an Account",
      content: Column(
        children: <Widget>[
          TextField(
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
                labelStyle: TextStyle(color: widget.magColour),
                icon: Icon(
                  Icons.account_circle,
                  color: widget.magColour,
                ),
                labelText: 'Username',
                hintText: "Enter your Username"),
            onChanged: (value) {
              uName = value;
            },
          ),
          TextField(
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
                icon: Icon(Icons.email, color: widget.magColour),
                labelStyle: TextStyle(color: widget.magColour),
                labelText: 'Email',
                hintText: "Enter your Email address"),
            onChanged: (value) {
              uEmail = value;
            },
          ),
          TextField(
            obscureText: true,
            decoration: InputDecoration(
                icon: Icon(Icons.lock, color: widget.magColour),
                labelStyle: TextStyle(color: widget.magColour),
                labelText: 'Password',
                hintText: "Enter your Password"),
            onChanged: (value) {
              uPassword = value;
            },
          ),
        ],
      ),
      buttons: [
        DialogButton(
          color: widget.magColour,
          child: Text(
            "SignUp",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          onPressed: () async {
            http.Response response = await http.post(
              FlutterConfig.get('MY_SERVER_URL') + 'user/signup',
              headers: <String, String>{
                'Content-Type': 'application/json; charset=UTF-8',
              },
              body: jsonEncode(
                  {'email': uEmail, 'name': uName, 'password': uPassword}),
            );
            if (response.statusCode == 201) {
              print("Success!");
              var res = await http.post(
                FlutterConfig.get('MY_SERVER_URL') + 'user/login',
                headers: <String, String>{
                  'Content-Type': 'application/json; charset=UTF-8',
                },
                body: jsonEncode({'email': uEmail, 'password': uPassword}),
              );
              if (res.statusCode == 200) {
                var data = jsonDecode(res.body);
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.setString("email", uEmail);
                prefs.setString("id", data["user"]["_id"]);
                prefs.setString("token", data['token']);
                prefs.setString("username", data["user"]["name"]);
                setState(() {
                  isLoggedIn = true;
                });
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => EarthQuake(),
                  ),
                  (route) => false,
                );
              }
            }
          },
        ),
      ],
    ).show();
  }
}
