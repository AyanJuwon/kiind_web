import 'dart:convert';
import 'dart:developer';

import 'package:jiffy/jiffy.dart';
import 'package:kiind_web/core/models/donation_model.dart';
import 'package:kiind_web/core/models/options.model.dart';
import 'package:kiind_web/core/router/route_paths.dart';
import 'package:kiind_web/core/util/extensions/string_extensions.dart';

class Campaign {
  Campaign(
      {this.id,
      this.userId,
      this.groupId,
      this.title,
      this.type,
      this.details,
      this.goal,
      this.deadline,
      this.timePeriod,
      this.adopters,
      this.status,
      this.featured,
      this.image,
      this.completed,
      this.expired,
      this.stopped,
      this.active,
      this.slug,
      this.ip,
      this.likes,
      this.views,
      this.extraCharges1Title,
      this.extraCharges1Value,
      this.extraCharges1Type,
      this.createdAt,
      this.updatedAt,
      this.extraCharges2Title,
      this.extraCharges2Value,
      this.extraCharges2Type,
      this.paymentGatewayValue,
      this.paymentGatewayType,
      this.platformServicesValue,
      this.platformServicesType,
      this.groupAdminValue,
      this.groupAdminType,
      this.donors,
      this.raisedAmount,
      this.monthly,
      this.yearly,
      this.oneTime,
      this.remainingDays,
      this.options,
      this.lastDonation,
      this.media,
      this.featuredImage,
      this.charity,
      this.charityImage});

  final int? id;
  final int? userId;
  final String? groupId;
  final String? title;
  final String? type;
  final String? details;
  final String? goal;
  final DateTime? deadline;
  final String? timePeriod;
  final dynamic adopters;
  final String? status;
  final String? featured;
  final int? image;
  final int? completed;
  final int? expired;
  final int? stopped;
  final String? active;
  final String? slug;
  final String? ip;
  final int? likes;
  final int? views;
  final dynamic extraCharges1Title;
  final dynamic extraCharges1Value;
  final String? extraCharges1Type;
  final String? createdAt;
  final String? updatedAt;
  final dynamic extraCharges2Title;
  final dynamic extraCharges2Value;
  final String? extraCharges2Type;
  final String? paymentGatewayValue;
  final String? paymentGatewayType;
  final String? platformServicesValue;
  final String? platformServicesType;
  final String? groupAdminValue;
  final String? groupAdminType;
  final int? donors;
  final num? raisedAmount;
  final num? monthly;
  final num? yearly;
  final num? oneTime;
  final int? remainingDays;
  final Options? options;
  final Donation? lastDonation;
  final List<dynamic>? media;
  final String? featuredImage;
  final String? charityImage;
  final String? charity;

  bool get hasDonation => lastDonation?.isNotNullOrEmpty ?? false;

  bool get isOther => type != 'Campaign';
  bool get isNotOther => !isOther;

  bool get isInactive => [expired, completed, stopped].any((f) => f != 0);
  bool get isActive => !isInactive;

  Jiffy? get createdAtJiffy {
    Jiffy? j;

    try {
      j = createdAt.isNotNullOrEmpty ? Jiffy.parse(createdAt!) : null;
    } catch (e) {
      log(e.toString());
    }

    return j;
  }

  Jiffy? get updatedAtJiffy {
    Jiffy? j;

    try {
      j = updatedAt.isNotNullOrEmpty ? Jiffy.parse(updatedAt!) : null;
    } catch (e) {
      log(e.toString());
    }

    return j;
  }

  double get progress => (raisedAmount ?? 0) / (int.tryParse(goal ?? '1') ?? 1);

  Map<String, num> get subscriptionOptions => {
        'Monthly': monthly ?? 0,
        'Yearly': yearly ?? 0,
        'One Time': oneTime ?? 0,
      };

  Map<String, String> get sharePayload => {
        'id': '$id',
        'title': title ?? 'This should be a good title',
        'user_id': '$userId',
        'group_id': '$groupId',
        'slug': '$slug',
        'type': type ?? 'campaign',
        'featured_image': featuredImage ?? '',
        '__route': RoutePaths.campaignDetailsScreen,
      };

  Campaign copyWith(
          {int? id,
          int? userId,
          String? groupId,
          String? title,
          String? type,
          String? details,
          String? goal,
          DateTime? deadline,
          String? timePeriod,
          dynamic adopters,
          String? status,
          String? featured,
          int? image,
          int? completed,
          int? expired,
          int? stopped,
          String? active,
          String? slug,
          String? ip,
          int? likes,
          int? views,
          dynamic extraCharges1Title,
          dynamic extraCharges1Value,
          String? extraCharges1Type,
          String? createdAt,
          String? updatedAt,
          dynamic extraCharges2Title,
          dynamic extraCharges2Value,
          String? extraCharges2Type,
          String? paymentGatewayValue,
          String? paymentGatewayType,
          String? platformServicesValue,
          String? platformServicesType,
          String? groupAdminValue,
          String? groupAdminType,
          int? donors,
          num? raisedAmount,
          num? monthly,
          num? yearly,
          num? oneTime,
          int? remainingDays,
          Options? options,
          Donation? lastDonation,
          List<dynamic>? media,
          String? featuredImage,
          String? charity,
          String? charityImage}) =>
      Campaign(
          id: id ?? this.id,
          userId: userId ?? this.userId,
          groupId: groupId ?? this.groupId,
          title: title ?? this.title,
          type: type ?? this.type,
          details: details ?? this.details,
          goal: goal ?? this.goal,
          deadline: deadline ?? this.deadline,
          timePeriod: timePeriod ?? this.timePeriod,
          adopters: adopters ?? this.adopters,
          status: status ?? this.status,
          featured: featured ?? this.featured,
          image: image ?? this.image,
          completed: completed ?? this.completed,
          expired: expired ?? this.expired,
          stopped: stopped ?? this.stopped,
          active: active ?? this.active,
          slug: slug ?? this.slug,
          ip: ip ?? this.ip,
          likes: likes ?? this.likes,
          views: views ?? this.views,
          extraCharges1Title: extraCharges1Title ?? this.extraCharges1Title,
          extraCharges1Value: extraCharges1Value ?? this.extraCharges1Value,
          extraCharges1Type: extraCharges1Type ?? this.extraCharges1Type,
          createdAt: createdAt ?? this.createdAt,
          updatedAt: updatedAt ?? this.updatedAt,
          extraCharges2Title: extraCharges2Title ?? this.extraCharges2Title,
          extraCharges2Value: extraCharges2Value ?? this.extraCharges2Value,
          extraCharges2Type: extraCharges2Type ?? this.extraCharges2Type,
          paymentGatewayValue: paymentGatewayValue ?? this.paymentGatewayValue,
          paymentGatewayType: paymentGatewayType ?? this.paymentGatewayType,
          platformServicesValue:
              platformServicesValue ?? this.platformServicesValue,
          platformServicesType:
              platformServicesType ?? this.platformServicesType,
          groupAdminValue: groupAdminValue ?? this.groupAdminValue,
          groupAdminType: groupAdminType ?? this.groupAdminType,
          donors: donors ?? this.donors,
          raisedAmount: raisedAmount ?? this.raisedAmount,
          monthly: monthly ?? this.monthly,
          yearly: yearly ?? this.yearly,
          oneTime: oneTime ?? this.oneTime,
          remainingDays: remainingDays ?? this.remainingDays,
          options: options ?? this.options,
          lastDonation: lastDonation ?? this.lastDonation,
          media: media ?? this.media,
          featuredImage: featuredImage ?? this.featuredImage,
          charity: charity ?? this.charity,
          charityImage: charityImage ?? this.charityImage);

  factory Campaign.fromJson(String str) => Campaign.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Campaign.fromMap(Map<String, dynamic> json) => Campaign(
      id: json["id"],
      userId: json["user_id"],
      groupId: json["group_id"],
      title: json["title"],
      type: json["type"],
      details: json["details"],
      goal: json["goal"],
      deadline: DateTime.tryParse(json["deadline"] ?? ''),
      timePeriod: json["time_period"],
      adopters: json["adopters"],
      status: json["status"],
      featured: json["featured"],
      image: json["image"],
      completed: json["completed"],
      expired: json["expired"],
      stopped: json["stopped"],
      active: json["active"],
      slug: json["slug"],
      ip: json["ip"],
      likes: json["likes"],
      views: json["views"],
      extraCharges1Title: json["extra_charges1_title"],
      extraCharges1Value: json["extra_charges1_value"],
      extraCharges1Type: json["extra_charges1_type"],
      createdAt: json["created_at"],
      updatedAt: json["updated_at"],
      extraCharges2Title: json["extra_charges2_title"],
      extraCharges2Value: json["extra_charges2_value"],
      extraCharges2Type: json["extra_charges2_type"],
      paymentGatewayValue: json["payment_gateway_value"],
      paymentGatewayType: json["payment_gateway_type"],
      platformServicesValue: json["platform_services_value"],
      platformServicesType: json["platform_services_type"],
      groupAdminValue: json["group_admin_value"],
      groupAdminType: json["group_admin_type"],
      donors: json["donors"],
      raisedAmount: json["raised_amount"],
      monthly: num.tryParse('${json["monthly"]}'),
      yearly: num.tryParse('${json["yearly"]}'),
      oneTime: num.tryParse('${json["one_time"]}'),
      remainingDays: json["remaining_days"],
      options:
          json["options"] == null ? null : Options.fromMap(json["options"]),
      lastDonation: json["last_donation"] == null
          ? null
          : Donation.fromMap(json["last_donation"]),
      media: List<dynamic>.from(
        (json["media"] ?? []).map((x) => x),
      ),
      featuredImage: json["featured_image"],
      charity: json['charity']['title'],
      charityImage: json['charity']['image']);

  Map<String, dynamic> toMap() => {
        "id": id,
        "user_id": userId,
        "group_id": groupId,
        "title": title,
        "type": type,
        "details": details,
        "goal": goal,
        "deadline": deadline?.toIso8601String(),
        "time_period": timePeriod,
        "adopters": adopters,
        "status": status,
        "featured": featured,
        "image": image,
        "completed": completed,
        "expired": expired,
        "stopped": stopped,
        "active": active,
        "slug": slug,
        "ip": ip,
        "likes": likes,
        "views": views,
        "extra_charges1_title": extraCharges1Title,
        "extra_charges1_value": extraCharges1Value,
        "extra_charges1_type": extraCharges1Type,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "extra_charges2_title": extraCharges2Title,
        "extra_charges2_value": extraCharges2Value,
        "extra_charges2_type": extraCharges2Type,
        "payment_gateway_value": paymentGatewayValue,
        "payment_gateway_type": paymentGatewayType,
        "platform_services_value": platformServicesValue,
        "platform_services_type": platformServicesType,
        "group_admin_value": groupAdminValue,
        "group_admin_type": groupAdminType,
        "donors": donors,
        "raised_amount": raisedAmount,
        "monthly": monthly,
        "yearly": yearly,
        "one_time": oneTime,
        "remaining_days": remainingDays,
        "options": options?.toMap(),
        "last_donation": lastDonation?.toMap(),
        "media": List<dynamic>.from((media ?? {}).map((x) => x)),
        "featured_image": featuredImage,
        "charity": {"image": charityImage, "title": charity}
      };
}
