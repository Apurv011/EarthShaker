import 'package:flutter/material.dart';

class ExperienceBubble extends StatelessWidget {
  final Color colour;
  final String name;
  final String exp;

  ExperienceBubble({this.name, this.exp, this.colour});

  @override
  Widget build(BuildContext context) {
    return Padding(
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
              color: Colors.black54,
              fontSize: 12.0,
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Material(
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
              elevation: 5.0,
              color: colour,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                child: Text(
                  exp,
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15.0,
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
    );
  }
}
