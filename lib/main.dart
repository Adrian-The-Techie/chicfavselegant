import 'package:chicfavs_pos/services/config.dart';
import 'package:chicfavs_pos/services/http.service.dart';
import 'package:flutter/material.dart';
import 'package:chicfavs_pos/route-generator.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int loggedIn;
  HttpService _http = new HttpService();
  Config _config = new Config();
  @override
  initState() {
    super.initState();
    this._config.getInt("userLoginInstance").then((instance) {
      var request = {
        "apiid": "checkLoginStatus",
        "data": {"id": instance}
      };
      this._http.request(request).then((response) {
        this.loggedIn = response.status;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ChicfavsElegantPOS',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: this.loggedIn == 1 ? "/home" : "/",
      onGenerateRoute: RouteGenerator.routeGenerator,
    );
  }
}
