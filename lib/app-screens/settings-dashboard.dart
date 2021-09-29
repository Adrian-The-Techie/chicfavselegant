import 'package:flutter/material.dart';

class SettingsDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Settings"),
          centerTitle: true,
        ),
        body: GridView.count(
          crossAxisCount: 2,
          children: <Widget>[
            SettingsDashboardItem(
              itemName: "Set up employee levels",
              route: "/allEmployeeLevels",
            ),
            SettingsDashboardItem(
              itemName: "Set up branches",
              route: "/allBranches",
            ),
            SettingsDashboardItem(
              itemName: "Set up categories",
              route: "/allCategories",
            )
          ],
        ));
  }
}

class SettingsDashboardItem extends StatelessWidget {
  final String itemName;
  final String route;

  SettingsDashboardItem({this.itemName, this.route});
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
                  child:
                      Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                    Text(
                      this.itemName,
                      style: TextStyle(fontSize: 16.0),
                      textAlign: TextAlign.center,
                    ),
                  ])))),
      onTap: () {
        Navigator.of(context).pushNamed(this.route);
      },
    );
  }
}
