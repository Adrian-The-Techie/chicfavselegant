import 'package:flutter/material.dart';
import 'package:chicfavs_pos/services/http.service.dart';
import 'package:chicfavs_pos/services/config.dart';

class Branches extends StatefulWidget {
  @override
  _BranchesState createState() => _BranchesState();
}

class _BranchesState extends State<Branches> {
  HttpService _http = new HttpService();
  Config _config = new Config();
  @override
  Widget build(BuildContext context) {
    const requestData = {"apiid": "getBranches"};
    return Scaffold(
      appBar: AppBar(
        title: Text("Branches"),
        centerTitle: true,
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: () {
          const arguments = {"type": "new", "id": "", "name": ""};
          Navigator.of(context).pushNamed("/newBranch", arguments: arguments);
        },
        child: Icon(Icons.add),
      ),
      body: FutureBuilder(
          future: this._http.request(requestData),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("Loading branches"),
                  Container(
                      margin: EdgeInsets.only(top: 18.0),
                      child: CircularProgressIndicator())
                ],
              ));
            }
            return ListView.builder(
                itemCount: snapshot.data.data.length,
                itemBuilder: (context, index) {
                  return Column(children: <Widget>[
                    ListTile(
                      title: Text(snapshot.data.data[index]["name"]),
                      //subtitle: ,
                      trailing: IconButton(
                        color: this._config.primaryColor,
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          var arguments = {
                            "type": "edit",
                            "id": snapshot.data.data[index]["id"],
                            "name": snapshot.data.data[index]["name"]
                          };
                          Navigator.of(context).pushNamed("/editDeleteBranch",
                              arguments: arguments);
                        },
                      ),
                    ),
                    Divider(
                      thickness: 1.0,
                    )
                  ]);
                });
          }),
    );
  }
}
