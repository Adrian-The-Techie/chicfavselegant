import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:chicfavs_pos/services/config.dart';
import 'package:chicfavs_pos/models/response.model.dart';

class HttpService {
  Config config = new Config();

  Future<ResponseModel> request(Map<String, dynamic> request) async {
    var encodedData = json.encode(request);
    var responseData = await http.post("${this.config.url}/chicfavs/",
        headers: {"Content-Type": "application/json"}, body: encodedData);
    var decodedData = json.decode(responseData.body);
    ResponseModel response = ResponseModel.fromJson(decodedData);

    return response;
  }

  Future<ResponseModel> uploadFormData(
      String apiid, Map<String, dynamic> formValues,
      {String imagePath = null}) async {
    var request = http.MultipartRequest(
        'POST', Uri.parse("${this.config.url}/chicfavs/"));
    formValues.forEach((key, value) {
      request.fields[key] = value.toString();
    });
    if (imagePath != null) {
      var thumbnail = await http.MultipartFile.fromPath("image", imagePath);
      request.files.add(thumbnail);
    }
    request.fields["apiid"] = apiid;
    var responseData = await request.send();
    var responseBody = await responseData.stream.bytesToString();
    var decodedData = json.decode(responseBody);
    ResponseModel response = ResponseModel.fromJson(decodedData);

    return response;
  }
}
