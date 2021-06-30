import 'package:earth_quake/screens/userExperience.dart';
import 'package:earth_quake/sizeConfig.dart';
import 'package:earth_quake/controller/dateSelectionController.dart';
import 'package:flag/flag.dart';
import 'package:earth_quake/widgets/earthQuakeTile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../earthQuakeData.dart';
import '../controller/networking.dart';
import 'allExperiences.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:earth_quake/locationData.dart';
import 'package:http/http.dart' as http;

class EarthQuake extends StatefulWidget {
  @override
  _EarthQuakeState createState() => _EarthQuakeState();
}

class _EarthQuakeState extends State<EarthQuake> {
  var fixedUrl = FlutterConfig.get('SERVER_URL');

  List<Widget> earthQuakeTiles = [];
  List<Widget> drawerItems = [];

  var url = "";

  var magnitude = "0.0";

  var location = "Location";

  var locDes = "Description";

  var dayDate = "Day and Date";

  var time = "Time";

  var showSpinner = true;

  var id = "";

  var lat = 0.0;

  var lon = 0.0;

  bool isLoggedIn = false;

  double lamin = 0.0;
  double lomin = 0.0;
  double lamax = 0.0;
  double lomax = 0.0;

  String startDate = "";
  String endDate = "";
  DateTime start;

  String sortBy = "";

  @override
  // ignore: missing_return
  Future<void> initState() {
    super.initState();
    updateUI();
    drawerItems.add(
      Padding(
        padding: EdgeInsets.all(40.0),
        child: Column(
          children: [
            CircleAvatar(
              radius: 60.0,
              backgroundImage: AssetImage("images/bg.png"),
            ),
            SizedBox(height: 20.0),
            Text(
              'Select EarthQuakes near Countries',
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
    );
    drawerItems.add(
      Divider(
        height: 1,
        thickness: 1,
      ),
    );
    drawerItems.add(
      ListTile(
        tileColor: Colors.white12,
        leading: Icon(
          Icons.refresh_sharp,
          color: Color(0xFFC03823),
        ),
        title: Text("Remove Country Filter"),
        onTap: () {
          setState(() {
            lamin = 0.0;
            lomin = 0.0;
            lamax = 0.0;
            lomax = 0.0;
          });
          updateUI();
          Navigator.pop(context);
        },
      ),
    );
    for (String key in map.keys) {
      drawerItems.add(
        ListTile(
          tileColor: Colors.white24,
          leading: Flag(
            map[key][0],
            height: 30.0,
            width: 50.0,
            fit: BoxFit.fill,
          ),
          title: Text(key),
          onTap: () {
            setState(() {
              lamin = map[key][2];
              lomin = map[key][1];
              lamax = map[key][4];
              lomax = map[key][3];
            });
            updateUI();
            Navigator.pop(context);
          },
        ),
      );
    }
  }

  Future<void> updateUI() async {
    showSpinner = true;
    NetworkHelper networkHelper = NetworkHelper();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var uEmail = prefs.getString("email");
    var uId = prefs.getString("id");
    var uToken = prefs.getString("token");

    http.Response response = await http
        .get(FlutterConfig.get('MY_SERVER_URL') + 'user/$uId', headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $uToken',
    });
    if (response.statusCode == 200 && uEmail != null) {
      setState(() {
        isLoggedIn = true;
      });
    }

    var data;

    if (lamin != 0 && lomin != 0 && lamax != 0 && lomax != 0) {
      if (sortBy != "") {
        if (startDate != "" && endDate != "") {
          data = await networkHelper.getData(
              "$fixedUrl&minlatitude=$lamin&minlongitude=$lomin&maxlatitude=$lamax&maxlongitude=$lomax&orderby=$sortBy&starttime=$startDate&endtime=$endDate");
        } else {
          data = await networkHelper.getData(
              "$fixedUrl&limit=300&minlatitude=$lamin&minlongitude=$lomin&maxlatitude=$lamax&maxlongitude=$lomax&orderby=$sortBy");
        }
      } else {
        if (startDate != "" && endDate != "") {
          data = await networkHelper.getData(
              "$fixedUrl&minlatitude=$lamin&minlongitude=$lomin&maxlatitude=$lamax&maxlongitude=$lomax&starttime=$startDate&endtime=$endDate");
        } else {
          data = await networkHelper.getData(
              "$fixedUrl&limit=300&minlatitude=$lamin&minlongitude=$lomin&maxlatitude=$lamax&maxlongitude=$lomax");
        }
      }
    } else {
      if (sortBy != "") {
        if (startDate != "" && endDate != "") {
          data = await networkHelper.getData(
              "$fixedUrl&orderby=$sortBy&starttime=$startDate&endtime=$endDate");
        } else {
          data = await networkHelper
              .getData("$fixedUrl&limit=300&orderby=$sortBy");
        }
      } else {
        if (startDate != "" && endDate != "") {
          data = await networkHelper
              .getData("$fixedUrl&starttime=$startDate&endtime=$endDate");
        } else {
          data = await networkHelper.getData("$fixedUrl&limit=300");
        }
      }
    }
    setState(() {
      earthQuakeTiles.clear();
      for (var i = 0; i < data['features'].length; i++) {
        id = data['features'][i]['id'];

        var mag = data['features'][i]['properties']['mag'];
        magnitude = mag.toString();

        url = data['features'][i]['properties']['url'];

        lon = data['features'][i]['geometry']['coordinates'][0];
        lat = data['features'][i]['geometry']['coordinates'][1];

        DateTime date = new DateTime.fromMillisecondsSinceEpoch(
            data['features'][i]['properties']['time']);
        var finalDate = DateFormat.MMMEd().add_jms().format(date);
        var dateTimeParts = finalDate.split(" ");
        dayDate =
            dateTimeParts[0] + " " + dateTimeParts[1] + " " + dateTimeParts[2];
        var timeParts = dateTimeParts[3].split(":");
        time = timeParts[0] + " " + dateTimeParts[4];

        String loc = data['features'][i]['properties']['place'].toString();
        if (loc.contains("off")) {
          var parts = loc.split("of ");
          locDes = parts[0] + "of";
          location = parts[1];
        } else if (loc.contains("of ")) {
          var parts = loc.split("of ");
          locDes = parts[0] + "of";
          location = parts[1];
        } else {
          locDes = "Near the ";
          location = loc;
        }
        earthQuakeTiles.add(
          new EarthQuakeTile(
            earthQuakeData: new EarthQuakeData(
                location: location,
                locDes: locDes,
                magnitude: magnitude,
                dayDate: dayDate,
                time: time,
                lon: lon,
                lat: lat,
                id: id),
            urlID: url,
          ),
        );
        showSpinner = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFC03823),
        title: Text(
          'EarthShaker',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          TextButton(
            onPressed: () {
              return _orderByAlert(context);
            },
            child: Icon(Icons.sort_rounded, color: Colors.white),
          ),
          TextButton(
            onPressed: () {
              showModalBottomSheet(
                isScrollControlled: true,
                context: context,
                builder: (context) {
                  return GetX<DateSelectionController>(
                    init: DateSelectionController(),
                    builder: (controller) {
                      return Wrap(
                        children: [
                          Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: getProportionateScreenHeight(25.0)),
                              child: Text(
                                "Get EarthQuakes in Specific Time Period",
                                style: TextStyle(
                                    color: Color(0xFFC03823),
                                    fontWeight: FontWeight.bold,
                                    fontSize:
                                        getProportionateScreenWidth(15.0)),
                              ),
                            ),
                          ),
                          ListTile(
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "From",
                                  style: TextStyle(
                                    color: Colors.grey,
                                  ),
                                ),
                                Text(
                                  startDate == ""
                                      ? 'Pick start date'
                                      : startDate,
                                  style: TextStyle(
                                    color: controller.startDate.toString() == ""
                                        ? Colors.black54
                                        : Colors.black,
                                  ),
                                ),
                              ],
                            ),
                            leading: TextButton(
                              child: Icon(
                                Icons.calendar_today,
                                color: Color(0xFFC03823),
                              ),
                              onPressed: () {
                                showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(2021),
                                  lastDate: DateTime.now(),
                                ).then(
                                  (date) {
                                    setState(() {
                                      controller.changeStartDate(
                                          date.toString().split(" ")[0]);
                                      start = date;
                                      startDate =
                                          controller.startDate.toString();
                                    });
                                  },
                                );
                              },
                            ),
                          ),
                          SizedBox(
                            height: getProportionateScreenHeight(10.0),
                          ),
                          ListTile(
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "To",
                                  style: TextStyle(
                                    color: Colors.grey,
                                  ),
                                ),
                                Text(
                                  endDate == "" ? 'Pick end date' : endDate,
                                  style: TextStyle(
                                    color: controller.endDate.toString() == ""
                                        ? Colors.black54
                                        : Colors.black,
                                  ),
                                ),
                              ],
                            ),
                            leading: TextButton(
                              child: Icon(
                                Icons.calendar_today,
                                color: Color(0xFFC03823),
                              ),
                              onPressed: () {
                                showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate:
                                      start == null ? DateTime.now() : start,
                                  lastDate: DateTime.now(),
                                ).then(
                                  (date) {
                                    setState(() {
                                      controller.changeEndDate(
                                          date.toString().split(" ")[0]);
                                      endDate = controller.endDate.toString();
                                    });
                                  },
                                );
                              },
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: getProportionateScreenHeight(30.0),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                TextButton(
                                  style: TextButton.styleFrom(
                                    backgroundColor: Color(0xFFC03823),
                                  ),
                                  onPressed: () {
                                    Navigator.pop(context);
                                    updateUI();
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      "Go",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                                TextButton(
                                  style: TextButton.styleFrom(
                                    backgroundColor: Color(0xFFC03823),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      startDate = "";
                                      endDate = "";
                                    });
                                    Navigator.pop(context);
                                    updateUI();
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      "Clear",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
              );
            },
            child: Icon(Icons.calendar_today_outlined, color: Colors.white),
          ),
          PopupMenuButton(itemBuilder: (context) {
            if (!isLoggedIn) {
              return [
                PopupMenuItem(
                  value: 1,
                  child: TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Get.to(AllExperiences());
                    },
                    child: Text(
                      "All Experiences",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
              ];
            } else {
              return [
                PopupMenuItem(
                  value: 1,
                  child: TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Get.to(AllExperiences());
                    },
                    child: Text(
                      "All Experiences",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
                PopupMenuItem(
                  value: 2,
                  child: TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Get.to(UserExperience());
                    },
                    child: Text(
                      "My Experiences",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
                PopupMenuItem(
                  value: 3,
                  child: TextButton(
                    onPressed: () async {
                      Navigator.pop(context);
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      prefs.remove("email");
                      prefs.remove("id");
                      prefs.remove("token");
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) => EarthQuake(),
                        ),
                        (route) => false,
                      );
                    },
                    child: Text(
                      "Logout",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
              ];
            }
          }),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: drawerItems,
        ),
      ),
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Container(
          child: ListView(
            children: [
              Column(
                children: earthQuakeTiles,
              ),
            ],
          ),
        ),
      ),
    );
  }

  _orderByAlert(BuildContext context) {
    return Alert(
      context: context,
      title: "Order EarthQuakes By",
      content: Column(
        children: [
          Divider(
            thickness: 1.0,
            color: Colors.black,
            indent: getProportionateScreenHeight(2.0),
            endIndent: getProportionateScreenHeight(2.0),
          ),
          ListTile(
            leading: Icon(Icons.arrow_downward_rounded, color: Colors.red),
            title: Text(
              "Descending Time",
              style: TextStyle(color: Colors.red),
            ),
            onTap: () {
              setState(() {
                sortBy = "time";
              });
              Navigator.pop(context);
              updateUI();
            },
          ),
          Divider(
            color: Colors.black38,
            indent: getProportionateScreenHeight(4.0),
            endIndent: getProportionateScreenHeight(4.0),
          ),
          ListTile(
            leading: Icon(Icons.arrow_upward_rounded, color: Colors.green),
            title: Text(
              "Ascending Time",
              style: TextStyle(color: Colors.green),
            ),
            onTap: () {
              setState(() {
                sortBy = "time-asc";
              });
              Navigator.pop(context);
              updateUI();
            },
          ),
          Divider(
            color: Colors.black38,
            indent: getProportionateScreenHeight(4.0),
            endIndent: getProportionateScreenHeight(4.0),
          ),
          ListTile(
            leading: Icon(Icons.arrow_downward_rounded, color: Colors.red),
            title: Text("Descending Magnitude",
                style: TextStyle(color: Colors.red)),
            onTap: () {
              setState(() {
                sortBy = "magnitude";
              });
              Navigator.pop(context);
              updateUI();
            },
          ),
          Divider(
            color: Colors.black38,
            indent: getProportionateScreenHeight(4.0),
            endIndent: getProportionateScreenHeight(4.0),
          ),
          ListTile(
            leading: Icon(Icons.arrow_upward_rounded, color: Colors.green),
            title: Text("Ascending Magnitude",
                style: TextStyle(color: Colors.green)),
            onTap: () {
              setState(() {
                sortBy = "magnitude-asc";
              });
              Navigator.pop(context);
              updateUI();
            },
          ),
        ],
      ),
    ).show();
  }
}
