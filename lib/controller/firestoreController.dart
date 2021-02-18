import 'package:cloud_firestore/cloud_firestore.dart';

class FireStoreController {
  Future<void> addExperience(String name, String exp, String id) {
    CollectionReference experience =
        FirebaseFirestore.instance.collection('$id');

    return experience
        .add({'name': name, 'exp': exp})
        .then((value) => print("Experience Added"))
        .catchError((error) => print("Failed to add experience: $error"));
  }

  Future<void> addToSaved(String name, String exp, String location,
      String dayDate, String time, String magColour) {
    CollectionReference experience =
        FirebaseFirestore.instance.collection('allExperiences');

    return experience
        .add({
          'name': name,
          'exp': exp,
          'location': location,
          'dayDate': dayDate,
          'time': time,
          'magColour': magColour
        })
        .then((value) => print("Experience Saved"))
        .catchError((error) => print("Failed to add experience: $error"));
  }
}
