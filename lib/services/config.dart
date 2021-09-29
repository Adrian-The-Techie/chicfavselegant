import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:device_info/device_info.dart';

class Config {
  // final String url= "https://chicfavselegant.herokuapp.com";
  final String url="http://127.0.0.1:8000/chicfavs/";
  final Color successColor = Color(0xFF28a745);
  final Color primaryColor = Color(0xFF007bff);
  final Color errorColor = Color(0xFFdc3545);
  final Color secondaryColor = Color(0xFF17a2b8);
  final Color buttonFontColor = Color(0xFFF9F8F8);
  final Color amber = Color(0xFFFFC200);
  final double buttonFontSize = 20.0;

  Widget loader(text) {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(text),
        Container(
            margin: EdgeInsets.only(top: 15.0),
            child: CircularProgressIndicator())
      ],
    ));
  }

  Widget errorWidget(setState, error) {
    return Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
          Text('${error}'),
          Container(
              child: RaisedButton(
            color: this.secondaryColor,
            child: Text("Retry"),
            onPressed: () {
              setState(() {});
            },
          ))
        ]));
  }

  responseSnackbar(BuildContext context, String message, Color textColor) {
    var snackbar = new SnackBar(
        content: Text(message, style: TextStyle(color: textColor)));
    Scaffold.of(context).showSnackBar(snackbar);
  }

  parseCurrency(currency) {
    var parsedCurrency =
        NumberFormat.currency(name: 'KES', customPattern: "\u00a4 #,###.#")
            .format(currency);

    return parsedCurrency;
  }

  setInt(String key, int value) async {
    SharedPreferences _preferences = await SharedPreferences.getInstance();
    _preferences.setInt(key, value);
  }

  Future<int> getInt(String key) async {
    SharedPreferences _preferences = await SharedPreferences.getInstance();
    int intValue = _preferences.getInt(key);
    return intValue;
  }

  setString(String key, String value) async {
    SharedPreferences _preferences = await SharedPreferences.getInstance();
    _preferences.setString(key, value);
  }

  Future<String> getString(String key) async {
    SharedPreferences _preferences = await SharedPreferences.getInstance();
    _preferences.getString(key);
  }

  Future<String> deviceInfo() async {
    DeviceInfoPlugin deviceInfo = new DeviceInfoPlugin();
    String deviceInfoString = "";
    try {
      if (Platform.isAndroid) {
        var build = await deviceInfo.androidInfo;
        deviceInfoString = "${build.model}, ${build.version.toString()}";
      } else if (Platform.isIOS) {
        var build = await deviceInfo.iosInfo;
        deviceInfoString = "${build.name},${build.systemVersion}";
      }
    } on PlatformException {
      deviceInfoString = "New platform";
    }
    return deviceInfoString;
  }
}
