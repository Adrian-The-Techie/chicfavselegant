import 'package:flutter/material.dart';

class EmployeesDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Employee Management"),
          centerTitle: true,
        ),
        body: GridView.count(
          crossAxisCount: 2,
          children: <Widget>[
            EmployeesDashboardItem(
              itemName: "Employees",
              route: "/allEmployees",
            ),
            EmployeesDashboardItem(
              itemName: "Employee levels",
              route: "/allEmployeeLevels",
            ),
          ],
        ));
  }
}

class EmployeesDashboardItem extends StatelessWidget {
  final String itemName;
  final String route;

  EmployeesDashboardItem({this.itemName, this.route});
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
