import 'package:flutter/material.dart';
import 'package:chicfavs_pos/services/http.service.dart';
import 'package:chicfavs_pos/services/config.dart';

class BranchForm extends StatefulWidget {
  dynamic data;
  BranchForm({this.data});
  @override
  _BranchFormState createState() => _BranchFormState(data: data);
}

class _BranchFormState extends State<BranchForm> {
  dynamic data;
  final _formKey = GlobalKey<FormState>();
  TextEditingController branchController = TextEditingController();
  HttpService http = new HttpService();
  Config _config = new Config();

  _BranchFormState({this.data});

  @override
  void initState() {
    super.initState();
    if (this.data["type"] == "edit") {
      this.branchController = TextEditingController(text: this.data["name"]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
              this.data["type"] == "edit" ? this.data["name"] : "New Branch"),
          centerTitle: true,
        ),
        body: Column(mainAxisAlignment: MainAxisAlignment.center, children: <
            Widget>[
          Container(
              margin: EdgeInsets.only(left: 10.0, right: 10.0),
              child: Form(
                key: this._formKey,
                child: TextFormField(
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    hintText: "Enter new branch",
                  ),
                  controller: this.branchController,
                  validator: (String employeeLevel) {
                    if (employeeLevel.isEmpty) {
                      return "Please enter the branch";
                    }
                  },
                ),
              )),
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
                                  "apiid": "saveNewBranch",
                                  "data": {"name": this.branchController.text}
                                };
                                _responseSnackBar(requestData);
                                this.branchController.clear();
                              } else {
                                var requestData = {
                                  "apiid": "updateBranch",
                                  "data": {
                                    "id": this.data["id"],
                                    "updatedBranch": this.branchController.text
                                  }
                                };
                                _responseSnackBar(requestData);
                                Navigator.of(context).pushNamed("/allBranches");
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
                                  "apiid": "saveNewBranch",
                                  "data": {"name": this.branchController.text}
                                };
                                _responseSnackBar(requestData);
                                Navigator.of(context).pushNamed("/allBranches");
                              } else {
                                var requestData = {
                                  "apiid": "deleteBranch",
                                  "data": this.data["id"]
                                };
                                _responseSnackBar(requestData);
                                this.branchController.clear();
                                Navigator.of(context).pushNamed("/allBranches");
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
              request["apiid"] == "saveNewBranch"
                  ? "Adding ${request["data"]} branch"
                  : "Updating ${request["data"]} branch",
              style: TextStyle(
                  color: request["apiid"] == "saveNewBranch"
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
              "Error occured. Please try again.",
              style: TextStyle(color: this._config.errorColor),
            ));
            Scaffold.of(context).showSnackBar(snackbar);
          } else {
            var snackbar = SnackBar(
                content: Text(
              request["apiid"] == "saveNewBranch"
                  ? "${snapshot.data.data["name"]} branch added successfully"
                  : "${snapshot.data.data["name"]} branch updated successfully",
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
