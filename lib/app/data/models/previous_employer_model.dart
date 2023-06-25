class PreviousEmployerReference {
  int? id;
  int? userId;
  String? companyName;
  String? referenceName;
  String? contactNumber;

  PreviousEmployerReference(
      {this.id,
      this.userId,
      this.companyName,
      this.referenceName,
      this.contactNumber});

  PreviousEmployerReference.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    companyName = json['company_name'];
    referenceName = json['reference_name'];
    contactNumber = json['contact_number'];
  }

  Map<String, String> toJson() {
    final data = <String, String?>{};
    data['id'] = id.toString();
    // data['user_id'] = userId;
    data['company_name'] = companyName;
    data['reference_name'] = referenceName;
    data['contact_number'] = contactNumber;
    data.removeWhere((key, value) => value == null);
    return data.map((key, value) => MapEntry(key, value!));
  }
}
