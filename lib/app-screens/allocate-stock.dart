import 'package:chicfavs_pos/services/config.dart';
import 'package:chicfavs_pos/services/http.service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';

class AllocateStock extends StatefulWidget {
  _AllocateStockState createState() => _AllocateStockState();
}

class _AllocateStockState extends State<AllocateStock> {
  Config _config = new Config();
  HttpService _http = new HttpService();
  List _suggestions = [];
  List _selectedProducts = [];
  int _userId;

  double _grandTotal = 0.00;

  GlobalKey<AutoCompleteTextFieldState> _salesPeopleKey = new GlobalKey();
  GlobalKey<AutoCompleteTextFieldState> _productsKey = new GlobalKey();

  Map<String, dynamic> _selectedSalesPerson;
  bool _showSalesperson = false;

  @override
  void initState() {
    super.initState();
    this._config.getInt("user_id").then((value) {
      setState(() {
        this._userId = value;
        print(value);
      });
    });
    // this._http.request({"apiid": "getUserAndProducts"}).then((value) {
    //   setState(() {
    //     this._suggestions = value.data;
    //   });
    // });
  }

  Future<double> editQuantity(BuildContext context, item) {
    TextEditingController quantity =
        new TextEditingController(text: item["quantity_allocated"].toString());
    var _formKey = new GlobalKey<FormState>();

    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Edit quantity"),
            content: Form(
                key: _formKey,
                child: TextFormField(
                    keyboardType: TextInputType.number,
                    controller: quantity,
                    validator: (String quantity) {
                      var quantityInStock = item["quantity_in_stock"];
                      if (quantity.isEmpty) {
                        return "Please fill in quantity details";
                      }
                      if (double.parse(quantity) >
                          double.parse(quantityInStock)) {
                        return "Quantity exceeded what is in stock.\nPlease select a lower amount.\nQuantity in stock is ${item['quantity_in_stock'].toString()}";
                      }
                    })),
            actions: [
              RaisedButton(
                child: Text("OK",
                    style: TextStyle(color: this._config.successColor)),
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    Navigator.of(context).pop(double.parse(quantity.text));
                  }
                },
              )
            ],
          );
        });
  }

  responseSnackbar(BuildContext context, String message, Color textColor) {
    var snackbar = new SnackBar(
        content: Text(message, style: TextStyle(color: textColor)));
    Scaffold.of(context).showSnackBar(snackbar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder(
            future: this._http.request({"apiid": "getUserAndProducts"}),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("Loading..."),
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
                  return ListView(
                    children: <Widget>[
                      Container(
                        height: 230.0,
                        decoration: BoxDecoration(
                            color: Colors.blue[50],
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.elliptical(50, 27),
                                bottomRight: Radius.elliptical(50, 27))),
                        child: Column(
                          children: [
                            Container(
                                margin: EdgeInsets.only(
                                    left: 20.0, right: 20.0, top: 10.0),
                                child: RichText(
                                    textAlign: TextAlign.center,
                                    text: TextSpan(
                                        text: "GRAND TOTAL VALUE: ",
                                        style: TextStyle(
                                            fontSize: 20.0,
                                            color: Colors.black),
                                        children: <TextSpan>[
                                          TextSpan(
                                              text:
                                                  "${this._config.parseCurrency(this._grandTotal)}",
                                              style: TextStyle(
                                                  fontSize: 25.0,
                                                  color: this
                                                      ._config
                                                      .successColor))
                                        ]))),
                            Container(
                                margin: EdgeInsets.only(
                                    left: 20.0, right: 20.0, top: 2.0),
                                child: this._showSalesperson == false
                                    ? AutoCompleteTextField(
                                        key: this._salesPeopleKey,
                                        decoration: InputDecoration(
                                            hintText: "Search for salesperson"),
                                        suggestions:
                                            snapshot.data.data["salesPeople"],
                                        itemSubmitted: (person) {
                                          setState(() {
                                            this._selectedSalesPerson = person;
                                            this._showSalesperson = true;
                                          });
                                        },
                                        itemFilter: (person, query) {
                                          return person["username"]
                                              .toLowerCase()
                                              .startsWith(query.toLowerCase());
                                        },
                                        itemSorter: (a, b) {
                                          return a["username"]
                                              .compareTo(b["username"]);
                                        },
                                        itemBuilder: (context, person) {
                                          return Container(
                                            margin:
                                                EdgeInsets.only(bottom: 20.0),
                                            padding: EdgeInsets.only(
                                                top: 5.0,
                                                left: 5.0,
                                                right: 5.0),
                                            child: Text(
                                              person["username"],
                                              style: TextStyle(
                                                  color: Colors.black),
                                            ),
                                          );
                                        })
                                    : Container(
                                        margin: EdgeInsets.only(top: 7.0),
                                        child: RichText(
                                            textAlign: TextAlign.center,
                                            text: TextSpan(
                                                text: "Allocate to: ",
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 18.0),
                                                children: <TextSpan>[
                                                  TextSpan(
                                                      text:
                                                          this._selectedSalesPerson[
                                                              "username"],
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold))
                                                ])),
                                      )),
                            Container(
                              margin: EdgeInsets.only(
                                  left: 20.0, right: 20.0, top: 7.0),
                              child: AutoCompleteTextField(
                                  key: this._productsKey,
                                  decoration: InputDecoration(
                                      hintText: "Search for products"),
                                  suggestions: snapshot.data.data["products"],
                                  itemSubmitted: (item) {
                                    if (item["quantity_in_stock"] == 0) {
                                      responseSnackbar(
                                          context,
                                          "Quantity in stock of of ${item['name']} is 0. Please consider restocking",
                                          this._config.errorColor);
                                    } else {
                                      setState(() {
                                        var selectedItem = {
                                          "product_allocated": item["id"],
                                          "name": item["name"],
                                          "quantity_allocated": 1,
                                          "selling_price":
                                              item["selling_price"],
                                          "quantity_in_stock":
                                              item["quantity_in_stock"]
                                                  .toString()
                                        };
                                        var subTotal = item["selling_price"] *
                                            selectedItem["quantity_allocated"];
                                        selectedItem["sub_total"] = subTotal;
                                        this
                                            ._selectedProducts
                                            .add(selectedItem);
                                        this._grandTotal = this
                                            ._selectedProducts
                                            .map((item) => item["sub_total"])
                                            .reduce((a, b) => a + b);
                                      });
                                    }
                                  },
                                  itemFilter: (item, query) {
                                    return item["name"]
                                        .toLowerCase()
                                        .startsWith(query.toLowerCase());
                                  },
                                  itemSorter: (a, b) {
                                    return a["name"].compareTo(b["name"]);
                                  },
                                  itemBuilder: (context, item) {
                                    var quantityInStock =
                                        item["quantity_in_stock"];
                                    return Container(
                                        margin: EdgeInsets.only(bottom: 20.0),
                                        padding: EdgeInsets.only(
                                            top: 5.0, left: 5.0, right: 5.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              item["name"],
                                              style: TextStyle(
                                                  color: Colors.brown),
                                            ),
                                            Text(quantityInStock.toString(),
                                                style: TextStyle(
                                                    color: quantityInStock > 15
                                                        ? this
                                                            ._config
                                                            .successColor
                                                        : quantityInStock > 5 &&
                                                                quantityInStock <
                                                                    15
                                                            ? this._config.amber
                                                            : this
                                                                ._config
                                                                .errorColor))
                                          ],
                                        ));
                                  }),
                            ),
                            Container(
                                margin: EdgeInsets.only(
                                    left: 20.0, right: 20.0, top: 7.0),
                                child: ButtonTheme(
                                    minWidth: 250.0,
                                    child: RaisedButton(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20.0)),
                                        child: Text("ALLOCATE STOCK",
                                            style:
                                                TextStyle(color: Colors.white)),
                                        onPressed: () {
                                          if (this._selectedProducts.length >
                                              0) {
                                            this
                                                ._selectedProducts
                                                .forEach((element) {
                                              element.remove("name");
                                              element
                                                  .remove("quantity_in_stock");
                                              element.remove("selling_price");
                                            });
                                            var request = {
                                              "apiid": "allocateStock",
                                              "data": {
                                                "items": this._selectedProducts,
                                                "allocated_to": this
                                                    ._selectedSalesPerson["id"],
                                                "allocated_by": this._userId
                                              }
                                            };
                                            print(request);
                                            responseSnackbar(
                                                context,
                                                "Allocating stock",
                                                this._config.primaryColor);
                                            this
                                                ._http
                                                .request(request)
                                                .then((response) {
                                              if (response.status == 1) {
                                                responseSnackbar(
                                                    context,
                                                    response.data,
                                                    this._config.successColor);
                                                setState(() {
                                                  this._grandTotal = 0.00;
                                                  this._selectedProducts = [];
                                                  this._showSalesperson = false;
                                                  this._selectedSalesPerson =
                                                      {};
                                                });
                                              } else {
                                                responseSnackbar(
                                                    context,
                                                    "Error occurred. Please try again later",
                                                    this._config.errorColor);
                                              }
                                            });

                                            // print(response);
                                          }
                                          // responseSnackbar(context, request);
                                          else {
                                            responseSnackbar(
                                                context,
                                                "Please select products",
                                                this._config.errorColor);
                                          }
                                        })))
                          ],
                        ),
                      ),
                      DataTable(
                          columns: <DataColumn>[
                            DataColumn(label: Text("Name")),
                            DataColumn(label: Text("Quantity")),
                            DataColumn(label: Text("Sub-Total")),
                          ],
                          rows: this
                              ._selectedProducts
                              .map((item) => DataRow(cells: [
                                    DataCell(Text(item["name"])),
                                    DataCell(
                                        Text(item["quantity_allocated"]
                                            .toString()),
                                        showEditIcon: true, onTap: () {
                                      editQuantity(context, item)
                                          .then((quantity) {
                                        if (quantity != null) {
                                          setState(() {
                                            item.remove("quantity_in_stock");
                                            item["quantity_allocated"] =
                                                quantity;
                                            item["sub_total"] =
                                                item["quantity_allocated"] *
                                                    item["selling_price"];
                                            this._grandTotal = this
                                                ._selectedProducts
                                                .map(
                                                    (item) => item["sub_total"])
                                                .reduce((a, b) => a + b);
                                          });
                                        }
                                      });
                                    }),
                                    DataCell(Row(children: <Widget>[
                                      Expanded(
                                          child: Text(this
                                              ._config
                                              .parseCurrency(item["sub_total"])
                                              .toString())),
                                      Expanded(
                                          child: IconButton(
                                              icon: Icon(Icons.clear,
                                                  color:
                                                      this._config.errorColor),
                                              onPressed: () {
                                                setState(() {
                                                  this
                                                      ._selectedProducts
                                                      .remove(item);
                                                  if (this
                                                          ._selectedProducts
                                                          .length >
                                                      0) {
                                                    this._grandTotal = this
                                                        ._selectedProducts
                                                        .map((item) =>
                                                            item["sub_total"])
                                                        .reduce(
                                                            (a, b) => a + b);
                                                  } else {
                                                    this._selectedProducts = [];
                                                    this._grandTotal = 0.00;
                                                  }
                                                });
                                              }))
                                    ])),
                                  ]))
                              .toList())
                    ],
                  );
                }
              }
            }));
  }
}
