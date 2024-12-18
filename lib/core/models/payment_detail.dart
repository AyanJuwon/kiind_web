// To parse this JSON data, do
//
//     final paymentDetail = paymentDetailFromMap(jsonString);

import 'dart:convert';

import 'package:kiind_web/core/models/campaign_model.dart';
import 'package:kiind_web/core/models/gateway_model.dart';
import 'package:kiind_web/core/models/post_model.dart';

class PaymentDetail {
  PaymentDetail({
    this.gateway,
    this.cause,
    this.charges,
    this.purpose,
    this.amounts,
    this.subscriptionId,
     this.html,
  });

  final Gateway? gateway;
  final dynamic cause;
  final String? purpose;
  final Charges? charges;
  final Amounts? amounts;
  final int? subscriptionId;
  final String? html;

  double get netCost =>
      ((amounts?.userSubmittedAmount ?? 0) - (charges?.totalCharges ?? 0));

  PaymentDetail copyWith({
    Gateway? gateway,
    dynamic cause,
    Charges? charges,
    String? purpose,
    Amounts? amounts,
    int? subscriptionId,
    String? html,
  }) =>
      PaymentDetail(
        gateway: gateway ?? this.gateway,
        cause: cause ?? this.cause,
        charges: charges ?? this.charges,
        purpose: purpose ?? this.purpose,
        amounts: amounts ?? this.amounts,
        subscriptionId: subscriptionId ?? this.subscriptionId,
        html: html ?? this.html,
      );

  factory PaymentDetail.fromJson(String str) =>
      PaymentDetail.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory PaymentDetail.fromMap(Map<String, dynamic> json) => PaymentDetail(
        gateway:
            json["gateway"] == null ? null : Gateway.fromMap(json["gateway"]),
        cause: json["post"] == null
            ? json["campaign"] == null
                ? null
                : Campaign.fromMap(json["campaign"])
            : Post.fromMap(json["post"]),
        purpose: json["purpose"],
        charges:
            json["charges"] == null ? null : Charges.fromMap(json["charges"]),
        amounts:
            json["amounts"] == null ? null : Amounts.fromMap(json["amounts"]),
        subscriptionId: json["subscription_id"],
        html: json["html"],
      );

  Map<String, dynamic> toMap() => {
        "gateway": gateway,
        "purpose": purpose,
        "post": cause is Post ? cause?.toMap() : null,
        "campaign": cause is Campaign ? cause?.toMap() : null,
        "charges": charges?.toMap(),
        "amounts": amounts?.toMap(),
        "subscription_id": subscriptionId,
        "html": html,
      };
}

class Amounts {
  Amounts({
    this.userSubmittedAmount,
    this.amountAfterChargesDeduction,
  });

  final double? userSubmittedAmount;
  final double? amountAfterChargesDeduction;

  Amounts copyWith({
    double? userSubmittedAmount,
    double? amountAfterChargesDeduction,
  }) =>
      Amounts(
        userSubmittedAmount: userSubmittedAmount ?? this.userSubmittedAmount,
        amountAfterChargesDeduction:
            amountAfterChargesDeduction ?? this.amountAfterChargesDeduction,
      );

  factory Amounts.fromJson(String str) => Amounts.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Amounts.fromMap(Map<String, dynamic> json) => Amounts(
        userSubmittedAmount: (json["user_submitted_amount"] is String
                ? int.parse(json["user_submitted_amount"])
                : json["user_submitted_amount"])
            ?.toDouble(),
        amountAfterChargesDeduction:
            json["amount_after_charges_deduction"]?.toDouble(),
      );

  Map<String, dynamic> toMap() => {
        "user_submitted_amount": userSubmittedAmount,
        "amount_after_charges_deduction": amountAfterChargesDeduction,
      };
}

class Charges {
  Charges({
    this.breakdown,
    this.totalCharges,
  });

  final List<Breakdown>? breakdown;
  final double? totalCharges;

  Charges copyWith({
    List<Breakdown>? breakdown,
    double? totalCharges,
  }) =>
      Charges(
        breakdown: breakdown ?? this.breakdown,
        totalCharges: totalCharges ?? this.totalCharges,
      );

  factory Charges.fromJson(String str) => Charges.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Charges.fromMap(Map<String, dynamic> json) => Charges(
        breakdown: json["breakdown"] == null
            ? null
            : List<Breakdown>.from(
                (json["breakdown"] ?? []).map(
                  (x) => Breakdown.fromMap(x),
                ),
              ),
        totalCharges: json["total_charges"]?.toDouble(),
      );

  Map<String, dynamic> toMap() => {
        "breakdown": breakdown == null
            ? null
            : List<dynamic>.from(
                (breakdown ?? []).map(
                  (x) => x.toMap(),
                ),
              ),
        "total_charges": totalCharges,
      };
}

class Breakdown {
  Breakdown({
    this.name,
    this.amount,
  });

  final String? name;
  final String? amount;

  Breakdown copyWith({
    String? name,
    String? amount,
  }) =>
      Breakdown(
        name: name ?? this.name,
        amount: amount ?? this.amount,
      );

  factory Breakdown.fromJson(String str) => Breakdown.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Breakdown.fromMap(Map<String, dynamic> json) => Breakdown(
        name: json["name"],
        amount: '${json["amount"]}',
      );

  Map<String, dynamic> toMap() => {
        "name": name,
        "amount": amount,
      };
}
