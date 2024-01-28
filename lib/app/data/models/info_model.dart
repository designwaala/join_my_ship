class InfoModel {
  final String? imagePath;
  final double? height;
  final double? width;
  final String? heading;
  final String? body;

  const InfoModel(
      {required this.imagePath,
      required this.height,
      required this.width,
      required this.heading,
      required this.body});

  factory InfoModel.fromJson(Map<String, dynamic> json) => InfoModel(
      imagePath: json['image_path'],
      height: json['height']?.toDouble(),
      width: json['width']?.toDouble(),
      heading: json['heading'],
      body: json['body']);
}
