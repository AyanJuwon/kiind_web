class SubscriptionModel {
  final int id;
  final int userId;
  final String type;
  final String status;
  final String interval;
  final String amount;
  final String currency;

  SubscriptionModel(
      {required this.id,
      required this.userId,
      required this.type,
      required this.status,
      required this.interval,
      required this.amount,
      required this.currency});

  factory SubscriptionModel.fromMap(Map<String, dynamic> map) {
    return SubscriptionModel(
        id: map['id'],
        userId: map['user_id'],
        type: map['type'],
        status: map['status'],
        interval: map['interval'],
        amount: map['amount'],
        currency: map['currency']);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'type': type,
      'status': status,
      'interval': interval,
      'amount': amount,
      'currency': currency
    };
  }
}
