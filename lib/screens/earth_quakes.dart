import 'package:earth_quake/screens/userExperience.dart';
import 'package:flag/flag.dart';
import 'package:earth_quake/widgets/earthQuakeTile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../earthQuakeData.dart';
import '../networking.dart';
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

  @override
  // ignore: missing_return
  Future<void> initState() {
    super.initState();
    updateUI();
    drawerItems.add(
      Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          children: [
            CircleAvatar(
              radius: 55,
              backgroundColor: Colors.white,
              child: CircleAvatar(
                radius: 60,
                backgroundImage: NetworkImage(
                    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTza2yT7dqcRm1WJao9JdGo7mkqqZRn1wVRJwX7cfunWbIiSwugLq2P_qRU53EGI2lRZH4&usqp=CAU"),
              ),
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
            height: 30,
            width: 50,
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
    showSpinner = true;
    if (lamin != 0 && lomin != 0 && lamax != 0 && lomax != 0) {
      data = await networkHelper.getData(
          "$fixedUrl&minlatitude=$lamin&minlongitude=$lomin&maxlatitude=$lamax&maxlongitude=$lomax");
    } else {
      data = await networkHelper.getData(fixedUrl);
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

        String loc = data['features'][i]['properties']['place'];
        if (loc.contains('of')) {
          var parts = loc.split('of');
          locDes = " " + parts[0] + "of";
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
          Padding(
            padding: EdgeInsets.all(8.0),
            child: PopupMenuButton(itemBuilder: (context) {
              if (!isLoggedIn) {
                return [
                  PopupMenuItem(
                    value: 1,
                    child: TextButton(
                      onPressed: () {
                        Get.to(AllExperiences());
                      },
                      child: Text(
                        "All Experiences",
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
                        Get.to(AllExperiences());
                      },
                      child: Text(
                        "All Experiences",
                      ),
                    ),
                  ),
                  PopupMenuItem(
                    value: 2,
                    child: TextButton(
                      onPressed: () {
                        Get.to(UserExperience());
                      },
                      child: Text(
                        "My Experiences",
                      ),
                    ),
                  ),
                  PopupMenuItem(
                    value: 3,
                    child: TextButton(
                      onPressed: () async {
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
                      ),
                    ),
                  ),
                ];
              }
            }),
          ),
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
}
