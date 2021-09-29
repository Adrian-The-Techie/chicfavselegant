import 'package:chicfavs_pos/services/config.dart';
import 'package:chicfavs_pos/services/http.service.dart';
import 'package:flutter/material.dart';

class StockTakeHistory extends StatefulWidget {
  @override
  _StockTakeHistoryState createState() => _StockTakeHistoryState();
}

class _StockTakeHistoryState extends State<StockTakeHistory> {
  HttpService _http = new HttpService();
  Config _config = new Config();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Stock take history"), centerTitle: true),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          tooltip: "New stock take",
          onPressed: () {
            Navigator.of(context).pushNamed("/newStockTake");
          },
        ),
        body: FutureBuilder(
            future: this._http.request({"apiid": "getStockTakeHistories"}),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return this
                    ._config
                    .loader("Retrieving stock take histories...");
              } else {
                if (snapshot.hasError) {
                  return this._config.errorWidget(setState,
                      "Error retrieving records. Please try again later");
                } else {
                  return ListView.builder(
                      itemCount: snapshot.data.data.length,
                      itemBuilder: (context, index) {
                        return Column(children: <Widget>[
                          ListTile(
                            leading: CircleAvatar(
                                child: Text(snapshot.data.data[index]["id"]
                                    .toString())),
                            title: Text(
                                "Stock take report as of ${snapshot.data.data[index]["date_added"]}"),
                            trailing: IconButton(
                                icon: Icon(Icons.visibility),
                                onPressed: () {
                                  Navigator.of(context).pushNamed(
                                      "/specificStockTakeHistory",
                                      arguments: snapshot.data.data[index]
                                          ["id"]);
                                }),
                          ),
                          Divider(thickness: 1.0)
                        ]);
                      });
                }
              }
            }));
  }
}
