import 'package:chicfavs_pos/services/config.dart';
import 'package:chicfavs_pos/services/http.service.dart';
import 'package:flutter/material.dart';

class SpecificAllocationHistoryDetails extends StatefulWidget {
  int _id;

  SpecificAllocationHistoryDetails(this._id);
  @override
  _SpecificAllocationHistoryDetails createState() =>
      _SpecificAllocationHistoryDetails(this._id);
}

class _SpecificAllocationHistoryDetails
    extends State<SpecificAllocationHistoryDetails> {
  HttpService _http = new HttpService();
  int _id;
  Config _config = new Config();
  List _items = new List();
  _SpecificAllocationHistoryDetails(this._id);

  Widget _mainDetails(String title, String detail) {
    return RichText(
        text: TextSpan(
            text: "$title: ",
            style: TextStyle(color: Colors.black),
            children: <TextSpan>[
          TextSpan(
              text: "$detail ", style: TextStyle(fontWeight: FontWeight.bold))
        ]));
  }

  Widget _genTitle(String title) {
    return Align(
      alignment: Alignment.center,
      child: Text(
        title,
        style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _snackbar(BuildContext context, String text, Color color) {
    var snackbar = SnackBar(
      content: Text(text, style: TextStyle(color: color)),
    );
    Scaffold.of(context).showSnackBar(snackbar);
  }

  @override
  Widget build(BuildContext context) {
    var request = {
      "apiid": "getSpecificAllocationHistoryDetails",
      "data": {"id": this._id}
    };
    return Scaffold(
      appBar: AppBar(
        title: Text("Allocation ID ${this._id}"),
      ),
      body: FutureBuilder(
          future: this._http.request(request),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return this._config.loader("Retrieving details...");
            } else {
              if (snapshot.hasError) {
                return this._config.errorWidget(setState, snapshot.error);
              } else {
                var data = snapshot.data.data;
                var allocatedOn = data["date_allocated"];
                var totalValueOfAllocation =
                    this._config.parseCurrency(data['grand_total_value']);
                this._items = data["items_sold"];
                return ListView(children: <Widget>[
                  SizedBox(height: 7.0),
                  this._genTitle("Basic allocation info"),
                  SizedBox(height: 7.0),
                  this._mainDetails("Allocated By", data["allocated_by"]),
                  SizedBox(height: 7.0),
                  this._mainDetails("Allocated on", allocatedOn),
                  SizedBox(height: 7.0),
                  this._mainDetails("Total value of allocation as of now:",
                      "$totalValueOfAllocation"),
                  SizedBox(height: 7.0),
                  Row(children: <Widget>[
                    SizedBox(width: 2.0),
                  ]),
                  Divider(thickness: 1.7),
                  SizedBox(height: 7.0),
                  this._genTitle("Items allocated"),
                  Container(
                      child: DataTable(
                          columns: [
                        DataColumn(label: Text("Name")),
                        DataColumn(
                          label: Expanded(child: Text("Selling Price")),
                        ),
                        DataColumn(label: Text("Quantity")),
                        DataColumn(
                            label: Expanded(child: Text("Sub-Total Value")))
                      ],
                          rows: this
                              ._items
                              .map((item) => DataRow(cells: [
                                    DataCell(Text(item["product"])),
                                    DataCell(Text("${item["selling_price"]}")),
                                    DataCell(
                                        Text("${item["quantity_allocated"]}")),
                                    DataCell(Text("${item["sub_total_value"]}"))
                                  ]))
                              .toList())),
                  Container(
                      margin: EdgeInsets.only(top: 15.0, left: 5.0, right: 5.0),
                      child: ButtonTheme(
                          child: RaisedButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0)),
                        child:
                            Text("OK", style: TextStyle(color: Colors.white)),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      )))
                ]);
              }
            }
          }),
    );
  }
}
