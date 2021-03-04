import 'package:earth_quake/widgets/earthQuakeTile.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../earthQuakeData.dart';
import '../networking.dart';

final int limit = 150;

final fixedUrl =
    'https://earthquake.usgs.gov/fdsnws/event/1/query?format=geojson&orderby=time&minmag=3&limit=$limit';

class EarthQuakeDataController extends GetxController {
  var earthQuakeTiles = List<Widget>().obs;
  var url = "".obs;
  var magnitude = "0.0".obs;
  var location = "Location".obs;
  var locDes = "Description".obs;
  var dayDate = "Day and Date".obs;
  var time = "Time".obs;
  var showSpinner = true.obs;
  var id = "".obs;

  @override
  void onInit() {
    super.onInit();
    updateUI();
  }

  Future<void> updateUI() async {
    NetworkHelper networkHelper = NetworkHelper();
    var data = await networkHelper.getData(fixedUrl);
    for (var i = 0; i < limit; i++) {
      id.value = data['features'][i]['id'];

      var mag = data['features'][i]['properties']['mag'];
      magnitude.value = mag.toString();

      url.value = data['features'][i]['properties']['url'];

      DateTime date = new DateTime.fromMillisecondsSinceEpoch(
          data['features'][i]['properties']['time']);
      var finalDate = DateFormat.MMMEd().add_jms().format(date);
      var dateTimeParts = finalDate.split(" ");
      dayDate.value =
          dateTimeParts[0] + " " + dateTimeParts[1] + " " + dateTimeParts[2];
      var timeParts = dateTimeParts[3].split(":");
      time.value = timeParts[0] + " " + dateTimeParts[4];

      String loc = data['features'][i]['properties']['place'];
      if (loc.contains('of')) {
        var parts = loc.split('of');
        locDes.value = " " + parts[0] + "of";
        location.value = parts[1];
      } else {
        locDes.value = "Near the ";
        location.value = loc;
      }

      earthQuakeTiles.add(
        new EarthQuakeTile(
          earthQuakeData: new EarthQuakeData(
              location: location.value,
              locDes: locDes.value,
              magnitude: magnitude.value,
              dayDate: dayDate.value,
              time: time.value,
              id: id.value),
          urlID: url.value,
        ),
      );
      showSpinner.value = false;
    }
  }
}
