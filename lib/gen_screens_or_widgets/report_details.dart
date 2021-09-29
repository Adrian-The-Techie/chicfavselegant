import 'package:chicfavs_pos/services/config.dart';
import 'package:chicfavs_pos/services/http.service.dart';
import 'package:flutter/material.dart';

class ReportDetails extends StatefulWidget {
  String title;
  String label;
  String period;
  Map<String, dynamic> request;

  ReportDetails({this.title, this.label, this.period, this.request});
  @override
  _ReportDetailsState createState() => _ReportDetailsState(
      title: this.title,
      label: this.label,
      period: this.period,
      request: this.request);
}

class _ReportDetailsState extends State<ReportDetails> {
  Config _config = new Config();
  HttpService _http = new HttpService();

  String title;
  String label;
  String period;
  Map<String, dynamic> request;

  _ReportDetailsState({this.title, this.label, this.period, this.request});

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("${this.title} report"), centerTitle: true),
        body: FutureBuilder(
            future: this._http.request(this.request),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return this._config.loader("Retrieving ${this.label} report");
              } else {
                if (snapshot.hasError) {
                  return this._config.errorWidget(setState,
                      "Error occurred while ${this.label} report. Please try again later");
                } else {
                  var data = snapshot.data.data;
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
                                  TextSpan(text: ", here is the sales report.")
                                ]),
                            textAlign: TextAlign.center,
                          ),
                          Divider(thickness: 1.0),
                          RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                  text:
                                      "Total sales valuation for ${this.period}: ",
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 18.0),
                                  children: <TextSpan>[
                                    TextSpan(
                                        text:
                                            "${this._config.parseCurrency(data['salesValuation'])} ",
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
                            this._mainDetails("Product Name", details["name"]),
                            this._mainDetails(
                                "Buying price",
                                this
                                    ._config
                                    .parseCurrency(details["buying_price"])),
                            this._mainDetails("Selling price",
                                details["selling_price"].toString()),
                            this._mainDetails("Quantity sold",
                                details["quantity_sold"].toString()),
                            this._mainDetails(
                                "Profit", details["profit"].toString()),
                            this._mainDetails(
                                "Total valuation of ${details['name']} sold",
                                this._config.parseCurrency(
                                    details["total_value_sold"])),
                            Divider(thickness: 1.0)
                          ],
                        )
                    ]))
                  ]);
                }
              }
            }));
  }
}
