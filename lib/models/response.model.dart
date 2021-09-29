class ResponseModel {
  int status;
  dynamic data;

  ResponseModel({this.status, this.data});

  factory ResponseModel.fromJson(Map<String, dynamic> parsedJson) {
    return ResponseModel(
        status: parsedJson["status"], data: parsedJson["data"]);
  }
}
