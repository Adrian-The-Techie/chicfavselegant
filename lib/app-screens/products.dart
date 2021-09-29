import 'package:flutter/material.dart';
import 'package:chicfavs_pos/services/config.dart';
import 'package:chicfavs_pos/services/http.service.dart';

class Products extends StatefulWidget {
  @override
  _ProductsScreenState createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<Products> {
  Config _config = new Config();
  HttpService _http = new HttpService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Products"), centerTitle: true),
        floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () {
              var data = {
                "type": "new",
                "data": {
                  "thumbnail": "",
                  "name": "",
                  "price": "",
                  "quantity_in_stock": ""
                }
              };
              Navigator.of(context)
                  .pushNamed("/addNewProduct", arguments: data);
            }),
        body: FutureBuilder(
            future: this._http.request({"apiid": "getAllProducts"}),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("Loading all products"),
                    Container(
                        margin: EdgeInsets.only(top: 15.0),
                        child: CircularProgressIndicator())
                  ],
                ));
              } else {
                if (snapshot.hasError) {
                  return Center(
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                        Text("Error occured. Please try again."),
                        Container(
                            child: RaisedButton(
                          color: this._config.secondaryColor,
                          child: Text("Retry"),
                          onPressed: () {
                            setState(() {});
                          },
                        ))
                      ]));
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data.data.length,
                    itemBuilder: (context, index) {
                      var quantityInStock =
                          snapshot.data.data[index]['quantity_in_stock'];
                      var thumbnail =
                          "${this._config.url}${snapshot.data.data[index]['image']}";
                      var name = snapshot.data.data[index]['name'];
                      var id = snapshot.data.data[index]['id'];
                      return Column(children: <Widget>[
                        ListTile(
                          leading:
                              // CircleAvatar(
                              //     radius: 30,
                              //     child: thumbnail == ""
                              //         ? Text("${name[0]}")
                              //         :
                              Hero(
                                  tag: id,
                                  child: Image.network(
                                    thumbnail,
                                    width: 40.0,
                                  )),
                          title: Text(name),
                          subtitle: RichText(
                              text: TextSpan(
                                  text: "Quantity in stock: ",
                                  style: TextStyle(color: Colors.black38),
                                  children: <TextSpan>[
                                TextSpan(
                                    text: "${quantityInStock} ",
                                    style: TextStyle(
                                        color: quantityInStock > 15
                                            ? this._config.successColor
                                            : quantityInStock < 15 &&
                                                    quantityInStock >= 3
                                                ? this._config.amber
                                                : this._config.errorColor)),
                                TextSpan(
                                    text: quantityInStock > 15
                                        ? "(Adequate)"
                                        : quantityInStock < 15 &&
                                                quantityInStock >= 3
                                            ? "(Amount Decreasing. Consider restocking)"
                                            : "(Needs restocking)",
                                    style: TextStyle(
                                        color: quantityInStock > 15
                                            ? this._config.successColor
                                            : quantityInStock < 15 &&
                                                    quantityInStock >= 3
                                                ? this._config.amber
                                                : this._config.errorColor))
                              ])),
                          onTap: () {
                            var data = {
                              "type": "edit",
                              "data": {
                                "id": id,
                                "thumbnail": thumbnail,
                                "name": name,
                                "price": snapshot.data.data[index]["price"],
                                "quantity_in_stock": quantityInStock,
                                "buying_price": snapshot.data.data[index]
                                    ["buying_price"],
                                "selling_price": snapshot.data.data[index]
                                    ["selling_price"],
                                "category": snapshot.data.data[index]
                                    ["category"]
                              }
                            };
                            Navigator.of(context).pushNamed(
                                "/viewSpecificProduct",
                                arguments: data);
                          },
                        ),
                        Divider(thickness: 1.0)
                      ]);
                    },
                  );
                }
              }
            }));
  }
}
