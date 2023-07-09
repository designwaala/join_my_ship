class EmployerUser {
  String? profilePic;
  String? firstName;
  String? lastName;
  String? designation;
  String? country;
  String? state;
  String? city;
  String? addressLine1;
  String? addressLine2;
  String? zipCode;

  EmployerUser(
      {this.profilePic,
      this.firstName,
      this.lastName,
      this.designation,
      this.country,
      this.state,
      this.city,
      this.addressLine1,
      this.addressLine2,
      this.zipCode});

  EmployerUser.fromJson(Map<String, dynamic> json) {
    profilePic = json['profilePic'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    designation = json['designation'];
    country = json['country'];
    state = json['state'];
    city = json['city'];
    addressLine1 = json['addressLine1'];
    addressLine2 = json['addressLine2'];
    zipCode = json['zipCode'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['profilePic'] = profilePic;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['designation'] = designation;
    data['country'] = country;
    data['state'] = state;
    data['city'] = city;
    data['addressLine1'] = addressLine1;
    data['addressLine2'] = addressLine2;
    data['zipCode'] = zipCode;
    return data;
  }
}
