import 'package:flutter/material.dart';
import 'package:chicfavs_pos/services/http.service.dart';
import 'package:chicfavs_pos/services/config.dart';

class Employees extends StatefulWidget {
  @override
  _EmployeesState createState() => _EmployeesState();
}

class _EmployeesState extends State<Employees> {
  HttpService _http = new HttpService();
  Config _config = new Config();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Employees"),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            const data = {
              "type": "new",
              "name": "",
              "email": "",
              "phone": "",
              "placeOfResidence": "",
              "password": ""
            };
            Navigator.of(context).pushNamed("/newEmployee", arguments: data);
          }),
      body: FutureBuilder(
          future: this._http.request({"apiid": "getAllEmployees"}),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                    Text("Loading all employees..."),
                    Container(
                        margin: EdgeInsets.only(top: 20.0),
                        child: CircularProgressIndicator())
                  ]));
            } else {
              if (snapshot.hasError) {
                Center(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text("An error has occurred. Please try again later"),
                        Container(
                            child: ButtonTheme(
                                child: RaisedButton(
                          child: Text("Retry"),
                          onPressed: () {},
                        )))
                      ]),
                );
              } else {
                return ListView.builder(
                    itemCount: snapshot.data.data.length,
                    itemBuilder: (context, index) {
                      return Column(children: <Widget>[
                        ListTile(
                          title: Text(snapshot.data.data[index]["username"]),
                          subtitle: RichText(
                            text: TextSpan(
                                text: snapshot.data.data[index]["emp_level"]
                                    ["name"],
                                style: TextStyle(color: Colors.grey[300]),
                                children: <TextSpan>[
                                  TextSpan(
                                      text:
                                          "(${snapshot.data.data[index]["branch"]["name"]})",
                                      style: TextStyle(
                                          color: this._config.successColor))
                                ]),
                          ),
                          onTap: () {
                            var data = {
                              "type": "edit",
                              "data": snapshot.data.data[index]
                            };
                            Navigator.of(context).pushNamed(
                                "/viewSpecificEmployee",
                                arguments: data);
                          },
                        ),
                        Divider(thickness: 1.0)
                      ]);
                    });
              }
            }
          }),
    );
  }
}
