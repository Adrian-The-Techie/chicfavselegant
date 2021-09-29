import 'package:chicfavs_pos/services/config.dart';
import 'package:chicfavs_pos/services/http.service.dart';
import 'package:flutter/material.dart';
import 'package:chicfavs_pos/models/login.model.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  var _formKey = GlobalKey<FormState>();
  LoginModel _loginModel = new LoginModel();
  bool _obscureText = true;
  HttpService _http = new HttpService();
  Config _config = new Config();
  String _deviceInfo = "";

  @override
  void initState() {
    super.initState();
    this
        ._config
        .deviceInfo()
        .then((deviceInfo) => this._deviceInfo = deviceInfo);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Builder(builder: (context) {
      return ListView(children: <Widget>[
        Container(
            margin: EdgeInsets.only(top: 200.0),
            child: Column(children: <Widget>[
              CircleAvatar(
                radius: 30.0,
                child: Icon(
                  Icons.person,
                  size: 50.0,
                ),
              ),
              Container(
                  padding: EdgeInsets.only(left: 10.0, right: 10.0),
                  child: Form(
                      key: this._formKey,
                      child: Column(children: <Widget>[
                        TextFormField(
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                              hintText: "Username", icon: Icon(Icons.person)),
                          validator: (String username) {
                            if (username.isEmpty) {
                              return "Please enter your username";
                            }
                          },
                          onSaved: (String username) {
                            setState(
                                () => this._loginModel.username = username);
                          },
                        ),
                        TextFormField(
                          obscureText: this._obscureText,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                              hintText: "Password",
                              icon: Icon(Icons.security),
                              suffixIcon: IconButton(
                                  icon: this._obscureText
                                      ? Icon(Icons.visibility)
                                      : Icon(Icons.visibility_off),
                                  onPressed: () {
                                    setState(() =>
                                        this._obscureText = !this._obscureText);
                                  })),
                          validator: (String password) {
                            if (password.isEmpty) {
                              return "Please enter your password";
                            }
                          },
                          onSaved: (String password) {
                            setState(
                                () => this._loginModel.password = password);
                          },
                        )
                      ]))),
              Container(
                margin: EdgeInsets.only(
                    top: 20.0, right: 20.0, bottom: 20.0, left: 50.0),
                child: ButtonTheme(
                    minWidth: 280.0,
                    height: 40.0,
                    child: RaisedButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0)),
                        child: Text(
                          "LOGIN",
                          style: TextStyle(
                              fontSize: 20.0, color: Color(0xFFF9F8F9)),
                        ),
                        onPressed: () {
                          this._config.responseSnackbar(context,
                              "Logging you in...", this._config.primaryColor);
                          this._login(context);
                        })),
              )
            ])),
      ]);
    }));
  }

  _login(context) {
    final _formState = this._formKey.currentState;
    if (_formState.validate()) {
      _formState.save();
      var request = {
        "apiid": "login",
        "data": {
          "username": this._loginModel.username,
          "password": this._loginModel.password,
          "device_info": this._deviceInfo
        }
      };
      this._http.request(request).then((response) {
        if (response.status == 1) {
          this._config.responseSnackbar(
              context, response.data["message"], this._config.successColor);
          this._config.setInt("login", 1);
          this._config.setInt("level", response.data["level"]);
          this._config.setInt("user_id", response.data["user_id"]);
          Navigator.of(context).pushNamed("/home");
        } else {
          this._config.responseSnackbar(
              context, response.data, this._config.errorColor);
        }
      });
    }
  }
}
