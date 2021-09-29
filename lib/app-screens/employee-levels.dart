import 'package:flutter/material.dart';
import 'package:chicfavs_pos/services/http.service.dart';
import 'package:chicfavs_pos/services/config.dart';

class EmployeeLevels extends StatefulWidget {
  @override
  _EmployeeLevelsState createState() => _EmployeeLevelsState();
}

class _EmployeeLevelsState extends State<EmployeeLevels> {
  HttpService _http = new HttpService();
  Config _config = new Config();
  @override
  Widget build(BuildContext context) {
    const requestData = {"apiid": "getEmployeeLevels"};
    return Scaffold(
      appBar: AppBar(
        title: Text("Employee Levels"),
        centerTitle: true,
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: () {
          const arguments = {"type": "new", "id": "", "name": "", "level": ""};
          Navigator.of(context)
              .pushNamed("/newEmployeeLevel", arguments: arguments);
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
                  Text("Loading employee Levels"),
                  Container(
                      margin: EdgeInsets.only(top: 18.0),
                      child: CircularProgressIndicator())
                ],
              ));
            }
            return ListView.builder(
                itemCount: snapshot.data.data.length,
                itemBuilder: (context, index) {
                  var _specificEmployeeLevel = snapshot.data.data[index];
                  return Column(children: <Widget>[
                    ListTile(
                      title: Text(_specificEmployeeLevel["name"]),
                      //subtitle: ,
                      trailing: IconButton(
                        color: this._config.primaryColor,
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          var arguments = {
                            "type": "edit",
                            "id": _specificEmployeeLevel["id"],
                            "name": _specificEmployeeLevel["name"],
                            "level": _specificEmployeeLevel["level"]
                          };
                          Navigator.of(context).pushNamed(
                              "/editDeleteEmployeeLevel",
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
