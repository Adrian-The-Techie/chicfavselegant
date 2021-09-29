import 'package:flutter/material.dart';
import 'package:chicfavs_pos/services/http.service.dart';
import 'package:chicfavs_pos/services/config.dart';

class CategoryForm extends StatefulWidget {
  dynamic data;
  CategoryForm({this.data});
  @override
  _CategoryFormState createState() => _CategoryFormState(data: data);
}

class _CategoryFormState extends State<CategoryForm> {
  dynamic data;
  final _formKey = GlobalKey<FormState>();
  TextEditingController _categoryController = TextEditingController();
  HttpService http = new HttpService();
  Config _config = new Config();

  _CategoryFormState({this.data});

  @override
  void initState() {
    super.initState();
    if (this.data["type"] == "edit") {
      this._categoryController = TextEditingController(text: this.data["name"]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
              this.data["type"] == "edit" ? this.data["name"] : "New Category"),
          centerTitle: true,
        ),
        body: Builder(builder: (context) {
          return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                    margin: EdgeInsets.only(left: 10.0, right: 10.0),
                    child: Form(
                      key: this._formKey,
                      child: TextFormField(
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          hintText: "Enter new category",
                        ),
                        controller: this._categoryController,
                        validator: (String category) {
                          if (category.isEmpty) {
                            return "Please enter the category";
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
                                        "apiid": "saveNewCategory",
                                        "data": {
                                          "name": this._categoryController.text
                                        }
                                      };
                                      _responseSnackBar(context, requestData);
                                      this._categoryController.clear();
                                    } else {
                                      var requestData = {
                                        "apiid": "updateCategory",
                                        "data": {
                                          "id": this.data["id"],
                                          "updatedCategory":
                                              this._categoryController.text
                                        }
                                      };
                                      _responseSnackBar(context, requestData);
                                      Navigator.of(context)
                                          .pushNamed("/allCategories");
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
                                        "apiid": "saveNewCategory",
                                        "data": {
                                          "name": this._categoryController.text
                                        }
                                      };
                                      _responseSnackBar(context, requestData);
                                      Navigator.of(context)
                                          .pushNamed("/allCategories");
                                    } else {
                                      var requestData = {
                                        "apiid": "deleteCategory",
                                        "data": this.data["id"]
                                      };
                                      _responseSnackBar(context, requestData);
                                      this._categoryController.clear();
                                      Navigator.of(context)
                                          .pushNamed("/allCategories");
                                    }
                                  }
                                });
                              })),
                    ],
                  ),
                )
              ]);
        }));
  }

  _responseSnackBar(BuildContext context, request) {
    var snackbar = SnackBar(
        content: FutureBuilder(
      future: this.http.request(request),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text(
            request["apiid"] == "saveNewCategory"
                ? "Adding ${request["data"]} category"
                : "Updating ${request["data"]} category",
            style: TextStyle(
                color: request["apiid"] == "saveNewCategory"
                    ? this._config.primaryColor
                    : this._config.secondaryColor),
          );
        }
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return Text(
              "Error occured. Please try again.",
              style: TextStyle(color: this._config.errorColor),
            );
          } else {
            return Text(
              request["apiid"] == "saveNewCategory"
                  ? "${snapshot.data.data["name"]} category added successfully"
                  : request["apiid"] == "updateCategory"
                      ? "${snapshot.data.data["name"]} category updated successfully"
                      : "${snapshot.data.data}",
              style: TextStyle(
                color: this._config.successColor,
              ),
            );
          }
        }
      },
    ));
    Scaffold.of(context).showSnackBar(snackbar);
  }
}
