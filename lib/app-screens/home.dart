import 'package:chicfavs_pos/services/config.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Config _config = new Config();
  int _level;
  @override
  initState() {
    super.initState();
    this._config.getInt("level").then((level) => this._level = level);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Main Dashboard"),
          centerTitle: true,
        ),
        body: FutureBuilder(
            future: this._config.getInt("level"),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return this._config.loader("Loading...");
              } else {
                if (snapshot.hasError) {
                  return this._config.errorWidget(
                      setState, "Error occured. Contact admin for assistance");
                } else {
                  this._level = snapshot.data;
                  return GridView.count(
                    crossAxisCount: 2,
                    children: <Widget>[
                      DashboardItem(
                          itemName: "Sales",
                          route: "/salesDashboard",
                          arguments: this._level),
                      this._level == 3
                          ? DashboardItem(
                              itemName: "Inventory",
                              route: "/inventoryDashboard")
                          : Container(height: 0, width: 0),
                      this._level == 3
                          ? DashboardItem(
                              itemName: "Employees", route: "/allEmployees")
                          : Container(height: 0, width: 0),
                      this._level == 3
                          ? DashboardItem(
                              itemName: "Reports", route: "/reportsDashboard")
                          : Container(height: 0, width: 0),
                      this._level == 3
                          ? DashboardItem(
                              itemName: "Settings", route: "/settingsDashboard")
                          : Container(height: 0, width: 0),
                    ],
                  );
                }
              }
            }));
  }
}

class DashboardItem extends StatelessWidget {
  final String itemName;
  final String route;
  var arguments = null;

  DashboardItem({this.itemName, this.route, this.arguments});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
          margin: EdgeInsets.all(15.0),
          child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)),
              child: Align(
                alignment: Alignment.center,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(this.itemName, style: TextStyle(fontSize: 16.0))
                  ],
                ),
              ))),
      onTap: () {
        Navigator.of(context).pushNamed(this.route, arguments: this.arguments);
      },
    );
  }
}
