import 'package:chicfavs_pos/services/config.dart';
import 'package:chicfavs_pos/services/http.service.dart';
import 'package:flutter/material.dart';

class SpecificSaleHistory extends StatefulWidget {
  int _id;

  SpecificSaleHistory(this._id);
  @override
  _SpecificSaleHistory createState() => _SpecificSaleHistory(this._id);
}

class _SpecificSaleHistory extends State<SpecificSaleHistory> {
  HttpService _http = new HttpService();
  int _id;
  TextEditingController _phoneController = new TextEditingController();
  final _key = new GlobalKey<FormState>();
  bool _changeRecipient = false;
  Config _config = new Config();
  List _items = new List();
  _SpecificSaleHistory(this._id);

  Widget _mainDetails(String title, String detail) {
    return RichText(
        text: TextSpan(
            text: "$title: ",
            style: TextStyle(color: Colors.black),
            children: <TextSpan>[
          TextSpan(
              text: "$detail ", style: TextStyle(fontWeight: FontWeight.bold))
        ]));
  }

  Widget _genTitle(String title) {
    return Align(
      alignment: Alignment.center,
      child: Text(
        title,
        style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _receiptRecipient() {
    return Expanded(
        child: Row(children: <Widget>[
      Flexible(fit: FlexFit.loose, child: Text("New recipient:")),
      SizedBox(width: 3.0),
      Form(
          key: this._key,
          child: Expanded(
              child: TextFormField(
            keyboardType: TextInputType.phone,
            controller: _phoneController,
            validator: (String phoneNumber) {
              if (phoneNumber.isEmpty) {
                return "Enter new recipient for this receipt";
              }
            },
          )))
    ]));
  }

  Widget _snackbar(BuildContext context, String text, Color color) {
    var snackbar = SnackBar(
      content: Text(text, style: TextStyle(color: color)),
    );
    Scaffold.of(context).showSnackBar(snackbar);
  }

  @override
  Widget build(BuildContext context) {
    var request = {
      "apiid": "getSpecificSaleHistoryDetails",
      "data": {"id": this._id}
    };
    return Scaffold(
      appBar: AppBar(
        title: Text("Sale ID ${this._id}"),
      ),
      body: FutureBuilder(
          future: this._http.request(request),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return this._config.loader("Loading...");
            } else {
              if (snapshot.hasError) {
                return this._config.errorWidget(setState, snapshot.error);
              } else {
                var data = snapshot.data.data;
                var soldOn = data["date_added"];
                var amountSold =
                    this._config.parseCurrency(data['grand_total']);
                var customerPhoneNumber = data["customer_phone_number"];
                this._items = data["items_sold"];
                this._phoneController = new TextEditingController(
                    text: data["customer_phone_number"]);
                return ListView(children: <Widget>[
                  SizedBox(height: 7.0),
                  this._genTitle("Basic sale info"),
                  this._mainDetails("Sold By", data["emp_id"]),
                  SizedBox(height: 7.0),
                  this._mainDetails("Sold on", soldOn),
                  SizedBox(height: 7.0),
                  this._mainDetails("Amount earned", "$amountSold"),
                  SizedBox(height: 7.0),
                  this._mainDetails("Type of sale", data["type_of_sale"]),
                  SizedBox(height: 7.0),
                  Row(children: <Widget>[
                    this._changeRecipient
                        ? this._receiptRecipient()
                        : this._mainDetails(
                            "Receipt recipient", customerPhoneNumber),
                    SizedBox(width: 2.0),
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        setState(() {
                          this._changeRecipient = !this._changeRecipient;
                        });
                      },
                    )
                  ]),
                  Divider(thickness: 1.7),
                  SizedBox(height: 7.0),
                  this._genTitle("Items Sold"),
                  Container(
                      child: DataTable(
                          columns: [
                        DataColumn(label: Text("Name")),
                        DataColumn(
                          label: Text("Price"),
                        ),
                        DataColumn(label: Text("Quantity")),
                        DataColumn(label: Text("Sub-Total"))
                      ],
                          rows: this
                              ._items
                              .map((item) => DataRow(cells: [
                                    DataCell(Text(item["product_sold_id"])),
                                    DataCell(Text("${item["price"]}")),
                                    DataCell(Text("${item["quantity_sold"]}")),
                                    DataCell(Text("${item["sub_total"]}"))
                                  ]))
                              .toList())),
                  Container(
                      margin: EdgeInsets.only(top: 15.0, left: 5.0, right: 5.0),
                      child: Row(
                        children: [
                          Expanded(
                              child: ButtonTheme(
                                  child: RaisedButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0)),
                            child: Text("OK",
                                style: TextStyle(color: Colors.white)),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ))),
                          SizedBox(width: 10),
                          Expanded(
                              child: ButtonTheme(
                                  child: RaisedButton(
                            color: this._config.successColor,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0)),
                            child: Text("Resend Receipt",
                                style: TextStyle(color: Colors.white)),
                            onPressed: () {
                              var request = {
                                "apiid": "resendReceipt",
                                "data": {
                                  "receiptId": this._id,
                                  "sold_by": data['emp_id'],
                                  "sold_on": soldOn,
                                  "amount_sold": amountSold,
                                  "items": this._items
                                }
                              } as Map;
                              if (this._changeRecipient) {
                                if (this._key.currentState.validate()) {
                                  request["data"]["recipient"] =
                                      this._phoneController.text;
                                }
                              } else {
                                request["data"]["recipient"] =
                                    customerPhoneNumber;
                              }
                              print(request);
                              this._snackbar(context, "Resending",
                                  this._config.primaryColor);
                              this._http.request(request).then((response) {
                                this._snackbar(context, response.data,
                                    this._config.successColor);
                              });
                            },
                          )))
                        ],
                      ))
                ]);
              }
            }
          }),
    );
  }
}
