import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:get/get.dart';
import 'package:flutter_config/flutter_config.dart';

class LocationPage extends StatefulWidget {
  @override
  _LocationPageState createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFC03823),
        title: Text("EarthShaker"),
      ),
      body: new FlutterMap(
        options: new MapOptions(
          zoom: 2.0,
          center: new LatLng(Get.arguments[1], Get.arguments[0]),
        ),
        layers: [
          new TileLayerOptions(
              urlTemplate: FlutterConfig.get('MAP_BOX_STYLE'),
              additionalOptions: {
                'accessToken': FlutterConfig.get('MAP_BOX_TOKEN'),
                'id': 'mapbox.mapbox-streets-v7'
              }),
          MarkerLayerOptions(
            markers: [
              Marker(
                width: 80.0,
                height: 80.0,
                point: LatLng(Get.arguments[1], Get.arguments[0]),
                builder: (ctx) => Container(
                  child: Icon(
                    Icons.location_on,
                    size: 40.0,
                    color: Colors.red,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
