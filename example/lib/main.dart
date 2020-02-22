import 'package:flutter/material.dart';
import 'package:latlong/latlong.dart';
import 'package:map/map.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final map = Map(
      initialLocation: LatLng(35.68, 51.41),
      inititialZoom: 9.0,
    );

    return MaterialApp(
      title: 'Map Demo',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Map Demo"),
        ),
        body: map,
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.my_location),
          onPressed: () {},
        ),
      ),
    );
  }
}
