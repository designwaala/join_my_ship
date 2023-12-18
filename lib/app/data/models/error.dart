class APIErrorList {
  List<APIError>? apiErrorList;

  APIErrorList({this.apiErrorList});

  factory APIErrorList.fromJson(Map<String, dynamic> json) {
    List<APIError> apiErrorList = [];
    json.forEach((key, value) {
      apiErrorList.add(APIError.fromJson(key, value));
    });
    return APIErrorList(apiErrorList: apiErrorList);
  }
}

class APIError {
  String? field;
  List<String>? errors;

  APIError({this.field, this.errors});

  factory APIError.fromJson(String field, dynamic json) {
    return APIError(
        field: field,
        errors:
            json is List ? List<String>.from(json.map((e) => "$e")) : ["$json"]);
  }
}
