class DonationInfoModel {
  final String amount;
  final String interval;
  final int giftAid;
  String? paymentMethod;
  String? plan;
  String? subscriptionId;
  String? payload;

  DonationInfoModel(
      {required this.amount,
      required this.interval,
      required this.giftAid,
      this.paymentMethod,
      this.plan,
      this.subscriptionId,
      this.payload});

  factory DonationInfoModel.fromMap(Map<String, dynamic> map) {
    return DonationInfoModel(
        paymentMethod: map['payment_method'],
        amount: map['amount'],
        giftAid: map['gift_aid'],
        interval: map['interval'],
        plan: map['plan'],
        subscriptionId: map['subscription_id'],
        payload: map['payload']);
  }

  Map<String, dynamic> toMap() {
    return {
      'payment_method': paymentMethod,
      'amount': amount,
      'interval': interval,
      'plan': plan,
      'subscription_id': subscriptionId,
      'payload': payload,
      'gift_aid': giftAid
    };
  }
}
