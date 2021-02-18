import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class AllExperiences extends StatefulWidget {
  @override
  _AllExperiencesState createState() => _AllExperiencesState();
}

class _AllExperiencesState extends State<AllExperiences> {
  String name = 'name';
  String exp = 'Exp';
  String location = "location";
  String dayDate = "dayDate";
  String time = "time";
  String magColour = "colour";
  var experiences = List<Widget>();
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
    await for (var snapshot in FirebaseFirestore.instance
        .collection('allExperiences')
        .snapshots()) {
      setState(() {
        for (var experience in snapshot.docs) {
          name = experience.data()['name'];
          exp = experience.data()['exp'];
          location = experience.data()['location'];
          dayDate = experience.data()['dayDate'];
          time = experience.data()['time'];
          magColour = experience.data()['magColour'];
          String valueString = magColour.split('(0x')[1].split(')')[0];
          int value = int.parse(valueString, radix: 16);
          Color colour = new Color(value);

          print(location + " " + dayDate + " " + time);

          experiences.add(
            Padding(
              padding: EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 10.0,
                  ),
                  Text(
                    name,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15.0,
                    ),
                  ),
                  Text(
                    dayDate,
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
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Material(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      elevation: 5.0,
                      color: colour,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 20.0),
                        child: Text(
                          exp,
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.0,
                          ),
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
        showSpinner = false;
      });
    }
  }
}
