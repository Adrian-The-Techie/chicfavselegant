import 'package:flutter/material.dart';
import 'package:chicfavs_pos/services/http.service.dart';
import 'package:chicfavs_pos/services/config.dart';

class NewEmployeeLevel extends StatefulWidget {
  dynamic data;
  NewEmployeeLevel({this.data});
  @override
  _NewEmployeeLevel createState() => _NewEmployeeLevel(data: data);
}

class _NewEmployeeLevel extends State<NewEmployeeLevel> {
  dynamic data;
  final _formKey = GlobalKey<FormState>();
  TextEditingController employeeLevelController = TextEditingController();
  HttpService http = new HttpService();
  Config _config = new Config();
  List _levels = [
    {"id": 1, "level": "Level 1"},
    {"id": 2, "level": "Level 2"},
    {"id": 3, "level": "Level 3"}
  ];

  int _selectedLevel;

  _NewEmployeeLevel({this.data});

  @override
  void initState() {
    super.initState();
    if (this.data["type"] == "edit") {
      this.employeeLevelController =
          TextEditingController(text: this.data["name"]);
      this._selectedLevel = this.data["level"];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(this.data["type"] == "edit"
              ? this.data["name"]
              : "New Employee Level"),
          centerTitle: true,
        ),
        body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                  margin: EdgeInsets.only(left: 10.0, right: 10.0),
                  child: Form(
                      key: this._formKey,
                      child: Column(children: <Widget>[
                        TextFormField(
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            hintText: "Enter new employee level",
                          ),
                          controller: this.employeeLevelController,
                          validator: (String employeeLevel) {
                            if (employeeLevel.isEmpty) {
                              return "Please enter employee level";
                            }
                          },
                        ),
                        DropdownButton<int>(
                          hint: Text("Select level"),
                          isExpanded: true,
                          items: this._levels.map((level) {
                            return DropdownMenuItem<int>(
                                value: level["id"],
                                child: Text(level["level"]));
                          }).toList(),
                          value: this._selectedLevel,
                          onChanged: (int level) {
                            setState(() {
                              this._selectedLevel = level;
                            });
                          },
                        )
                      ]))),
              Container(
                margin: EdgeInsets.all(15.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                        child: RaisedButton(
                            color: this.data["type"] == "edit"
                                ? this._config.secondaryColor
                                : this._config.primaryColor,
                            elevation: 10.0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0)),
                            child: Text(
                              this.data["type"] == "edit"
                                  ? "Update"
                                  : "Save and new",
                              style: TextStyle(
                                  color: Color(0xFFF9F8F8), fontSize: 17.0),
                            ),
                            onPressed: () {
                              setState(() {
                                var _formState = this._formKey.currentState;
                                if (_formState.validate()) {
                                  if (this.data["type"] == "new") {
                                    var requestData = {
                                      "apiid": "saveEmployeeLevels",
                                      "data": {
                                        "name":
                                            this.employeeLevelController.text,
                                        "level": this._selectedLevel,
                                      }
                                    };
                                    _responseSnackBar(requestData);
                                    this.employeeLevelController.clear();
                                  } else {
                                    var requestData = {
                                      "apiid": "updateEmployeeLevel",
                                      "data": {
                                        "id": this.data["id"],
                                        "updatedLevel":
                                            this.employeeLevelController.text,
                                        "level": this._selectedLevel,
                                      }
                                    };
                                    _responseSnackBar(requestData);
                                    Navigator.of(context)
                                        .pushNamed("/allEmployeeLevels");
                                  }
                                }
                              });
                            })),
                    SizedBox(
                      width: 20.0,
                    ),
                    Expanded(
                        child: RaisedButton(
                            color: this.data["type"] == "edit"
                                ? this._config.errorColor
                                : this._config.successColor,
                            elevation: 10.0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0)),
                            child: Text(
                              this.data["type"] == "edit" ? "Delete" : "Save",
                              style: TextStyle(
                                  color: Color(0xFFF9F8F8), fontSize: 17.0),
                            ),
                            onPressed: () {
                              var _formState = this._formKey.currentState;
                              setState(() {
                                if (_formState.validate()) {
                                  if (this.data["type"] == "new") {
                                    var requestData = {
                                      "apiid": "saveEmployeeLevels",
                                      "data": {
                                        "name":
                                            this.employeeLevelController.text,
                                        "level": this._selectedLevel,
                                      }
                                    };
                                    _responseSnackBar(requestData);
                                    Navigator.of(context)
                                        .pushNamed("/allEmployeeLevels");
                                  } else {
                                    var requestData = {
                                      "apiid": "deleteEmployeeLevel",
                                      "data": this.data["id"]
                                    };
                                    _responseSnackBar(requestData);
                                    this.employeeLevelController.clear();
                                    Navigator.of(context)
                                        .pushNamed("/allEmployeeLevels");
                                  }
                                }
                              });
                            })),
                  ],
                ),
              )
            ]));
  }

  _responseSnackBar(request) {
    FutureBuilder(
      future: this.http.request(request),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          var snackbar = SnackBar(
            content: Text(
              request["apiid"] == "saveEmployeeLevel"
                  ? "Adding ${request["data"]} level"
                  : "Updating ${request["data"]} level",
              style: TextStyle(
                  color: request["apiid"] == "saveEmployeeLevel"
                      ? this._config.primaryColor
                      : this._config.secondaryColor),
            ),
          );
          Scaffold.of(context).showSnackBar(snackbar);
        }
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError || snapshot.data.data["id"] == null) {
            var snackbar = SnackBar(
                content: Text(
              "Error occured. Please try again",
              style: TextStyle(color: this._config.errorColor),
            ));
            Scaffold.of(context).showSnackBar(snackbar);
          } else {
            var snackbar = SnackBar(
                content: Text(
              request["apiid"] == "saveEmployeeLevel"
                  ? "${snapshot.data.data["name"]} level added successfully"
                  : "${snapshot.data.data["name"]} level updated successfully",
              style: TextStyle(
                color: this._config.successColor,
              ),
            ));
            Scaffold.of(context).showSnackBar(snackbar);
          }
        }
      },
    );
  }
}
