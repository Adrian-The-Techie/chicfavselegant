import 'package:chicfavs_pos/services/config.dart';
import 'package:chicfavs_pos/services/http.service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';

class NormalSale extends StatefulWidget {
  _NormalSaleState createState() => _NormalSaleState();
}

class _NormalSaleState extends State<NormalSale> {
  Config _config = new Config();
  HttpService _http = new HttpService();
  List _suggestions;
  List _selectedProducts = [];

  double _grandTotal = 0.00;

  GlobalKey<AutoCompleteTextFieldState> key = new GlobalKey();

  int _userId;
  @override
  void initState() {
    super.initState();
    // this._http.request({"apiid": "getAllProducts"}).then((value) {
    //   setState(() {
    //     this._suggestions = value.data;
    //   });
    // });
    this._config.getInt("user_id").then((userId) {
      setState(() {
        this._userId = userId;
      });
    });
  }

  Future<double> editQuantity(BuildContext context, item) {
    TextEditingController quantity =
        new TextEditingController(text: item["quantity_sold"].toString());
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

  Future paymentModal(context) {
    final _key = new GlobalKey<FormState>();
    TextEditingController _phoneController =
        new TextEditingController(text: "+254");
    return showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, StateSetter setState) {
            return Dialog(
                // title: Text("Payment", textAlign: TextAlign.center),
                child: Container(
              child: Form(
                  key: _key,
                  child:
                      Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                    SizedBox(
                      height: 2.0,
                    ),
                    Text(
                      "Provide phone number to send receipt to.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.w700, fontSize: 18.0),
                    ),
                    Divider(
                      thickness: 1.0,
                    ),
                    SizedBox(
                      height: 8.0,
                    ),
                    SizedBox(height: 10.0),
                    Expanded(
                        flex: 0,
                        child: Container(
                            padding: EdgeInsets.only(left: 5.0, right: 5.0),
                            child: TextFormField(
                              keyboardType: TextInputType.phone,
                              decoration: InputDecoration(
                                  hintText: "Phone number to send receipt to."),
                              controller: _phoneController,
                              validator: (String phone) {
                                if (phone.isEmpty) {
                                  return "Please enter phone number to send receipt to";
                                }
                                if (phone.length < 10) {
                                  return "Enter a valid phone number";
                                }
                              },
                            ))),
                    SizedBox(height: 10.0),
                    Divider(thickness: 1.0),
                    Container(
                        margin: EdgeInsets.only(left: 5.0, right: 5.0),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                                child: ButtonTheme(
                                    buttonColor: this._config.errorColor,
                                    minWidth: 200.0,
                                    child: RaisedButton(
                                        elevation: 8.0,
                                        child: Text("Cancel"),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        }))),
                            SizedBox(width: 5.0),
                            Expanded(
                                child: ButtonTheme(
                                    buttonColor: this._config.successColor,
                                    minWidth: 200.0,
                                    child: RaisedButton(
                                        elevation: 8.0,
                                        child: Text("Take payment",
                                            style:
                                                TextStyle(color: Colors.white)),
                                        onPressed: () {
                                          if (_key.currentState.validate()) {
                                            var paymentDetails = {
                                              "phoneNumber":
                                                  _phoneController.text
                                            };
                                            Navigator.of(context)
                                                .pop(paymentDetails);
                                          }
                                        })))
                          ],
                        ))
                  ])),
            ));
          });
        });
  }

  responseSnackbar(BuildContext context, String message, Color textColor) {
    var snackbar = new SnackBar(
        content: Text(message, style: TextStyle(color: textColor)));
    Scaffold.of(context).showSnackBar(snackbar);
  }

  @override
  Widget build(BuildContext context) {
    var request = {
      "apiid": "getSellingProducts",
      "data": {"type_of_sale": 1}
    };
    return Scaffold(
        body: FutureBuilder(
            future: this._http.request(request),
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
                        height: 200.0,
                        decoration: BoxDecoration(
                            color: Colors.blue[50],
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.elliptical(50, 27),
                                bottomRight: Radius.elliptical(50, 27))),
                        child: Stack(
                          children: [
                            Positioned(
                                left: 50.0,
                                right: 50.0,
                                top: 30.0,
                                child: RichText(
                                    textAlign: TextAlign.center,
                                    text: TextSpan(
                                        text: "GRAND TOTAL: ",
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
                            Positioned(
                                left: 50.0,
                                right: 50.0,
                                top: 60.0,
                                child: Container(
                                  child: AutoCompleteTextField(
                                      key: this.key,
                                      suggestions: snapshot.data.data,
                                      decoration: InputDecoration(
                                          hintText: "Search for products"),
                                      itemSubmitted: (item) {
                                        if (item["quantity_in_stock"] == 0) {
                                          responseSnackbar(
                                              context,
                                              "Quantity in stock of of ${item['name']} is 0. Please consider restocking",
                                              this._config.errorColor);
                                        } else {
                                          setState(() {
                                            var selectedItem = {
                                              "product_sold": item["id"],
                                              "name": item["name"],
                                              "quantity_sold": 1,
                                              "buying_price":
                                                  item["buying_price"],
                                              "price": item["selling_price"],
                                              "quantity_in_stock":
                                                  item["quantity_in_stock"]
                                                      .toString()
                                            };
                                            var subTotal = item[
                                                    "selling_price"] *
                                                selectedItem["quantity_sold"];
                                            selectedItem["sub_total"] =
                                                subTotal;
                                            this
                                                ._selectedProducts
                                                .add(selectedItem);
                                            this._grandTotal = this
                                                ._selectedProducts
                                                .map(
                                                    (item) => item["sub_total"])
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
                                            margin:
                                                EdgeInsets.only(bottom: 20.0),
                                            padding: EdgeInsets.only(
                                                top: 5.0,
                                                left: 5.0,
                                                right: 5.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  item["name"],
                                                  style: TextStyle(
                                                      color: Colors.brown),
                                                ),
                                                Text(quantityInStock.toString(),
                                                    style: TextStyle(
                                                        color: quantityInStock >
                                                                15
                                                            ? this
                                                                ._config
                                                                .successColor
                                                            : quantityInStock >
                                                                        5 &&
                                                                    quantityInStock <
                                                                        15
                                                                ? this
                                                                    ._config
                                                                    .amber
                                                                : this
                                                                    ._config
                                                                    .errorColor))
                                              ],
                                            ));
                                      }),
                                )),
                            Positioned(
                                left: 50.0,
                                right: 50.0,
                                top: 120.0,
                                child: RaisedButton(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20.0)),
                                    child: Text("TAKE PAYMENT DETAILS"),
                                    onPressed: () {
                                      if (this._selectedProducts.length > 0) {
                                        paymentModal(context).then((response) {
                                          if (response != null) {
                                            var request = {
                                              "apiid": "makeASale",
                                              "data": {
                                                "grand_total": this._grandTotal,
                                                "items": this._selectedProducts,
                                                "type_of_sale": 1,
                                                "phoneNumber":
                                                    response["phoneNumber"],
                                                "sold_by": this._userId
                                              }
                                            };
                                            responseSnackbar(
                                                context,
                                                "Processing sale",
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
                                                });
                                              } else {
                                                responseSnackbar(
                                                    context,
                                                    response.data,
                                                    this._config.errorColor);
                                              }
                                            });
                                          }
                                          // print(response);
                                        });
                                        // responseSnackbar(context, request);
                                      } else {
                                        responseSnackbar(
                                            context,
                                            "Please select products",
                                            this._config.errorColor);
                                      }
                                    }))
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
                                        Text(item["quantity_sold"].toString()),
                                        showEditIcon: true, onTap: () {
                                      editQuantity(context, item)
                                          .then((quantity) {
                                        if (quantity != null) {
                                          setState(() {
                                            item.remove("quantity_in_stock");
                                            print(item);
                                            item["quantity_sold"] = quantity;
                                            item["sub_total"] =
                                                item["quantity_sold"] *
                                                    item["price"];
                                            this._grandTotal = this
                                                ._selectedProducts
                                                .map(
                                                    (item) => item["sub_total"])
                                                .reduce((a, b) => a + b);
                                          });
                                        }
                                      });
                                    }),
                                    DataCell(
                                      Row(children: <Widget>[
                                        Expanded(
                                            child: Text(this
                                                ._config
                                                .parseCurrency(
                                                    item["sub_total"])
                                                .toString())),
                                        Expanded(
                                            child: IconButton(
                                                icon: Icon(Icons.clear,
                                                    color: this
                                                        ._config
                                                        .errorColor),
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
                                                      this._selectedProducts =
                                                          [];
                                                      this._grandTotal = 0.00;
                                                    }
                                                  });
                                                }))
                                      ]),
                                    ),
                                  ]))
                              .toList())
                    ],
                  );
                }
              }
            }));
  }
}
