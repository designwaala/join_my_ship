class CrewUser {
  int? id;
  String? password;
  dynamic lastLogin;
  bool? isSuperuser;
  String? username;
  String? firstName;
  String? lastName;
  bool? isStaff;
  bool? isActive;
  String? dateJoined;
  String? profilePic;
  String? resume;
  String? email;
  String? extraaPass;
  int? userTypeKey;
  String? tempBlockPeriod;
  int? isVerified;
  bool? mobileVerified;
  bool? promotionApplied;
  bool? emailVerified;
  String? website;
  String? number;
  String? designation;
  String? alternateNumber;
  String? addressLine1;
  String? addressLine2;
  String? addressCity;
  String? pincode;
  String? dob;
  int? maritalStatus;
  String? createdBy;
  String? modifiedBy;
  String? createdAt;
  String? modifiedAt;
  int? rankId;
  int? country;
  int? state;
  List<int>? groups;
  String? authKey;

  CrewUser(
      {this.id,
      this.password,
      this.lastLogin,
      this.isSuperuser,
      this.username,
      this.firstName,
      this.lastName,
      this.isStaff,
      this.isActive,
      this.dateJoined,
      this.profilePic,
      this.resume,
      this.email,
      this.extraaPass,
      this.userTypeKey,
      this.tempBlockPeriod,
      this.isVerified,
      this.mobileVerified,
      this.promotionApplied,
      this.emailVerified,
      this.website,
      this.number,
      this.designation,
      this.alternateNumber,
      this.addressLine1,
      this.addressLine2,
      this.addressCity,
      this.pincode,
      this.dob,
      this.maritalStatus,
      this.createdBy,
      this.modifiedBy,
      this.createdAt,
      this.modifiedAt,
      this.rankId,
      this.country,
      this.state,
      this.groups,
      this.authKey});

  CrewUser.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    password = json['password'];
    lastLogin = json['last_login'];
    isSuperuser = json['is_superuser'];
    username = json['username'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    isStaff = json['is_staff'];
    isActive = json['is_active'];
    dateJoined = json['date_joined'];
    profilePic = json['profilePic'];
    resume = json['resume'];
    email = json['email'];
    extraaPass = json['extraa_pass'];
    userTypeKey = json['user_type_key'];
    tempBlockPeriod = json['temp_block_period'];
    isVerified = json['is_verified'];
    mobileVerified = json['mobile_verified'];
    promotionApplied = json['promotion_applied'];
    emailVerified = json['email_verified'];
    website = json['website'];
    number = json['number'];
    designation = json['designation'];
    alternateNumber = json['alternate_number'];
    addressLine1 = json['address_line1'];
    addressLine2 = json['address_line2'];
    addressCity = json['address_city'];
    pincode = json['pincode'];
    dob = json['dob'];
    maritalStatus = json['marital_status'];
    createdBy = json['created_by'];
    modifiedBy = json['modified_by'];
    createdAt = json['created_at'];
    modifiedAt = json['modified_at'];
    rankId = json['rank_id'];
    country = json['country'];
    state = json['state'];
    groups = json['groups']?.cast<int>();
    authKey = json['auth_key'];
    // if (json['user_permissions'] != null) {
    //   userPermissions = <Null>[];
    //   json['user_permissions'].forEach((v) {
    //     userPermissions?.add(Null.fromJson(v));
    //   });
    // }
  }

  Map<String, String> toJson() {
    final data = <String, String?>{};
    data['id'] = id?.toString();
    data['password'] = password;
    data['last_login'] = lastLogin;
    data['is_superuser'] = isSuperuser?.toString();
    data['username'] = username;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['is_staff'] = isStaff?.toString();
    data['is_active'] = isActive?.toString();
    data['date_joined'] = dateJoined;
    data['profilePic'] = profilePic;
    data['resume'] = resume;
    data['email'] = email;
    data['extraa_pass'] = extraaPass;
    data['user_type_key'] = userTypeKey?.toString();
    data['temp_block_period'] = tempBlockPeriod;
    data['is_verified'] = isVerified?.toString();
    data['mobile_verified'] = mobileVerified?.toString();
    data['promotion_applied'] = promotionApplied?.toString();
    data['email_verified'] = emailVerified?.toString();
    data['website'] = website;
    data['number'] = number;
    data['designation'] = designation;
    data['alternate_number'] = alternateNumber;
    data['address_line1'] = addressLine1;
    data['address_line2'] = addressLine2;
    data['address_city'] = addressCity;
    data['pincode'] = pincode;
    data['dob'] = dob;
    data['marital_status'] = maritalStatus?.toString();
    data['created_by'] = createdBy;
    data['modified_by'] = modifiedBy;
    data['created_at'] = createdAt;
    data['modified_at'] = modifiedAt;
    data['rank_id'] = rankId?.toString();
    data['country'] = country?.toString();
    data['state'] = state?.toString();
    data['auth_key'] = authKey;
    data.removeWhere((key, value) => value == null);
    return data.map((key, value) => MapEntry(key, value!));
  }
}
