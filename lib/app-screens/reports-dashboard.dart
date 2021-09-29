import 'package:flutter/material.dart';

class ReportsDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Reports Management"),
          centerTitle: true,
        ),
        body: GridView.count(
          crossAxisCount: 2,
          children: <Widget>[
            ReportsDashboardItem(
              itemName: "Daily report",
              route: "/dailyReport",
            ),
            ReportsDashboardItem(
              itemName: "Monthly report",
              route: "/monthlyReport",
            ),
            ReportsDashboardItem(
              itemName: "Yearly report",
              route: "/yearlyReport",
            ),
          ],
        ));
  }
}

class ReportsDashboardItem extends StatelessWidget {
  final String itemName;
  final String route;

  ReportsDashboardItem({this.itemName, this.route});
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
                    ),
                  ])))),
      onTap: () {
        Navigator.of(context).pushNamed(this.route);
      },
    );
  }
}
