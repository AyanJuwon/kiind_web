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
  @override
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
    token = (prefs.getString('token'))!;
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

  Future<void> _fetchMethods(BuildContext context) async {
    loading = true;
    notifyListeners();

    try {
      // Initialize Dio
      final dio = Dio(
        BaseOptions(
          baseUrl: 'https://app.kiind.co.uk/api/v2',
          headers: {'Accept': 'application/json'},
        ),
      );

      // Retrieve token from SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        throw Exception('Token not found');
      }

      // Fetch user details
      await getUser(context);

      // API call to get payment methods
      final response = await dio.get(
        Endpoints.getPaymentMethods, // Use the correct endpoint path
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
          extra: {'context': context}, // Pass additional context if needed
        ),
      );

      // Validate response
      if (response.statusCode == 200 && response.data != null) {
        final responseData = response.data;
        print(responseData);

        Map<String, dynamic> detailMap =
            Map<String, dynamic>.from(context.args);

        PaymentDetail detail = PaymentDetail.fromMap(detailMap);

        bool other = detail.cause?.isOther ?? false;

        for (var v in responseData['data']) {
          // if (v['id'] != 7) {
            paymentMethods[v['id']] = PaymentMethod.fromMap(v);
          // }
        }

        if (!other) {
          paymentMethods[10000] = PaymentMethod(
            id: 10000,
            title: 'Wallet',
          );
        }
      }
    } on DioException catch (e) {
      // Handle Dio errors
      if (e.response != null) {
        print('Error: ${e.response?.data}');
      } else {
        print('Error: ${e.message}');
      }
    } finally {
      loading = false;
      notifyListeners();
    }
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
    print("latest payment_method ::: ${method.toMap()}");
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
      // case 8:
      //   logo =
      //       'https://www.braintreepayments.com/images/braintree-logo-black.png';
      //   break;
      case 8 :
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
