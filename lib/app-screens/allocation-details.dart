import 'package:chicfavs_pos/services/config.dart';
import 'package:chicfavs_pos/services/http.service.dart';
import 'package:flutter/material.dart';

class AllocationDetails extends StatefulWidget {
  @override
  _AllocationDetailsState createState() => _AllocationDetailsState();
}

class _AllocationDetailsState extends State<AllocationDetails> {
  HttpService _http = new HttpService();
  Config _config = new Config();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("All sales people")),
        body: FutureBuilder(
            future: this._http.request({"apiid": "getAllSalespeople"}),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return this._config.loader("Getting all sales people");
              } else {
                if (snapshot.hasError) {
                  return this._config.errorWidget(setState,
                      "Error retrieving sales people. Please try again later");
                } else {
                  return Container(
                      child: ListView.builder(
                          itemCount: snapshot.data.data.length,
                          itemBuilder: (context, index) {
                            var salesPerson = snapshot.data.data[index];
                            return Column(children: <Widget>[
                              ListTile(
                                  title: Text(salesPerson["username"]),
                                  trailing: IconButton(
                                    icon: Icon(Icons.visibility),
                                    onPressed: () {
                                      Navigator.of(context).pushNamed(
                                          "/details",
                                          arguments: salesPerson);
                                    },
                                  )),
                              Divider(thickness: 1.0)
                            ]);
                          }));
                }
              }
            }));
  }
}
