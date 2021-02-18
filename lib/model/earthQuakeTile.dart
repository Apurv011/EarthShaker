import 'package:earth_quake/view/earthQuakeInfo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'earthQuakeData.dart';

class EarthQuakeTile extends StatelessWidget {
  EarthQuakeTile({this.earthQuakeData, this.urlID});

  final EarthQuakeData earthQuakeData;
  final String urlID;

  @override
  Widget build(BuildContext context) {
    String magValue = earthQuakeData.magnitude.length < 3
        ? earthQuakeData.magnitude
        : earthQuakeData.magnitude.substring(0, 3);

    return Column(
      children: [
        ListTile(
          onTap: () {
            Get.to(EarthQuakeInfoPage(), arguments: [
              getColour(earthQuakeData.magnitude),
              magValue,
              earthQuakeData.locDes,
              earthQuakeData.location,
              earthQuakeData.dayDate,
              earthQuakeData.time,
              urlID,
              earthQuakeData.id
            ]);
          },
          leading: CircleAvatar(
            backgroundColor: getColour(earthQuakeData.magnitude),
            child: Text(
              magValue,
              style: TextStyle(color: Colors.white),
            ),
          ),
          title: Padding(
            padding: EdgeInsets.only(top: 9.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  earthQuakeData.locDes,
                  style: TextStyle(
                    color: Colors.blueGrey,
                  ),
                ),
                Text(earthQuakeData.location)
              ],
            ),
          ),
          trailing: Padding(
            padding: const EdgeInsets.only(top: 9.0),
            child: Column(
              children: [
                Text(earthQuakeData.dayDate),
                Text(earthQuakeData.time),
              ],
            ),
          ),
        ),
        SizedBox(
          height: 3.0,
          width: 370,
          child: Divider(
            indent: 40.0,
            color: Colors.black54,
          ),
        ),
      ],
    );
  }
}

getColour(String magnitudeStr) {
  var colour;
  double mag = double.parse(magnitudeStr);
  int magnitudeFloor = mag.floor();
  switch (magnitudeFloor) {
    case 0:
    case 1:
      colour = Color(0xFF4A7BA7);
      break;
    case 2:
      colour = Color(0xFF04B4B3);
      break;
    case 3:
      colour = Color(0xFF10CAC9);
      break;
    case 4:
      colour = Color(0xFFF5A623);
      break;
    case 5:
      colour = Color(0xFFFF7D50);
      break;
    case 6:
      colour = Color(0xFFFC6644);
      break;
    case 7:
      colour = Color(0xFFE75F40);
      break;
    case 8:
      colour = Color(0xFFE13A20);
      break;
    case 9:
      colour = Color(0xFFD93218);
      break;
    default:
      colour = Color(0xFFC03823);
      break;
  }
  return colour;
}
