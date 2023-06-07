// class ServiceRecord {
//   int? id;
//   int? userId;
//   String? companyName;
//   String? shipName;
//   String? iMONumber;
//   int? rankId;
//   String? flag;
//   String? gRT;
//   int? vesselType;
//   String? signonDate;
//   String? signoffDate;
//   int? contractDuration;

//   ServiceRecord(
//       {this.id,
//       this.userId,
//       this.companyName,
//       this.shipName,
//       this.iMONumber,
//       this.rankId,
//       this.flag,
//       this.gRT,
//       this.vesselType,
//       this.signonDate,
//       this.signoffDate,
//       this.contractDuration});

//   ServiceRecord.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     userId = json['user_id'];
//     companyName = json['company_name'];
//     shipName = json['ship_name'];
//     iMONumber = json['IMO_number'];
//     rankId = json['Rank_id'];
//     flag = json['Flag'];
//     gRT = json['GRT'];
//     vesselType = json['VesselType'];
//     signonDate = json['signon_date'];
//     signoffDate = json['signoff_date'];
//     contractDuration = json['contract_duration'];
//   }

//   Map<String, dynamic> toJson() {
//     final data = <String, dynamic>{};
//     data['id'] = id;
//     data['user_id'] = userId;
//     data['company_name'] = companyName;
//     data['ship_name'] = shipName;
//     data['IMO_number'] = iMONumber;
//     data['Rank_id'] = rankId;
//     data['Flag'] = flag;
//     data['GRT'] = gRT;
//     data['VesselType'] = vesselType;
//     data['signon_date'] = signonDate;
//     data['signoff_date'] = signoffDate;
//     data['contract_duration'] = contractDuration;
//     data.removeWhere((key, value) => value == null);
//     return data;
//   }
// }
