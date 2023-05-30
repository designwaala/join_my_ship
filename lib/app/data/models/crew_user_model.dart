class CrewUser {
  String? firstName;
  String? lastName;
  String? password;
  String? email;
  dynamic profilePic;
  dynamic resume;
  String? addressLine1;
  String? pincode;
  String? dob;
  int? maritalStatus;
  int? country;
  int? rankId;
  int? userTypeKey;
  String? addressLine2;
  String? addressCity;
  int? state;

  CrewUser(
      {this.firstName,
      this.lastName,
      this.password,
      this.email,
      this.profilePic,
      this.resume,
      this.addressLine1,
      this.pincode,
      this.dob,
      this.maritalStatus,
      this.country,
      this.rankId,
      this.userTypeKey,
      this.addressLine2,
      this.addressCity,
      this.state});

  CrewUser.fromJson(Map<String, dynamic> json) {
    firstName = json['first_name'];
    lastName = json['last_name'];
    password = json['password'];
    email = json['email'];
    profilePic = json['profilePic'];
    resume = json['resume'];
    addressLine1 = json['address_line1'];
    pincode = json['pincode'];
    dob = json['dob'];
    maritalStatus = json['marital_status'];
    country = json['country'];
    rankId = json['rank_id'];
    userTypeKey = json['user_type_key'];
    addressLine2 = json['address_line2'];
    addressCity = json['address_city'];
    state = json['state'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['password'] = password;
    data['email'] = email;
    data['profilePic'] = profilePic;
    data['resume'] = resume;
    data['address_line1'] = addressLine1;
    data['pincode'] = pincode;
    data['dob'] = dob;
    data['marital_status'] = maritalStatus;
    data['country'] = country;
    data['rank_id'] = rankId;
    data['user_type_key'] = userTypeKey;
    data['address_line2'] = addressLine2;
    data['address_city'] = addressCity;
    data['state'] = state;
    return data;
  }
}
