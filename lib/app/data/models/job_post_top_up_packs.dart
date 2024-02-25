class JobPostTopUpPack {
  final int? postPurchased;
  final int? pointsUsed;

  const JobPostTopUpPack({this.pointsUsed, this.postPurchased});

  factory JobPostTopUpPack.fromJson(Map<String, dynamic> json) =>
      JobPostTopUpPack(
          pointsUsed: json['points_used'],
          postPurchased: json['post_purchased']);
}
