import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';

import 'dart:async';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rover Remote',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(
        title: 'Rover Remote Control',
        key: null,
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var z = locationStream();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            //locationStream();
          });
        },
        tooltip: 'Increment',
        child: Icon(Icons.stop),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

var location = new Location();
Future<bool?> permissionCheck() async {
  var serviceEnabled = await location.serviceEnabled();
  if (!serviceEnabled) {
    serviceEnabled = await location.requestService();
    if (!serviceEnabled) {
      return false;
    } else {
      return true;
    }
  }
}

Future<bool?> askPermission() async {
  var _permissionGranted = await location.hasPermission();
  if (_permissionGranted == PermissionStatus.denied) {
    _permissionGranted = await location.requestPermission();
    if (_permissionGranted != PermissionStatus.granted) {
      return false;
    } else {
      return true;
    }
  }
}

Future<String> locationStream() async {
  var currentLocation = await location.getLocation();
  location.onLocationChanged.listen((LocationData currentLocation) {
    Postlocationstream(currentLocation.latitude.toString());
  });
  return "{currentLocation.latitude.toString()}";
}

//var x = locationStream();
// ignore: non_constant_identifier_names
Future Postlocationstream(String locationstream) async {
  final response = await http.post(
    Uri.parse('http://192.168.43.61:5000/' + locationstream),
  );
  if (response.statusCode == 201) {
    return 201;
  } else {
    // If the server did not return a 201 CREATED response,
    // then throw an exception.

    return 404;
  }
}
