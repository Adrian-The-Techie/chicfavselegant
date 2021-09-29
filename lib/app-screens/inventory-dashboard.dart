import 'package:flutter/material.dart';

class InventoryDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Inventory Management"),
          centerTitle: true,
        ),
        body: GridView.count(
          crossAxisCount: 2,
          children: <Widget>[
            InventoryDashboardItem(
              itemName: "Products",
              route: "/allProducts",
            ),
            InventoryDashboardItem(
              itemName: "Allocate stock",
              route: "/allocateStock",
            ),
            InventoryDashboardItem(
              itemName: "Allocation Details",
              route: "/allocationDetails",
            ),
            InventoryDashboardItem(
              itemName: "Stock take",
              route: "/stockTakeHistory",
            ),
          ],
        ));
  }
}

class InventoryDashboardItem extends StatelessWidget {
  final String itemName;
  final String route;

  InventoryDashboardItem({this.itemName, this.route});
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
