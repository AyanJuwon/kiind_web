// ignore_for_file: use_build_context_synchronously

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:kiind_web/core/models/campaign_model.dart';
import 'package:kiind_web/core/models/payment_detail.dart';
import 'package:kiind_web/core/models/payment_method.dart';
import 'package:kiind_web/core/providers/base_provider.dart';
import 'package:kiind_web/core/router/route_paths.dart';
import 'package:kiind_web/core/util/extensions/buildcontext_extensions.dart';
import 'package:kiind_web/core/util/extensions/response_extensions.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/constants/endpoints.dart';

class PaymentMethodPageProvider extends BaseProvider {
  Map<int, PaymentMethod> paymentMethods = {};

  bool saveAsDefault = false;
  String? token;
  Campaign? campaign;
  @override
  init(
    BuildContext context, {
    String? dbKey,
    bool needsUser = true,
    bool shouldGetUser = false,
    Function(BuildContext)? callback,
    bool refresh = true,
  }) {
    super.init(
      context,
      callback: _fetchMethods,
    );
  }

  fetchCampaign(BuildContext context, int campaignID) async {
    final prefs = await SharedPreferences.getInstance();
    token = (await prefs.getString('token'))!;
    Response res = await client.get(
      "${Endpoints.campaignDetail}/$campaignID",
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json'
        },
        extra: {'context': context},
      ),
    );
    // log("fetched res $res");
    if (res.isValid) {
      campaign = Campaign.fromMap(Map<String, dynamic>.from(res.info!.data));
    }
  }

  _fetchMethods(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    token = (await prefs.getString('token'))!;
    await getUser(context);
    Response res = await client.get(
      Endpoints.getPaymentMethods,
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json'
        },
        extra: {'context': context},
      ),
    );
    loading = false;
    notifyListeners();
    if (res.isValid) {
      Map<String, dynamic> detailMap = Map<String, dynamic>.from(context.args);

      PaymentDetail detail = PaymentDetail.fromMap(detailMap);

      bool other = detail.cause?.isOther ?? false;

      for (var v in res.info!.data) {
        // if ((!_other) || (v['id'] != 4)) {
        if (v['id'] != 4) {
          paymentMethods[v['id']] = PaymentMethod.fromMap(v);
        }
      }

      if (!other) {
        paymentMethods[10000] = PaymentMethod(
          id: 10000,
          title: 'Wallet',
        );
      }
    }

    notifyListeners();
  }

  selectMethod(PaymentMethod method, BuildContext context, amount) {
    print(context.args);
    final paymentDetail = PaymentDetail.fromMap({
      "gateway": null,
      "purpose": null,
      "post": null,
      "campaign": campaign!.toMap(),
      "charges": null,
      "amounts": {
        "user_submitted_amount": amount,
        "amount_after_charges_deduction": null
      },
      "subscription_id": null
    });
    dynamic finalPaymentDetails = paymentDetail.toMap();
    finalPaymentDetails["__type"] = context.args["__type"];
    context.to(
      RoutePaths.paymentSummaryScreen,
      args: finalPaymentDetails
        ..putIfAbsent(
          '__method',
          () => method.toMap(),
        ),
    );

    if (saveAsDefault) {
      // save to box
    }
  }

  String methodLogo(PaymentMethod method) {
    String logo = '';

    switch (method.id) {
      case 3:
        logo = 'https://cdn-icons-png.flaticon.com/512/174/174861.png';
        break;
      case 4:
        logo =
            'https://www.braintreepayments.com/images/braintree-logo-black.png';
        break;
      case 5:
        logo = 'https://cdn-icons-png.flaticon.com/512/1198/1198299.png';
        break;
      case 10000:
      default:
        logo = 'https://img.icons8.com/color/452/wallet--v1.png';
        break;
    }

    return logo;
  }
}
