class VesselList {
  final List<Vessel>? vessels;

  const VesselList({this.vessels});

  factory VesselList.fromJson(Map<String, dynamic> json) {
    List<Vessel> vessels = [];
    json.forEach((key, value) {
      vessels.add(Vessel.fromJson(key, value));
    });

    return VesselList(vessels: vessels);
  }
}

class Vessel {
  final String? vesselName;
  final List<SubVessel>? subVessels;

  const Vessel({this.vesselName, this.subVessels});

  factory Vessel.fromJson(String name, List<dynamic> rawSubVessels) {
    return Vessel(
        vesselName: name,
        subVessels: List<SubVessel>.from(
            rawSubVessels.map((e) => SubVessel.fromJson(e))));
  }
}

class SubVessel {
  int? id;
  String? name;
  int? vesselsIdId;
  bool? isActive;
  String? createdBy;
  String? modifiedBy;
  String? createdAt;
  String? modifiedAt;

  SubVessel(
      {this.id,
      this.name,
      this.vesselsIdId,
      this.isActive,
      this.createdBy,
      this.modifiedBy,
      this.createdAt,
      this.modifiedAt});

  SubVessel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    vesselsIdId = json['vessels_id_id'];
    isActive = json['is_active'];
    createdBy = json['created_by'];
    modifiedBy = json['modified_by'];
    createdAt = json['created_at'];
    modifiedAt = json['modified_at'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['vessels_id_id'] = vesselsIdId;
    data['is_active'] = isActive;
    data['created_by'] = createdBy;
    data['modified_by'] = modifiedBy;
    data['created_at'] = createdAt;
    data['modified_at'] = modifiedAt;
    return data;
  }
}
