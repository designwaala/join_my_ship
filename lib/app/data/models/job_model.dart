class Job {
  int? id;
  int? vesselId;
  String? tentativeJoining;
  String? gRT;
  String? expiryInDay;

  Job(
      {this.id,
      this.vesselId,
      this.tentativeJoining,
      this.gRT,
      this.expiryInDay});

  Job.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    vesselId = json['vessel_id'];
    tentativeJoining = json['tentative_joining'];
    gRT = json['GRT'];
    expiryInDay = json['expiry_in_day'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['vessel_id'] = vesselId;
    data['tentative_joining'] = tentativeJoining;
    data['GRT'] = gRT;
    data['expiry_in_day'] = expiryInDay;
    return data;
  }
}
