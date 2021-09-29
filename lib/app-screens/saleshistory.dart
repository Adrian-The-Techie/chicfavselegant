import 'package:chicfavs_pos/services/config.dart';
import 'package:chicfavs_pos/services/http.service.dart';
import 'package:flutter/material.dart';

class SalesHistory extends StatefulWidget {
  @override
  _SalesHistoryState createState() => _SalesHistoryState();
}

class _SalesHistoryState extends State<SalesHistory> {
  HttpService _http = new HttpService();
  Config _config = new Config();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Sales History"),
        ),
        body: FutureBuilder(
          future: this._http.request({"apiid": "getSaleHistory"}),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return this._config.loader("Loading sales history");
            } else {
              if (snapshot.hasError) {
                return this._config.errorWidget(setState, snapshot.error);
              } else {
                return ListView.builder(
                    itemCount: snapshot.data.data.length,
                    itemBuilder: (context, index) {
                      var data = snapshot.data.data[index];
                      return ListTile(
                        leading: CircleAvatar(child: Text("${data['id']}")),
                        title:
                            Text("Bought by ${data['customer_phone_number']}"),
                        subtitle: Text("on ${data['date_added']}"),
                        trailing: IconButton(
                            icon: Icon(Icons.visibility),
                            onPressed: () {
                              Navigator.of(context).pushNamed(
                                  "/specificSaleHistory",
                                  arguments: data["id"]);
                            }),
                      );
                    });
              }
            }
          },
        ));
  }
}
