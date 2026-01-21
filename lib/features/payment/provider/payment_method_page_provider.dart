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
      } else {
        // Show error dialog for non-successful responses
        _showErrorDialog(context, 'Failed to load payment methods. Please try again later.');
      }
    } on DioException catch (e) {
      // Handle Dio errors with user-friendly messages
      String errorMessage = 'An error occurred while loading payment methods.';

      if (e.response != null) {
        print('Error loading payment methods: ${e.response?.data}');

        // Check for specific error conditions
        if (e.response?.statusCode == 500) {
          errorMessage = 'Server error occurred. Please try again later.';
        } else if (e.response?.statusCode == 400) {
          errorMessage = 'Invalid request. Please try again.';
        } else if (e.response?.statusCode == 401) {
          errorMessage = 'Unauthorized access. Please log in again.';
        } else if (e.response?.data is Map && e.response?.data['message'] != null) {
          errorMessage = e.response?.data['message'].toString() ?? errorMessage;
        }
      } else if (e.type == DioExceptionType.connectionError || e.type == DioExceptionType.connectionTimeout) {
        errorMessage = 'Connection error. Please check your internet connection.';
      } else {
        print('Error loading payment methods: ${e.message}');
      }

      _showErrorDialog(context, errorMessage);
    } on Exception catch (e) {
      // Handle any other exceptions
      print('Unexpected error loading payment methods: $e');
      _showErrorDialog(context, 'An unexpected error occurred while loading payment methods. Please try again later.');
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<void> selectMethod(PaymentMethod method, BuildContext context, amount) async {
    try {
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

      // Check if this is a charity donation by looking for charity_id in context.args
      bool isCharityDonation = context.args.containsKey('__charity_id');
      if (isCharityDonation) {
        // Add charity_id to the payment details
        finalPaymentDetails['__charity_id'] = context.args['__charity_id'];
      }

      print("latest payment_method ::: ${method.toMap()}");

      // Navigate to appropriate payment summary page based on donation type
      if (isCharityDonation) {
        context.to(
          RoutePaths.charityPaymentSummaryScreen,
          args: finalPaymentDetails
            ..putIfAbsent(
              '__method',
              () => method.toMap(),
            ),
        );
      } else {
        context.to(
          RoutePaths.paymentSummaryScreen,
          args: finalPaymentDetails
            ..putIfAbsent(
              '__method',
              () => method.toMap(),
            ),
        );
      }

      if (saveAsDefault) {
        // save to box
      }
    } catch (e) {
      print('Navigation error: $e');
      _showErrorDialog(context, 'Failed to navigate to payment page. Please try again.');
    }
  }

  // Helper method to show error dialogs to users
  Future<void> _showErrorDialog(BuildContext context, String message) async {
    if (context.mounted) {
      await showDialog(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: const Text('Payment Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Close dialog
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
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
