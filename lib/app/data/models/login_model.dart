class Login {
  String? message;
  Data? data;

  Login({this.message, this.data});

  Login.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    data = json['data'] != null ? Data?.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final d = <String, dynamic>{};
    d['message'] = message;
    if (data != null) {
      d['data'] = data?.toJson();
    }
    return d;
  }
}

class Data {
  String? refresh;
  String? access;

  Data({this.refresh, this.access});

  Data.fromJson(Map<String, dynamic> json) {
    print(json);
    refresh = json['refresh'];
    access = json['access'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['refresh'] = refresh;
    data['access'] = access;
    return data;
  }
}
