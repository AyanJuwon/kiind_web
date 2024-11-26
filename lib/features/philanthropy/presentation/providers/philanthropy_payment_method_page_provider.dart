import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_paypal/flutter_paypal.dart';
// import 'package:flutter_paypal/flutter_paypal_subscription.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
// import 'package:flutter_stripe/flutter_stripe.dart';
// import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:kiind_web/core/constants/endpoints.dart';
import 'package:kiind_web/core/models/donation_info_model.dart';
import 'package:kiind_web/core/models/payment_detail.dart';
import 'package:kiind_web/core/models/payment_method.dart'
    as kind_payment_method;
import 'package:kiind_web/core/providers/base_provider.dart';

import 'package:kiind_web/core/router/route_paths.dart';
import 'package:kiind_web/core/util/visual_alerts.dart';
import 'package:oktoast/oktoast.dart';
import 'package:paypal_payment/paypal_payment.dart';

class PhilanthropyPaymentMethodPageProvider extends BaseProvider {
  List<kind_payment_method.PaymentMethod>? paymentMethods;

  void getPaymentMethods() async {
    if (loading) return;
    loading = true;

    try {
      final result = await client.get(Endpoints.getPaymentMethods);

      if (result.statusCode == 200 || result.statusCode == 201) {
        final List methods = result.data['data'];
        paymentMethods = methods
            .map((method) => kind_payment_method.PaymentMethod.fromMap(method))
            .where((method) =>
                method.title!.toLowerCase() == 'paypal' ||
                method.title!.toLowerCase() == 'stripe')
            .toList();
      }
    } on DioException {
      showAlertToast('An error occurred. Please try again');
    }

    loading = false;
  }

  String methodLogo(kind_payment_method.PaymentMethod method) {
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

  void initKiindDonation(BuildContext context, DonationInfoModel donationInfo,
      kind_payment_method.PaymentMethod paymentMethod) async {
    if (loading) return;
    loading = true;
    PaymentDetail? detail;

    try {
      final result = await client.post(Endpoints.initiateKiindDonation, data: {
        'payment_method': paymentMethod.title!.toLowerCase(),
        'amount': donationInfo.amount,
        'interval': parseInterval(donationInfo.interval),
      });

      if (result.statusCode == 200 || result.statusCode == 201) {
        detail = PaymentDetail.fromMap(
            Map<String, dynamic>.from(result.data['data']));
      }
    } on DioException {
      loading = false;
      showAlertToast('An error occurred. Please try again');
    }

    // loading = false;
    if (detail != null) {
      switch (paymentMethod.title!.toLowerCase()) {
        case 'paypal':
          paypalPaymentHandler(context, donationInfo, paymentMethod, detail);
          break;
        case 'stripe':
          stripePaymentHandler(context, donationInfo, paymentMethod, detail);
          break;
        default:
      }
    }
  }

  void finalizeKiindDonation(
      BuildContext context,
      DonationInfoModel donationInfo,
      kind_payment_method.PaymentMethod paymentMethod,
      PaymentDetail paymentDetail,
      Map? payload,
      {bool isPaypal = false}) async {
    // loading = true;
    print("paypal mode :: ${paymentDetail.gateway?.sandbox}");
    print("paypal payload :: $payload");
    try {
      final result = await client.post(Endpoints.finalizeKiindDonation, data: {
        'payment_method': paymentMethod.title!.toLowerCase(),
        'amount': donationInfo.amount,
        'interval': parseInterval(donationInfo.interval),
        'plan': paymentDetail.gateway!.plan,
        'subscription_id': paymentDetail.subscriptionId,
        'payload': payload,
        'gift_aid': donationInfo.giftAid
      });

      print('finalize payment result');
      print(result.data);

      if (result.statusCode == 200) {
        // if (!isPaypal) {
        loading = false;
        Navigator.of(context).pushNamed(RoutePaths.paymentSuccessfulScreen);
        // }
      }
    } on DioException {
      showAlertToast('An error occurred. Please try again');
    }

    loading = false;
  }

  void paypalPaymentHandler(
      BuildContext context,
      DonationInfoModel donationInfo,
      kind_payment_method.PaymentMethod paymentMethod,
      PaymentDetail paymentDetail) async {
    bool shouldPop = true;
    print(" paypal payment plan ::: ${donationInfo.plan}");
    print(" paypal payment interval ::: ${donationInfo.interval}");

    await showDialog(
        context: context,
        builder: (modalContext) {
          final interval = parseInterval(donationInfo.interval);
          if (interval != 'month' && interval != 'year') {
            final paypalTransactions = [
              {
                "amount": {
                  "total": '${paymentDetail.amounts?.userSubmittedAmount ?? 0}',
                  "currency": "USD",
                  "details": {
                    "subtotal":
                        '${paymentDetail.amounts?.userSubmittedAmount ?? 0}',
                    "shipping": '0',
                    "shipping_discount": 0,
                  }
                },
                "description": "The payment transaction description.",
                "item_list": {
                  "items": [
                    {
                      "name": "${paymentDetail.cause != null ? paymentDetail.cause.title : 'Portfolio Donation'}",
                      "quantity": 1,
                      "price":
                          '${paymentDetail.amounts?.userSubmittedAmount ?? 0}',
                      "currency": "USD",
                    }
                  ]
                }
              }
            ];

            print("paypal mode 0 :: ${paymentDetail.gateway?.sandbox}");

            return PaypalOrderPayment(
              sandboxMode: paymentDetail.gateway!.sandbox,
              cancelURL: paymentDetail.gateway!.cancelUrl!,
              note: "Contact us for any questions on your subscription.",
              clientId: paymentMethod.apiKey!,
              secretKey: paymentMethod.apiSecret!,
              currencyCode: "USD",
              amount: paymentDetail.amounts?.userSubmittedAmount.toString() ??
                  "0.0",
              returnURL: "https://kiind.co.uk/?__route=payment_successful",
              onSuccess: (Map params) {
                log('Payment transaction was succesfull $params');
                shouldPop = false;
                finalizeKiindDonation(
                    context, donationInfo, paymentMethod, paymentDetail, params,
                    isPaypal: false);
              },
              onError: (error) {
                log('paypal error 0  $error');
                showToast(
                    'An error occurred processing your one-time transaction. Please try again.');
              },
              onCancel: (params) {
                log('payment cancelled $params');
              },
            );
          }
          return PaypalSubscriptionPayment(
            sandboxMode: paymentDetail.gateway!.sandbox,
            clientId: paymentMethod.apiKey!,
            secretKey: paymentMethod.apiSecret!,
            productName:   'Portfolio Donation',
            type: "PHYSICAL",
            planName:    'Portfolio Donation',
            planId: paymentDetail.gateway!.plan!,
            billingCycles: [
              {
                'tenure_type': 'REGULAR',
                'sequence': 1,
                "total_cycles": 12,
                'pricing_scheme': {
                  'fixed_price': {
                    'currency_code': "USD",
                    'value':
                        '${paymentDetail.amounts?.userSubmittedAmount ?? 0}',
                  }
                },
                'frequency': {
                  "interval_unit": interval.replaceAll('ly', '').toUpperCase(),
                  "interval_count": 1
                }
              }
            ],
            paymentPreferences: const {"auto_bill_outstanding": true},
            returnURL: "https://kiind.co.uk/?__route=payment_successful",
            cancelURL: paymentDetail.gateway!.cancelUrl!,
            onSuccess: (Map params) {
              log('Payment was succesfull $params');
              shouldPop = false;
              finalizeKiindDonation(
                  context, donationInfo, paymentMethod, paymentDetail, params,
                  isPaypal: true);
            },
            onError: (error) {
              log('paypal error 1 $error');
              showToast(
                  'An error occurred processing your transaction. Please try again.');
            },
            onCancel: (params) {
              log('payment cancelled $params');
            },
          );
        });

    if (shouldPop) {
      Navigator.of(context).pop();
    }
    // Navigator.of(context).pushNamed(
    //   RoutePaths.paymentSuccessfulScreen
    // );
  }

  void stripePaymentHandler(
      BuildContext context,
      DonationInfoModel donationInfo,
      kind_payment_method.PaymentMethod paymentMethod,
      PaymentDetail paymentDetail) async {
    log('got to stripe payment');
    final gateway = paymentDetail.gateway;
    log('got to stripe payment $gateway');

    if (gateway != null) {
      Stripe.publishableKey = gateway.publicKey!;
      Stripe.merchantIdentifier = 'Kiind';
      await Stripe.instance.applySettings();
      await Stripe.instance.initPaymentSheet(
          paymentSheetParameters: SetupPaymentSheetParameters(
        merchantDisplayName: 'Kiind',
        customerId: null,
        paymentIntentClientSecret: gateway.paymentIntent!,
        customerEphemeralKeySecret: gateway.privateKey!,
        applePay: const PaymentSheetApplePay(merchantCountryCode: 'GB'),
        googlePay: const PaymentSheetGooglePay(merchantCountryCode: 'GB'),
        style: Theme.of(context).brightness == Brightness.dark
            ? ThemeMode.dark
            : ThemeMode.light,
        // primaryButtonColor: bg,
        // testEnv: gateway.sandbox,
      ));
      await Stripe.instance.applySettings();

      try {
        await Stripe.instance.presentPaymentSheet();
        finalizeKiindDonation(
            context, donationInfo, paymentMethod, paymentDetail, null);
      } on Exception {
        loading = false;
        showAlertToast(
            'An error occurred processing your transaction. Please try again.');
      }
    }
  }

  // void stripePaymentHandler(
  //     BuildContext context,
  //     DonationInfoModel donationInfo,
  //     kind_payment_method.PaymentMethod paymentMethod,
  //     PaymentDetail paymentDetail) async {
  //   log('got to stripe payment');
  //   final gateway = paymentDetail.gateway;

  //   // if (gateway != null) {
  //   //   Stripe.publishableKey = gateway.publicKey!;
  //   //   Stripe.merchantIdentifier = 'eCare';
  //   //   await Stripe.instance.applySettings();
  //   //   await Stripe.instance.initPaymentSheet(
  //   //     paymentSheetParameters: SetupPaymentSheetParameters(
  //   //         merchantDisplayName: 'eCare',
  //   //         customerId: null,
  //   //         paymentIntentClientSecret: gateway.paymentIntent!,
  //   //         customerEphemeralKeySecret: gateway.privateKey!,
  //   //         applePay: true,
  //   //         googlePay: true,
  //   //         style: Theme.of(context).brightness == Brightness.dark
  //   //             ? ThemeMode.dark
  //   //             : ThemeMode.light,
  //   //         //  primaryButtonColor: bg,
  //   //         testEnv: gateway.sandbox,
  //   //         merchantCountryCode: 'GB'
  //   //         ),
  //   //   );
  //   //   await Stripe.instance.applySettings();

  //   //   try {
  //   //     await Stripe.instance.presentPaymentSheet();
  //   //     finalizeKiindDonation(
  //   //         context, donationInfo, paymentMethod, paymentDetail, null);
  //   //   } on Exception {
  //   //     loading = false;
  //   //     showAlertToast(
  //   //         'An error occurred processing your transaction. Please try again.');
  //   //   }
  //   // }
  // }
}

// sb-4mnjb10941552@personal.example.com

String parseInterval(String interval) {
  interval = interval.toLowerCase();
  if (interval == 'monthly' || interval == 'yearly') {
    return interval.replaceAll('ly', '');
  }

  return 'single';
}
