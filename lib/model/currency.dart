class CustomCurrency{
  final int timestamp;
  final bool success;
  final String base;
  final String date;
  final Map<String, dynamic> rates;

  CustomCurrency({this.success, this.timestamp, this.base, this.date, this.rates});

  factory CustomCurrency.fromJson(Map<String, dynamic> json){
    return CustomCurrency(
      success: json["success"],
      timestamp: json["timestamp"],
      base: json["base"],
      date: json["date"],
      rates: json["rates"]
    );
  }
}