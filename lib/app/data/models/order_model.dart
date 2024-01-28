class Order {
  int? id;
  int? orderByUser;
  String? amount;
  String? razorpayOrderId;
  bool? paymentSuccessful;
  String? currency;

  Order(
      {this.id,
      this.orderByUser,
      this.amount,
      this.razorpayOrderId,
      this.paymentSuccessful,
      this.currency});

  Order.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderByUser = json['order_by_user'];
    amount = json['amount'];
    razorpayOrderId = json['razorpay_order_id'];
    paymentSuccessful = json['payment_successful'];
    currency = json['currency'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['order_by_user'] = orderByUser;
    data['amount'] = amount;
    data['razorpay_order_id'] = razorpayOrderId;
    data['payment_successful'] = paymentSuccessful;
    data['currency'] = currency;
    return data;
  }
}
