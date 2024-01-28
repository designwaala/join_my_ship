class CreditsModel {
  final List<CreditCurrency>? creditCurrencies;
  final List<String>? notes;
  CreditsModel({this.creditCurrencies, this.notes});

  factory CreditsModel.fromJson(Map<String, dynamic> json) => CreditsModel(
      creditCurrencies: List<CreditCurrency>.from(
          json['credit_currencies'].map((e) => CreditCurrency.fromJson(e))),
      notes: json['notes'].cast<String>());
}

class CreditCurrency {
  final String? code;
  final String? symbol;
  final double? conversionToPoints;
  final String? footer;
  final List<TopUp>? topUps;
  final double? minimumAmount;

  CreditCurrency(
      {this.code,
      this.symbol,
      this.conversionToPoints,
      this.footer,
      this.topUps,
      this.minimumAmount});

  factory CreditCurrency.fromJson(Map<String, dynamic> json) => CreditCurrency(
      code: json['code'],
      symbol: json['symbol'],
      conversionToPoints: json['conversion_to_points']?.toDouble(),
      footer: json['footer'],
      topUps: List<TopUp>.from(json['top_ups'].map((e) => TopUp.fromJson(e))),
      minimumAmount: json['minimum_amount']?.toDouble());
}

class TopUp {
  final double? amount;
  final bool? mostPopular;

  TopUp({this.amount, this.mostPopular});

  factory TopUp.fromJson(Map<String, dynamic> json) => TopUp(
      amount: json['amount']?.toDouble(), mostPopular: json['most_popular']);
}
