class JobApplication {
  int? id;
  String? profilePic;
  String? name;
  int? rank;
  bool? shortlisted;

  JobApplication(
      {this.id, this.profilePic, this.name, this.rank, this.shortlisted});

  JobApplication.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    profilePic = json['profilePic'];
    name = json['name'];
    rank = json['rank'];
    shortlisted = json['shortlisted'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['profilePic'] = profilePic;
    data['name'] = name;
    data['rank'] = rank;
    data['shortlisted'] = shortlisted;
    return data;
  }
}
