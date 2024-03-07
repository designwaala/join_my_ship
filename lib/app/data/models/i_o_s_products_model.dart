class IOSProducts {
  String? id;
  String? displayName;
  String? description;
  String? price;
  String? displayPrice;
  String? currency;

  IOSProducts(
      {this.id,
      this.displayName,
      this.description,
      this.price,
      this.displayPrice,
      this.currency});

  IOSProducts.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    displayName = json['display_name'];
    description = json['description'];
    price = json['price'];
    displayPrice = json['display_price'];
    currency = json['currency'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['display_name'] = displayName;
    data['description'] = description;
    data['price'] = price;
    data['display_price'] = displayPrice;
    return data;
  }
}
