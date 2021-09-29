import 'package:flutter/material.dart';

class SalesDashboard extends StatelessWidget {
  int level = 1;

  SalesDashboard({this.level});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Sales Management"),
          centerTitle: true,
        ),
        body: GridView.count(
          crossAxisCount: 2,
          children: <Widget>[
            SalesDashboardItem(itemName: "Make a sale", route: "/makeASale"),
            this.level == 3
                ? SalesDashboardItem(
                    itemName: "Sales history", route: "/saleHistory")
                : Container(height: 0, width: 0),
          ],
        ));
  }
}

class SalesDashboardItem extends StatelessWidget {
  final String itemName;
  final String route;

  SalesDashboardItem({this.itemName, this.route});
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
                    Text(this.itemName, style: TextStyle(fontSize: 16.0)),
                  ])))),
      onTap: () {
        Navigator.of(context).pushNamed(this.route);
      },
    );
  }
}
