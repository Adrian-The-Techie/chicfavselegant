import 'package:flutter/material.dart';
import 'package:chicfavs_pos/services/config.dart';
import 'package:chicfavs_pos/services/http.service.dart';

class EmployeeScreen extends StatefulWidget {
  final dynamic data;
  EmployeeScreen({this.data});

  _EmployeeScreenState createState() => _EmployeeScreenState(data: data);
}

class _EmployeeScreenState extends State<EmployeeScreen> {
  dynamic data;
  var _formKey = GlobalKey<FormState>();

  TextEditingController _nameController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _residenceController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();

  Config _config = new Config();

  HttpService _http = new HttpService();

  bool _passwordObscureText = true;
  bool _confirmPasswordObscureText = true;

  _EmployeeScreenState({this.data});

  List _employeeLevels = [];
  List _branches = [];

  var _selectedLevel;
  var _selectedBranch;

  @override
  void initState() {
    super.initState();
    const levelRequest = {"apiid": "loadEmployeeLevels"};
    const branchRequest = {"apiid": "getBranches"};
    this._http.request(levelRequest).then((level) {
      setState(() {
        this._employeeLevels = level.data;
      });
    });
    this._http.request(branchRequest).then((level) {
      setState(() {
        this._branches = level.data;
      });
    });
    if (this.data["type"] == "edit") {
      this._nameController =
          new TextEditingController(text: this.data["data"]["username"]);
      this._phoneController =
          new TextEditingController(text: this.data["data"]["phone_number"]);
      this._emailController =
          new TextEditingController(text: this.data["data"]["email"]);
      this._residenceController = new TextEditingController(
          text: this.data["data"]["place_of_residence"]);

      this._selectedLevel = this.data["data"]["emp_level"]["id"];
      this._selectedBranch = this.data["data"]["branch"]["id"];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(this.data["type"] == "edit"
              ? this.data["data"]["username"]
              : "New Employee"),
          centerTitle: true,
        ),
        body: Builder(builder: (context) {
          return ListView(children: <Widget>[
            Padding(
                padding: EdgeInsets.all(10.0),
                child: Form(
                    key: this._formKey,
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                              hintText: "Full names", icon: Icon(Icons.person)),
                          controller: this._nameController,
                          validator: (String name) {
                            if (name.isEmpty) {
                              return "Please enter employee's name";
                            }
                          },
                        ),
                        TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                              hintText: "Email Address",
                              icon: Icon(Icons.email)),
                          controller: this._emailController,
                        ),
                        TextFormField(
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              hintText: "Phone number",
                              icon: Icon(Icons.phone)),
                          controller: this._phoneController,
                          validator: (String name) {
                            if (name.isEmpty) {
                              return "Please enter phone number";
                            }
                          },
                        ),
                        TextFormField(
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                              hintText: "Place of Residence",
                              icon: Icon(Icons.home)),
                          controller: this._residenceController,
                        ),
                        Container(
                            margin: EdgeInsets.only(left: 37.0, top: 10.0),
                            child: DropdownButton<int>(
                              items: this._employeeLevels.map((level) {
                                return DropdownMenuItem<int>(
                                    value: level["id"],
                                    child: Text(level["name"]));
                              }).toList(),
                              hint: Text("Select Employee Level"),
                              value: _selectedLevel,
                              onChanged: (value) {
                                setState(() => this._selectedLevel = value);
                                //this._selectedValue = value;
                              },
                              isExpanded: true,
                            )),
                        Container(
                            margin: EdgeInsets.only(left: 37.0, top: 10.0),
                            child: DropdownButton<int>(
                              items: this._branches.map((branch) {
                                return DropdownMenuItem<int>(
                                    value: branch["id"],
                                    child: Text(branch["name"]));
                              }).toList(),
                              hint: Text("Select Branch"),
                              value: _selectedBranch,
                              onChanged: (value) {
                                setState(() {
                                  this._selectedBranch = value;
                                });
                                //this._selectedValue = value;
                              },
                              isExpanded: true,
                            )),
                        this.data["type"] == "new"
                            ? Container(
                                child: Column(children: <Widget>[
                                TextFormField(
                                    obscureText: this._passwordObscureText,
                                    keyboardType: TextInputType.text,
                                    decoration: InputDecoration(
                                        hintText: "Password",
                                        icon: Icon(Icons.security),
                                        suffixIcon: IconButton(
                                            icon: this._passwordObscureText
                                                ? Icon(Icons.visibility)
                                                : Icon(Icons.visibility_off),
                                            onPressed: () {
                                              setState(() => this
                                                      ._passwordObscureText =
                                                  !this._passwordObscureText);
                                            })),
                                    controller: this._passwordController,
                                    validator: (String name) {
                                      if (name.isEmpty) {
                                        return "Please enter password";
                                      }
                                    }),
                                TextFormField(
                                    obscureText:
                                        this._confirmPasswordObscureText,
                                    keyboardType: TextInputType.text,
                                    decoration: InputDecoration(
                                        hintText: "Confirm New Password",
                                        icon: Icon(Icons.compare),
                                        suffixIcon: IconButton(
                                            icon: this
                                                    ._confirmPasswordObscureText
                                                ? Icon(Icons.visibility)
                                                : Icon(Icons.visibility_off),
                                            onPressed: () {
                                              setState(() => this
                                                      ._confirmPasswordObscureText =
                                                  !this
                                                      ._confirmPasswordObscureText);
                                            })),
                                    controller: this._confirmPasswordController,
                                    validator: (String name) {
                                      if (name.isEmpty) {
                                        return "Please enter password to confirm";
                                      }
                                      if (this._passwordController.text !=
                                          name) {
                                        return "Passwords do not match. Please try again";
                                      }
                                    })
                              ]))
                            : Container(height: 0.0),
                        Container(
                            margin: EdgeInsets.all(15.0),
                            child: Row(children: <Widget>[
                              Expanded(
                                  child: RaisedButton(
                                elevation: 8.0,
                                color: this.data["type"] == "edit"
                                    ? this._config.secondaryColor
                                    : this._config.primaryColor,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0)),
                                child: Text(
                                  this.data["type"] == "edit"
                                      ? "Update"
                                      : "Save and New",
                                  style: TextStyle(
                                      color: this._config.buttonFontColor,
                                      fontSize: 17.0),
                                ),
                                onPressed: () {
                                  var _formState = this._formKey.currentState;
                                  if (_formState.validate()) {
                                    if (this.data["type"] == "edit") {
                                      var data = {
                                        "apiid": "updateEmployeeDetails",
                                        "data": {
                                          "id": this.data["data"]["id"],
                                          "username": this._nameController.text,
                                          "phone_number":
                                              this._phoneController.text,
                                          "email": this._emailController.text,
                                          "branch": this._selectedBranch,
                                          "place_of_residence":
                                              this._residenceController.text,
                                          "emp_level": this._selectedLevel,
                                          "password": this.data["data"]
                                              ["password"]
                                        }
                                      };
                                      _responseSnackBar(context, data);
                                      Navigator.of(context).pop();
                                    } else {
                                      var data = {
                                        "apiid": "saveEmployee",
                                        "data": {
                                          "name": this._nameController.text,
                                          "phone": this._phoneController.text,
                                          "email": this._emailController.text,
                                          "residence":
                                              this._residenceController.text,
                                          "emp_level": this._selectedLevel,
                                          "branch": this._selectedBranch,
                                          "password":
                                              this._passwordController.text
                                        }
                                      };
                                      _responseSnackBar(context, data);
                                      this._nameController.clear();
                                      this._emailController.clear();
                                      this._phoneController.clear();
                                      this._residenceController.clear();
                                      this._passwordController.clear();
                                      this._confirmPasswordController.clear();
                                      setState(() {
                                        this._selectedLevel = null;
                                        this._selectedBranch = null;
                                      });
                                    }
                                  }
                                },
                              )),
                              SizedBox(width: 20.0),
                              Expanded(
                                  child: RaisedButton(
                                elevation: 8.0,
                                color: this.data["type"] == "edit"
                                    ? this._config.errorColor
                                    : this._config.successColor,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0)),
                                child: Text(
                                  this.data["type"] == "edit"
                                      ? "Delete"
                                      : "Save",
                                  style: TextStyle(
                                      color: this._config.buttonFontColor,
                                      fontSize: 17.0),
                                ),
                                onPressed: () {
                                  var _formState = this._formKey.currentState;

                                  if (_formState.validate()) {
                                    if (this.data["type"] == "new") {
                                      var data = {
                                        "apiid": "saveEmployee",
                                        "data": {
                                          "name": this._nameController.text,
                                          "phone": this._phoneController.text,
                                          "email": this._emailController.text,
                                          "residence":
                                              this._residenceController.text,
                                          "emp_level": this._selectedLevel,
                                          "branch": this._selectedBranch,
                                          "password":
                                              this._passwordController.text
                                        }
                                      };
                                      _responseSnackBar(context, data);
                                      Navigator.of(context).pop();
                                    } else {
                                      data = {
                                        "apiid": "deleteEmployee",
                                        "data": {"id": this.data["data"]["id"]}
                                      };
                                      _responseSnackBar(context, data);
                                      Navigator.of(context).pop();
                                    }
                                  }
                                },
                              )),
                            ]))
                      ],
                    )))
          ]);
        }));
  }

  _responseSnackBar(context, request) {
    var snackbar = SnackBar(
      content: FutureBuilder(
          future: this._http.request(request),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Text(
                  request["apiid"] == "saveEmployee"
                      ? "Adding employee..."
                      : request["apiid"] == "updateEmployeeDetails"
                          ? "Updating ${request["data"]["name"]}'s details..."
                          : "Deleting employee...",
                  style: TextStyle(
                      color: request["apiid"] == "saveEmployee"
                          ? this._config.primaryColor
                          : request["apiid"] == "updateEmployeeDetails"
                              ? this._config.secondaryColor
                              : this._config.errorColor));
            } else {
              if (snapshot.hasError) {
                return Text("Error occured. Please try again",
                    style: TextStyle(color: this._config.errorColor));
              }
              if (snapshot.data.status == 1) {
                return RichText(
                  text: TextSpan(
                      text: request["apiid"] == "saveEmployee" ||
                              request["apiid"] == "updateEmployeeDetails"
                          ? "${request['data']['name']}"
                          : "${this._nameController.text}",
                      children: <TextSpan>[
                        TextSpan(
                            text: request["apiid"] == "saveEmployee"
                                ? " added "
                                : request["apiid"] == "updateEmployeeDetails"
                                    ? " updated "
                                    : " deleted "),
                        TextSpan(text: "successfuly")
                      ],
                      style: TextStyle(
                        color: request["apiid"] == "saveEmployee"
                            ? this._config.successColor
                            : request["apiid"] == "updateEmployeeDetails"
                                ? this._config.primaryColor
                                : this._config.errorColor,
                      )),
                );
              }
            }
          }),
      duration: Duration(seconds: 8),
    );
    Scaffold.of(context).showSnackBar(snackbar);
  }
}
