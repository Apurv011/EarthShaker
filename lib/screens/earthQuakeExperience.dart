import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:earth_quake/widgets/experienceBubble.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class EarthQuakeExperience extends StatefulWidget {
  @override
  _EarthQuakeExperienceState createState() => _EarthQuakeExperienceState();
}

class _EarthQuakeExperienceState extends State<EarthQuakeExperience> {
  String name = 'name';
  String exp = 'Exp';
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
        .collection(Get.arguments[0])
        .snapshots()) {
      setState(() {
        for (var experience in snapshot.docs) {
          name = experience.data()['name'];
          exp = experience.data()['exp'];

          experiences.add(
            new ExperienceBubble(
              name: name,
              exp: exp,
              colour: Get.arguments[1],
            ),
          );
        }
        showSpinner = false;
      });
    }
  }
}
