import 'package:chicfavs_pos/services/config.dart';
import 'package:chicfavs_pos/services/http.service.dart';
import 'package:flutter/material.dart';

class SpecificAllocationDetails extends StatefulWidget {
  Map<String, dynamic> _user_details;
  SpecificAllocationDetails(this._user_details);
  @override
  _SpecificAllocationDetailsState createState() =>
      _SpecificAllocationDetailsState(this._user_details);
}

class _SpecificAllocationDetailsState extends State<SpecificAllocationDetails> {
  Map<String, dynamic> _user_details;
  HttpService _http = new HttpService();
  Config _config = new Config();
  List _history = [];
  List _myItems = [];
  _SpecificAllocationDetailsState(this._user_details);

  Widget _genTitle(String title) {
    return Align(
      alignment: Alignment.center,
      child: Text(
        title,
        style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var request = {
      "apiid": "getSpecificAllocationDetails",
      "data": {"id": this._user_details["id"]}
    };
    return Scaffold(
        appBar: AppBar(title: Text(this._user_details["username"])),
        body: FutureBuilder(
            future: this._http.request(request),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return this._config.loader("Retrieve allocation records");
              } else {
                if (snapshot.hasError) {
                  return this._config.errorWidget(setState,
                      "Error retrieving records. Please try again later");
                } else {
                  this._history = snapshot.data.data["allocationHistory"];
                  this._myItems = snapshot.data.data["availableItems"];
                  return ListView(children: <Widget>[
                    SizedBox(height: 7.0),
                    this._genTitle("My items"),
                    for (var value in this._myItems)
                      ListTile(
                        title: Text(value["product_allocated"]),
                        trailing: Text(value["quantity_allocated"].toString()),
                      ),
                    Divider(thickness: 1.0),
                    SizedBox(height: 7.0),
                    this._genTitle("Allocation History"),
                    DataTable(
                      columns: [
                        DataColumn(label: Text("ID")),
                        DataColumn(label: Text("Date allocated")),
                        DataColumn(label: Text("Action"))
                      ],
                      rows: this
                          ._history
                          .map((detail) => DataRow(cells: [
                                DataCell(Text(detail["id"].toString())),
                                DataCell(Text(detail["date_allocated"])),
                                DataCell(
                                    IconButton(
                                      icon: Icon(Icons.visibility),
                                      onPressed: () {
                                        Navigator.of(context).pushNamed(
                                            "/specificAllocationHistoryDetails",
                                            arguments: detail["id"]);
                                      },
                                    ),
                                    placeholder: true),
                              ]))
                          .toList(),
                    )
                  ]);
                }
              }
            }));
  }
}
