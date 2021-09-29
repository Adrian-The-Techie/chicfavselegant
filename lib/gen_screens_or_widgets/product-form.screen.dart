import 'package:flutter/material.dart';
import 'package:chicfavs_pos/services/config.dart';
import 'package:chicfavs_pos/services/http.service.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ProductForm extends StatefulWidget {
  final dynamic data;

  ProductForm({this.data});
  @override
  _ProductFormState createState() => _ProductFormState(data: data);
}

class _ProductFormState extends State<ProductForm> {
  dynamic data;
  var _formKey = new GlobalKey<FormState>();
  TextEditingController _nameController = new TextEditingController();
  TextEditingController _buyingPriceController = new TextEditingController();
  TextEditingController _sellingPriceController = new TextEditingController();
  TextEditingController _quantityInStockController =
      new TextEditingController();
  Config _config = new Config();
  HttpService _http = new HttpService();

  List _categories = [];

  int _selectedCategory;

  _ProductFormState({this.data});
  bool edit = false;

  File _thumbnail;

  @override
  void initState() {
    super.initState();
    if (this.data["type"] == "edit") {
      this._nameController =
          TextEditingController(text: this.data['data']['name']);
      this._buyingPriceController = TextEditingController(
          text: (this.data['data']['buying_price']).toString());
      this._sellingPriceController = TextEditingController(
          text: (this.data['data']['selling_price']).toString());
      this._quantityInStockController = TextEditingController(
          text: (this.data['data']['quantity_in_stock']).toString());
      this._selectedCategory = this.data['data']['category'];
    }
    this._http.request({"apiid": "getCategories"}).then((response) {
      setState(() {
        this._categories = response.data;
      });
    });
  }

  Future _getThumbnail() async {
    var _picker = new ImagePicker();
    final pickedImage = await _picker.getImage(source: ImageSource.gallery);

    setState(() => this._thumbnail = File(pickedImage.path));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text(this.data['type'] == "edit"
                ? this.data['data']['name']
                : "New Product"),
            centerTitle: true),
        body: Builder(builder: (context) {
          return ListView(children: <Widget>[
            Padding(
                padding: EdgeInsets.all(10.0),
                child: Form(
                    key: this._formKey,
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: [
                            this.edit == false && this.data["type"] == "edit"
                                ? Hero(
                                    tag: this.data["data"]["id"],
                                    child: Image.network(
                                      this.data["data"]["thumbnail"],
                                      width: 100.0,
                                      fit: BoxFit.fill,
                                    ))
                                : this._thumbnail != null || this.edit == true
                                    ? Image.file(
                                        this._thumbnail,
                                        width: 100.0,
                                        fit: BoxFit.fill,
                                      )
                                    : Image.network(
                                        "${this._config.url}media/images/logo.png",
                                        width: 100.0,
                                        fit: BoxFit.fill,
                                      ),
                            IconButton(
                                icon: Icon(Icons.camera_alt),
                                onPressed: () {
                                  this.edit = true;
                                  _getThumbnail();
                                })
                          ],
                        ),
                        TextFormField(
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(hintText: "Product Name"),
                          controller: this._nameController,
                          validator: (String name) {
                            if (name.isEmpty) {
                              return "Please enter product name";
                            }
                          },
                        ),
                        DropdownButton<int>(
                          isExpanded: true,
                          hint: Text("Select Category"),
                          items: this._categories.map((category) {
                            return DropdownMenuItem<int>(
                                value: category["id"],
                                child: Text(category["name"]));
                          }).toList(),
                          value: this._selectedCategory,
                          onChanged: (int newCategory) {
                            setState(() {
                              this._selectedCategory = newCategory;
                            });
                          },
                        ),
                        TextFormField(
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(hintText: "Buying Price"),
                          controller: this._buyingPriceController,
                          validator: (String price) {
                            if (price.isEmpty) {
                              return "Please enter product buying price";
                            }
                          },
                        ),
                        TextFormField(
                          keyboardType: TextInputType.number,
                          decoration:
                              InputDecoration(hintText: "Selling Price"),
                          controller: this._sellingPriceController,
                          validator: (String price) {
                            if (price.isEmpty) {
                              return "Please enter product selling price";
                            }
                          },
                        ),
                        TextFormField(
                          keyboardType: TextInputType.number,
                          decoration:
                              InputDecoration(hintText: "Quantity in stock"),
                          controller: this._quantityInStockController,
                          validator: (String quantity) {
                            if (quantity.isEmpty) {
                              return "Please enter quantity in stock";
                            }
                          },
                        )
                      ],
                    ))),
            Container(
                margin: EdgeInsets.all(20.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                        child: RaisedButton(
                      color: this.data['type'] == "edit"
                          ? this._config.secondaryColor
                          : this._config.primaryColor,
                      elevation: 10.0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0)),
                      child: Text(
                          this.data['type'] == "edit"
                              ? "Update"
                              : "Save and new",
                          style: TextStyle(
                              color: this._config.buttonFontColor,
                              fontSize: 17.0)),
                      onPressed: () {
                        var _formState = this._formKey.currentState;
                        if (_formState.validate()) {
                          if (this.data['type'] == "edit") {
                            var request = {
                              "id": this.data["data"]["id"],
                              "name": this._nameController.text,
                              "buying_price": double.parse(
                                  this._buyingPriceController.text),
                              "selling_price": double.parse(
                                  this._sellingPriceController.text),
                              "quantity_in_stock": double.parse(
                                  this._quantityInStockController.text),
                              "category": this._selectedCategory
                            };
                            if (edit) {
                              _responseSnackbar(
                                  context, request, "updateProductDetails",
                                  image: this._thumbnail.path);
                            } else {
                              _responseSnackbar(
                                  context, request, "updateProductDetails");
                            }
                            Navigator.of(context).pop();
                          } else {
                            var request = {
                              "name": this._nameController.text,
                              "buying_price": double.parse(
                                  this._buyingPriceController.text),
                              "selling_price": double.parse(
                                  this._sellingPriceController.text),
                              "quantity_in_stock": double.parse(
                                  this._quantityInStockController.text),
                              "category": this._selectedCategory
                            };
                            if (this._thumbnail != null) {
                              _responseSnackbar(
                                  context, request, "saveNewProduct",
                                  image: _thumbnail.path);
                            } else {
                              _responseSnackbar(
                                  context, request, "saveNewProduct");
                            }
                            this._nameController.clear();
                            this._buyingPriceController.clear();
                            this._sellingPriceController.clear();
                            this._quantityInStockController.clear();
                            setState(() {
                              this._selectedCategory = null;
                            });
                          }
                        }
                      },
                    )),
                    SizedBox(width: 20.0),
                    Expanded(
                        child: RaisedButton(
                      elevation: 10.0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0)),
                      color: this.data['type'] == "edit"
                          ? this._config.errorColor
                          : this._config.successColor,
                      child: Text(
                          this.data['type'] == "edit" ? "Delete" : "Save",
                          style: TextStyle(
                              color: this._config.buttonFontColor,
                              fontSize: 17.0)),
                      onPressed: () {
                        var _formState = this._formKey.currentState;
                        if (_formState.validate()) {
                          if (this.data["type"] == "edit") {
                            var request = {
                              "apiid": "deleteProduct",
                              "data": {"id": this.data["data"]["id"]}
                            };
                            _responseSnackbar(
                                context, request, "deleteProduct");
                            Navigator.of(context).pop();
                          } else {
                            var request = {
                              "name": this._nameController.text,
                              "buying_price": double.parse(
                                  this._buyingPriceController.text),
                              "selling_price": double.parse(
                                  this._sellingPriceController.text),
                              "quantity_in_stock": double.parse(
                                  this._quantityInStockController.text),
                              "category": this._selectedCategory
                            };
                            if (this._thumbnail != null) {
                              _responseSnackbar(
                                  context, request, "saveNewProduct",
                                  image: _thumbnail.path);
                            } else {
                              _responseSnackbar(
                                  context, request, "saveNewProduct");
                            }
                            Navigator.of(context).pop();
                          }
                        }
                      },
                    ))
                  ],
                ))
          ]);
        }));
  }

  _responseSnackbar(context, request, apiid, {image}) {
    var snackbar = new SnackBar(
        content: FutureBuilder(
          future: apiid == "deleteProduct"
              ? this._http.request(request)
              : this._http.uploadFormData(apiid, request, imagePath: image),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Text(
                apiid == "saveNewProduct"
                    ? "Adding ${request['name']}..."
                    : apiid == "updateProductDetails"
                        ? "Updating ${request['name']} details..."
                        : "Deleting product...",
                style: TextStyle(
                  color: apiid == "saveNewProduct"
                      ? this._config.primaryColor
                      : apiid == "updateProductDetails"
                          ? this._config.secondaryColor
                          : this._config.errorColor,
                ),
              );
            } else {
              if (snapshot.hasError) {
                return Center(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                      Text("${snapshot.error}"),
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
                if (snapshot.data.status == 1) {
                  return RichText(
                    text: TextSpan(
                        text: "${snapshot.data.data} ",
                        children: <TextSpan>[
                          TextSpan(
                              text: apiid == "saveNewProduct"
                                  ? "added "
                                  : apiid == "updateProductDetails"
                                      ? "updated "
                                      : ""),
                          TextSpan(
                              text: apiid == "saveNewProduct" ||
                                      "apiid" == "updateProductDetails"
                                  ? "successfuly"
                                  : "")
                        ],
                        style: TextStyle(
                            color: apiid == "saveNewProduct"
                                ? this._config.successColor
                                : apiid == "updateProductDetails"
                                    ? this._config.secondaryColor
                                    : this._config.errorColor)),
                  );
                }
              }
            }
          },
        ),
        duration: Duration(seconds: 8));

    Scaffold.of(context).showSnackBar(snackbar);
  }
}
