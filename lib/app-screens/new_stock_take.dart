import 'package:chicfavs_pos/services/config.dart';
import 'package:chicfavs_pos/services/http.service.dart';
import 'package:flutter/material.dart';

class NewStockTake extends StatefulWidget {
  int id;

  NewStockTake({this.id});
  @override
  _NewStockTakeState createState() => _NewStockTakeState(id: this.id);
}

class _NewStockTakeState extends State<NewStockTake> {
  bool _showNewStockTakeButton = true;
  Config _config = new Config();
  HttpService _http = new HttpService();

  int id;

  _NewStockTakeState({this.id});

  Widget _mainDetails(String title, String detail) {
    return Container(
        margin: EdgeInsets.only(left: 7.0),
        child: RichText(
            text: TextSpan(
                text: "$title: ",
                style: TextStyle(color: Colors.black),
                children: <TextSpan>[
              TextSpan(
                  text: "$detail ",
                  style: TextStyle(fontWeight: FontWeight.bold))
            ])));
  }

  showSnackBar(context, String content) {
    var snackbar = SnackBar(
        content:
            Text(content, style: TextStyle(color: this._config.successColor)));
    Scaffold.of(context).showSnackBar(snackbar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text(this._showNewStockTakeButton && this.id == null
                ? "New stock take"
                : "Stock take report"),
            centerTitle: true),
        body: Builder(builder: (context) {
          return this._showNewStockTakeButton && this.id == null
              ? Container(
                  margin: EdgeInsets.only(top: 50.0),
                  child: Align(
                      alignment: Alignment.topCenter,
                      child: ButtonTheme(
                          minWidth: 200.0,
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0)),
                            child: Text("Perform new stock take",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: this._config.buttonFontSize)),
                            onPressed: () {
                              setState(() {
                                this._showNewStockTakeButton = false;
                              });
                            },
                          ))))
              : FutureBuilder(
                  future: this._http.request(this.id == null
                      ? {"apiid": "performStockTake"}
                      : {
                          "apiid": "getSpecificStockTakeHistory",
                          "data": {"id": this.id}
                        }),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return this._config.loader("Performing stock take...");
                    } else {
                      if (snapshot.hasError) {
                        return this._config.errorWidget(setState,
                            "Error occurred while performing stock take. Please try again later");
                      } else {
                        var data = snapshot.data.data;
                        // Show snackbar
                        // if (data.containsKey("message")) {
                        //   showSnackBar(context, data["message"]);
                        // }
                        return Column(children: <Widget>[
                          Container(
                              margin: EdgeInsets.only(top: 5.0, bottom: 7.0),
                              child: Column(children: <Widget>[
                                RichText(
                                  text: TextSpan(
                                      text: "As of ",
                                      style: TextStyle(
                                          fontSize: 20.0, color: Colors.black),
                                      children: <TextSpan>[
                                        TextSpan(
                                            text: "${data['date_performed']}",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontStyle: FontStyle.italic)),
                                        TextSpan(
                                            text:
                                                ", here is the stock take report.")
                                      ]),
                                  textAlign: TextAlign.center,
                                ),
                                Divider(thickness: 1.0),
                                RichText(
                                    text: TextSpan(
                                        text: "Total stock valuation: ",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 18.0),
                                        children: <TextSpan>[
                                      TextSpan(
                                          text:
                                              "${this._config.parseCurrency(data['stockValuation'])} ",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold))
                                    ])),
                              ])),
                          Divider(thickness: 2.0),
                          Expanded(
                              child: ListView(children: <Widget>[
                            for (var details in data["details"])
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  this._mainDetails(
                                      "Product ID", details["id"].toString()),
                                  this._mainDetails(
                                      "Product Name", details["name"]),
                                  this._mainDetails(
                                      "Selling price",
                                      this._config.parseCurrency(
                                          details["selling_price"])),
                                  this._mainDetails(
                                      "Quantity in stock for normal sale",
                                      details["quantity_in_stock"].toString()),
                                  this._mainDetails(
                                      "Quantity in stock for allocation sale",
                                      details["item_allocated_quantity_in_stock"]
                                          .toString()),
                                  this._mainDetails(
                                      "Total amount in stock",
                                      details["total_quantity_in_stock"]
                                          .toString()),
                                  this._mainDetails(
                                      "Total valuation of ${details['name']}",
                                      this._config.parseCurrency(
                                          details["sub_total_value"])),
                                  Divider(thickness: 1.0)
                                ],
                              )
                          ]))
                        ]);
                      }
                    }
                  });
        }));
  }
}
