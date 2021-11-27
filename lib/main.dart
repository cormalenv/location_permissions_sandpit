import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:app_settings/app_settings.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Location Permissions Test',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Location Permissions Test'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  PermissionStatus locPermissStatus = PermissionStatus.denied;
  PermissionStatus locPermissStatusWhenInUse = PermissionStatus.denied;
  PermissionStatus locPermissStatusAlways = PermissionStatus.denied;
  String error = "";

  @override
  void initState() {

    Permission.location.status.then((result){
      setState(() {
        locPermissStatus = result;
      });
    });

    Permission.locationWhenInUse.status.then((result){
      setState(() {
        locPermissStatusWhenInUse = result;
      });
    });

    Permission.locationAlways.status.then((result){
      setState(() {
        locPermissStatusAlways = result;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("Location status: ${locPermissStatus.toString().split(".")[1]}"),
            Text("When in use status: ${locPermissStatusWhenInUse.toString().split(".")[1]}"), //while use status
            Text("Always status: ${locPermissStatusAlways.toString().split(".")[1]}"), //while use status
            TextButton(
                child: const Text("Request When in use"),
                onPressed: () {
                  try{
                    Permission.locationWhenInUse.request().then((result) async {
                      locPermissStatus = await Permission.location.status;
                      locPermissStatus = await Permission.locationAlways.status;
                      setState(() {
                        locPermissStatusWhenInUse = result;
                      });
                    });
                  }
                  catch (e) {
                    setState(() {
                      error = e.toString();
                    });
                  };
                }
            ),
            TextButton(
                child: const Text("Request Always"),
                onPressed: ()  {
                  try {
                    Permission.locationAlways.request().then((result) async {
                      locPermissStatus = await Permission.location.status;
                      locPermissStatus = await Permission.locationWhenInUse.status;
                      setState(() {
                        locPermissStatusAlways = result;
                      });
                    });
                  }
                  catch (e) {
                    setState(() {
                      error = e.toString();
                    });
                  };
                }
            ),
            TextButton(
                child: const Text("Open Location Settings"),
                onPressed: () {
                  AppSettings.openLocationSettings();
                }
            ),
            Text("Error: ${error}"),
          ],
        ),
      ),
    );
  }
}