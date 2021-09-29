import 'package:flutter/material.dart';

class TypeOfSale extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Type of sale"),
          centerTitle: true,
        ),
        body: GridView.count(
          crossAxisCount: 2,
          children: <Widget>[
            TypeOfSaleItem(
              itemName: "Normal sale",
              route: "/normalSale",
            ),
            TypeOfSaleItem(
              itemName: "Allocation sale",
              route: "/allocationSale",
            )
          ],
        ));
  }
}

class TypeOfSaleItem extends StatelessWidget {
  final String itemName;
  final String route;

  TypeOfSaleItem({this.itemName, this.route});
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
