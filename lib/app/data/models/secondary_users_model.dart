class SecondaryUsers {
  int? id;
  String? name;
  String? email;
  String? profilePic;

  SecondaryUsers({this.id, this.name, this.email, this.profilePic});

  SecondaryUsers.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    name = json['name'];
    email = json['email'];
    profilePic = json['profile_pic'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['email'] = email;
    data['profile_pic'] = profilePic;
    return data;
  }
}
