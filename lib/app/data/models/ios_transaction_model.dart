class IOSTransaction {
  final int? id;
  final String? productId;

  const IOSTransaction({
    this.id,
    this.productId
  });

  factory IOSTransaction.fromJson(Map<String, dynamic> json) => IOSTransaction(
    id: json['id'],
    productId: json['product_id']
  );
}