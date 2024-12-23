// ignore_for_file: avoid_web_libraries_in_flutter

import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_braintree/flutter_braintree.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
// import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:flutter_stripe_web/flutter_stripe_web.dart';
import 'package:kiind_web/core/constants/endpoints.dart';
import 'package:kiind_web/core/models/gateway_model.dart';
import 'package:kiind_web/core/models/payment_detail.dart';
import 'package:kiind_web/core/models/payment_method.dart' as kiind_pay;
import 'package:kiind_web/core/models/post_model.dart';
import 'package:kiind_web/core/models/user_model.dart';
import 'package:kiind_web/core/providers/base_provider.dart';
import 'package:kiind_web/core/router/route_paths.dart';
import 'package:kiind_web/core/util/extensions/buildcontext_extensions.dart';
import 'package:kiind_web/core/util/extensions/response_extensions.dart';
import 'package:kiind_web/core/util/visual_alerts.dart';
import 'package:paypal_payment/paypal_payment.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:html' as html;
  import 'dart:convert';
enum PaymentType {
  oneTime,
  subscription,
  deposit,
}

class PaymentSummaryPageProvider extends BaseProvider {
  ValueNotifier<PaymentDetail?> paymentDetail = ValueNotifier(null);
  ValueNotifier<bool> processingPayment = ValueNotifier(false);
// String myPosHtml = '';
  PaymentType paymentType = PaymentType.oneTime;
  String? interval = 'one_time';

  bool get isSub => interval != 'one_time';


final cancelUrl = Uri.encodeFull('https://app.kiind.co.uk/callback?__route=payment_cancelled');

  @override
  String? token;
  String get initEndpoint {
    String endpoint = '';

    if (paymentDetail.value?.purpose == null) {
      switch (paymentType.index) {
        case 1:
          endpoint = isSub
              ? Endpoints.initiateSubscription
              : Endpoints.initiatePayment;
          break;
        case 2:
          endpoint = Endpoints.initiateDeposit;
          break;
        case 0:
        default:
          endpoint = Endpoints.initiatePayment;
          break;
      }
    } else {
      endpoint = Endpoints.initiateEcarePay;
    }

    return endpoint;
  }

  String get finalEndpoint {
    String endpoint = '';

    if (paymentDetail.value?.purpose == null) {
      switch (paymentType.index) {
        case 1:
          endpoint = isSub
              ? Endpoints.finalizeSubscription
              : Endpoints.finalizePayment;
          break;
        case 2:
          endpoint = Endpoints.finalizeDeposit;
          break;
        case 0:
        default:
          endpoint = Endpoints.finalizePayment;
          break;
      }
    } else {
      endpoint = Endpoints.finalizeEcarePay;
    }

    return endpoint;
  }

  late kiind_pay.PaymentMethod? method;

  late BraintreeDropInRequest btReq;
  BraintreeDropInResult? btRes;

  dynamic paymentPayload;
  User? user;
  List paypalTransactions = [];

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
      callback: fetchPaymentDetails,
    );
  }

Future<void> handlePaymentMethod(Map<dynamic, dynamic> contextArgs) async {
  final prefs = await SharedPreferences.getInstance();

  // Extract __method from contextArgs
  final contextMethod = contextArgs['__method'];

  if (contextMethod != null) {
    // Save the context method to SharedPreferences
    final paymentMethodJson = jsonEncode(contextMethod);
    await prefs.setString('payment_method', paymentMethodJson);

    // Initialize the method
    method = kiind_pay.PaymentMethod.fromMap(contextMethod);
  } else {
    // If contextMethod is null, check SharedPreferences
    final paymentMethodJson = prefs.getString('payment_method');
    if (paymentMethodJson != null && paymentMethodJson.isNotEmpty) {
      final paymentMethodMap = jsonDecode(paymentMethodJson) as Map<String, dynamic>;
      method = kiind_pay.PaymentMethod.fromMap(paymentMethodMap);
    } else {
      throw Exception("No payment method found in SharedPreferences or context.args['__method']");
    }
  }

  // Log the current payment method
  print('Current Payment Method: ${method.toString()}');
}
  Future<void> fetchPaymentDetails(BuildContext context) async {
  loading = false;
  notifyListeners();

  try {
    // Retrieve user profile
    user = await getUserProfile();
    notifyListeners();

    // Extract and process payment details from context
    Map<String, dynamic> paymentDetailMap =
        Map<String, dynamic>.from(context.args);
    paymentDetail.value = PaymentDetail.fromMap(paymentDetailMap);

    paymentType = PaymentType.values[context.args['__type'] ?? 0];

    if (context.args['__interval'] != null) {
      interval = context.args['__interval'];
    }

    // Handle payment method using the reusable function
    await handlePaymentMethod(context.args);

    // Retrieve saved payment method from SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    final paymentMethodJson = prefs.getString('payment_method');
    if (paymentMethodJson == null || paymentMethodJson.isEmpty) {
      throw Exception('Payment method not found');
    }
    final method = kiind_pay.PaymentMethod.fromMap(
      jsonDecode(paymentMethodJson) as Map<String, dynamic>,
    );

    Map<String, dynamic> data = {
      "payment_method": method.title?.toLowerCase(),
      "amount": paymentDetail.value?.amounts?.userSubmittedAmount,
      "interval": interval?.replaceAll('ly', ''),
      "device": 'ios',
    };

    if (paymentType != PaymentType.deposit) {
      data["id"] = paymentDetail.value?.cause?.id;
    }

    // Initialize Dio
    final dio = Dio(
      BaseOptions(
        baseUrl: 'https://app.kiind.co.uk/api/v2',
        headers: {'Accept': 'application/json'},
      ),
    );

    // Retrieve token from SharedPreferences
    final token = prefs.getString('token');
    if (token == null) {
      throw Exception('Token not found');
    }

    // API call to initiate payment
    final response = await dio.post(
      initEndpoint,
      data: data,
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
        },
        extra: {'context': context},
      ),
    );

    if (response.statusCode == 200 && response.data != null) {
      print("data to from response initiate::::: ${response}");
      String? initialPurpose = paymentDetail.value?.purpose;

      // Use the response to initialize gateway
      PaymentDetail detail = PaymentDetail.fromMap(
        Map<String, dynamic>.from(response.data['data']),
      );

      if (paymentType == PaymentType.deposit) {
        paymentDetail.value = paymentDetail.value?.copyWith(
          gateway: detail.gateway,
          purpose: initialPurpose,
          html: detail.html,
        );
      } else {
        paymentDetail.value = detail.copyWith(
          purpose: initialPurpose,
        );
      }

      await initializeGateway(context);
    } else {
      context.back(times: 2);
    }
  } on DioException catch (e) {
    // Handle Dio errors
    if (e.response != null) {
      print('Error: ${e.response?.data}');
    } else {
      print('Error: ${e.message}');
    }
    context.back(times: 2); // Handle failure
  } finally {
    loading = false;
    notifyListeners();
  }
}

  // Future<void> fetchPaymentDetails(BuildContext context) async {
  //   loading = false;
  //   notifyListeners();

  //   try {
  //     // Retrieve user profile
  //     user = await getUserProfile();
  //     notifyListeners();

  //     // Extract and process payment details from context
  //     Map<String, dynamic> paymentDetailMap =
  //         Map<String, dynamic>.from(context.args);
  //     paymentDetail.value = PaymentDetail.fromMap(paymentDetailMap);

  //     paymentType = PaymentType.values[context.args['__type'] ?? 0];

  //     if (context.args['__interval'] != null) {
  //       interval = context.args['__interval'];
  //     }

  //     final prefs = await SharedPreferences.getInstance(); 

  //     method = kiind_pay.PaymentMethod.fromMap(context.args['__method']);

  //     Map<String, dynamic> data = {
  //       "payment_method": method?.title?.toLowerCase(),
  //       "amount": paymentDetail.value?.amounts?.userSubmittedAmount,
  //       "interval": interval?.replaceAll('ly', ''),
  //       "device": 'ios',
  //     };

  //     if (paymentType != PaymentType.deposit) {
  //       data["id"] = paymentDetail.value?.cause?.id;
  //     }

  //     // Initialize Dio
  //     final dio = Dio(
  //       BaseOptions(
  //         baseUrl: 'https://app.kiind.co.uk/api/v2',
  //         headers: {'Accept': 'application/json'},
  //       ),
  //     );
 
  //     final token = prefs.getString('token');

  //     if (token == null) {
  //       throw Exception('Token not found');
  //     } 
  //     // API call to initiate payment
  //     final response = await dio.post(
  //       initEndpoint,
  //       data: data,
  //       options: Options(
  //         headers: {
  //           'Authorization': 'Bearer $token',
  //         },
  //         extra: {'context': context},
  //       ),
  //     );

  //     if (response.statusCode == 200 && response.data != null) {

  //     print("data to from response initiate::::: ${response}");
  //       String? initialPurpose = paymentDetail.value?.purpose;

  //       // Use the response to initialize gateway
  //       PaymentDetail detail = PaymentDetail.fromMap(
  //         Map<String, dynamic>.from(response.data['data']),
  //       );

  //       if (paymentType == PaymentType.deposit) {
  //         paymentDetail.value = paymentDetail.value?.copyWith(
  //           gateway: detail.gateway,
  //           purpose: initialPurpose,
  //           html: detail.html
  //         );
  //       } else {
  //         paymentDetail.value = detail.copyWith(
  //           purpose: initialPurpose,
            
  //         );
  //       }

  //         // myPosHtml = response.info!.data['gateway']['original']['data']?? '';
  //     await initializeGateway(context,);

  //     } else {
  //       context.back(times: 2);
  //     }
  //   } on DioException catch (e) {
  //     // Handle Dio errors
  //     if (e.response != null) {
  //       print('Error: ${e.response?.data}');
  //     } else {
  //       print('Error: ${e.message}');
  //     }
  //     context.back(times: 2); // Handle failure
  //   } finally {
  //     loading = false;
  //     notifyListeners();
  //   }
  // }



  initializeGateway(BuildContext context) async {
    try {
      switch (method?.id) {
        case 3:
          await initPaypal(context);
          break;
        case 5:
          await initStripe(context);
          break;
        case 4:
        default:
            await initStripe(context);
          break;
      }
    } on Exception catch (e) {
      log('Could not Initialize gateway\n$e', name: 'Payment Error');
    }
  }

  initStripe(BuildContext context) async {
    PaymentDetail? _detail = paymentDetail.value;
    Gateway? _gateway = _detail?.gateway;

    if (_gateway != null) {
      // Stripe.publishableKey = _gateway.publicKey!;
      // Stripe.merchantIdentifier = 'Kiind';
      // Stripe.stripeAccountId = '';

// WebStripe.instance.initialise(publishableKey: _gateway.publicKey!,
// merchantIdentifier: "Kiind");
      // await WebStripe.instance.initPaymentSheet(
      //     SetupPaymentSheetParameters(
            
      //     returnURL: _gateway.notifyUrl,
      //     // Main params
      //     merchantDisplayName: 'Kiind',
      //     // Customer params
      //     customerId: null, // _gateway.customerKey!,
      //     paymentIntentClientSecret: _gateway.paymentIntent!,
      //     customerEphemeralKeySecret: _gateway.privateKey!,
      //     // Extra params
      //      applePay: PaymentSheetApplePay(
      //     merchantCountryCode: 'GB',
        
      //     // buttonType: ApplePayButtonType.book,
      //   ),
      //   googlePay: PaymentSheetGooglePay(
      //     merchantCountryCode: 'GB',
      //     testEnv: _gateway.sandbox ?? false,
      //   ),
      //     style: context.brightness == Brightness.dark
      //         ? ThemeMode.dark
      //         : ThemeMode.light,
      //     // primaryButtonColor: bg,
      //     // billingDetails: billingDetails,
      //     // testEnv: _gateway.sandbox,
      //     // merchantCountryCode: 'GB',
      //   ),
      // );

      // // await WebStripe.instance.set;
    }
  }



  initBrainTree(BuildContext context) {
    print("not paypal data here");
    btReq = BraintreeDropInRequest(
      clientToken: paymentDetail.value?.gateway?.privateKey,
      amount: paymentDetail.value?.amounts?.userSubmittedAmount?.toString(),
      collectDeviceData: true,
      googlePaymentRequest: BraintreeGooglePaymentRequest(
        totalPrice: "${paymentDetail.value?.amounts?.userSubmittedAmount}",
        currencyCode: 'GBP',
        billingAddressRequired: false,
      ),
      paypalRequest: BraintreePayPalRequest(
        amount: "${paymentDetail.value?.amounts?.userSubmittedAmount}",
        displayName: 'eCare',
      ),
    );
  }

  initPaypal(BuildContext context) {
    PaymentDetail? detail = paymentDetail.value;

    paypalTransactions = [
      {
        "amount": {
          "total": '${detail!.amounts?.userSubmittedAmount ?? 0}',
          "currency": "USD",
          "details": {
            "subtotal": '${detail.amounts?.userSubmittedAmount ?? 0}',
            "shipping": '0',
            "shipping_discount": 0
          }
        },
        "description": "The payment transaction description.",
        "item_list": {
          "items": [
            {
              "name": "${detail.cause?.title}",
              "quantity": 1,
              "price": '${detail.amounts?.userSubmittedAmount ?? 0}',
              "currency": "USD"
            }
          ]
        }
      }
    ];
  }





  initMyPos(BuildContext context, String html) {
  print("Launching InAppWebView...");
  try {
    Future.delayed(Duration(milliseconds: 100), () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => Scaffold(
            appBar: AppBar(title: Text("My Pos")),
            body: InAppWebView(
              initialData: InAppWebViewInitialData(data: html,),  initialOptions: InAppWebViewGroupOptions(
 
    crossPlatform: InAppWebViewOptions(
      javaScriptEnabled: true,
    
    ),
          ),
        ),
          )));
    });
  } catch (e) {
    print("my pos launch error ::: $e");
  }
}

 Future launchMyPos(BuildContext context) async {
    processingPayment.value = true;
print("starting mypos");
      // initMyPos(context,myPosHtml);

    processingPayment.value = false;
  }
  launchGateway(BuildContext context) async {
    switch (method?.id) {
      case 3:
        await launchPaypal(context);
        break;
      case 8:
        await launchStripe(context);
        break;
     case 7:
        await launchMyPos(context);
        break;
      case 10000:
      default:
        await sendReceiptToServer(context);
        break;
    }
  }

void redirectToStripeCheckout(String url,) {
  final stripeCheckoutUrl = url;
  html.window.open(stripeCheckoutUrl, '_self');
}

  launchStripe(BuildContext context) async {
     Gateway? _gateway = paymentDetail.value?.gateway;
    processingPayment.value = true;
if(_gateway != null){
    try {
      print("launching stripe");
      print("paymentDetail.value!.html");
redirectToStripeCheckout(paymentDetail.value!.html!);
      
         } on Exception catch (e) {
      processingPayment.value = false;
      log('An error occurred at launch\n$e');
      return;
    }

    await sendReceiptToServer(context);
}
  

    processingPayment.value = false;
  }

 

  // launchStripe(BuildContext context) async {
  //   processingPayment.value = true;

  //   try {
  //     await Stripe.instance.presentPaymentSheet();
  //   } on Exception catch (e) {
  //     processingPayment.value = false;
  //     log('An error occurred\n$e');
  //     return;
  //   }

  //   await sendReceiptToServer(context);

  //   processingPayment.value = false;
  // }

  Future launchBraintree(BuildContext context) async {
    processingPayment.value = true;
    try {
      // Stripe.publishableKey = "stripePublishableKey";
      // Stripe.merchantIdentifier = 'com.kiind.app';
      // Stripe.urlScheme = 'flutterstripe';
      await     WebStripe.instance.confirmPaymentElement(
    ConfirmPaymentElementOptions(
      confirmParams: ConfirmPaymentParams(return_url: "https://app.kiind.co.uk/callback?__route=payment_successful"),
    ));
      btRes = await BraintreeDropIn.start(btReq);
      if (btRes != null) {
        await sendReceiptToServer(context);
      } else {
        log('Selection was canceled.');
      }

      processingPayment.value = false;
    } catch (e) {
      print("stripe error ::: $e");
    }
  }

  Future launchPaypal(BuildContext context) async {
    processingPayment.value = true;

    await _launchPaypalModal(context);

    processingPayment.value = false;
  }

  _launchPaypalModal(BuildContext context) async {
    Gateway? gateway = paymentDetail.value?.gateway;
    if (gateway != null && method?.id == 3) {
      print("check if is sub before launcing modal ::: $isSub");
      Navigator.of(context).push(MaterialPageRoute(
          builder: (BuildContext context) => !isSub
              ? PaypalOrderPayment(
                  clientId: gateway.publicKey!,
                  secretKey: gateway.privateKey!,
                  currencyCode: paypalTransactions[0]['amount']['currency'],
                  amount: paypalTransactions[0]['amount']['total'],
                  returnURL: "https://app.kiind.co.uk/callback/?__route=payment_successful",
                  cancelURL: "https://app.kiind.co.uk/callback?__route=payment_cancelled",
                  sandboxMode: gateway.sandbox,
                  note: "Thank you for supporting our cause.",
                  onSuccess: (Map params) async {
                    log("onSuccess: $params");
                    paymentPayload = params;
                    await sendReceiptToServer(context);
                    context.to(RoutePaths.paymentSuccessfulScreen);
                  },
                  onError: (error) {
                    log("onError: $error");
                    Navigator.pop(context);
                    showAlertToast("Paypal error::: $error");
                    // Handle payment error, maybe show a message to the user
                  },
                  onCancel: () {
                    log('Payment cancelled');
                    Navigator.pop(context);
                    showAlertToast("PPayment Cancelled");
                  },
                )
              : PaypalSubscriptionPayment(
                  sandboxMode: true,
                  clientId: gateway.publicKey!,
                  secretKey: gateway.privateKey,
                  productName: paymentDetail.value!.cause.title,
                  type: "PHYSICAL",
                  planName: paymentDetail.value!.cause.title,
                  planId: gateway.plan!,
                  billingCycles: [
                    {
                      'tenure_type': 'REGULAR',
                      'sequence': 1,
                      "total_cycles": 12,
                      'pricing_scheme': {
                        'fixed_price': {
                          'currency_code': "USD",
                          'value':
                              '${paymentDetail.value!.amounts?.userSubmittedAmount ?? 0}',
                        }
                      },
                      'frequency': {
                        "interval_unit":
                            interval?.replaceAll('ly', '').toUpperCase(),
                        "interval_count": 1
                      }
                    }
                  ],
                  paymentPreferences: const {"auto_bill_outstanding": true},
                  returnURL: "https://app.kiind.co.uk/callback?__route=payment_successful",
        
                  cancelURL: "https://app.kiind.co.uk/callback?__route=payment_cancelled",
                  onSuccess: (Map params) async {
                    log("onSuccess: $params");
                    paymentPayload = params;
                    await sendReceiptToServer(context);
                    context.to(RoutePaths.paymentSuccessfulScreen);
                  },
                  onError: (error) {
                    log("onError: $error");
                    Navigator.pop(context);
                    showAlertToast("Paypal error::: $error");
                  },
                  onCancel: () {
                    log('Payment cancelled');
                    Navigator.pop(context);
                    showAlertToast("Payment Cancelled");
                  })));
    }
  }

  // _launchPaypalModal(BuildContext context) async {
  //   Gateway? gateway = paymentDetail.value?.gateway;
  //   if (gateway != null && method?.id == 3) {
  //     Navigator.of(context).push(
  //       MaterialPageRoute(
  //         builder: (modalContext) => Container(
  //           // padding: EdgeInsets.only(top: context.topPadding),
  //           child: isSub
  //               ? UsePaypalSubscription(
  //                   sandboxMode: gateway.sandbox,
  //                   secretKey: gateway.privateKey!,
  //                   clientId: gateway.publicKey!,
  //                   returnURL: gateway.notifyUrl!,
  //                   cancelURL: gateway.cancelUrl!,
  //                   planID: gateway.plan!,
  //                   note: "Contact us for any questions on your subscription.",
  //                   onSuccess: (Map params) async {
  //                     log("onSuccess: $params");
  //                     paymentPayload = params;
  //                     await sendReceiptToServer(context);
  //                     context.to(RoutePaths.paymentSuccessfulScreen);
  //                     // context.back();
  //                   },
  //                   onError: (error) {
  //                     log("onError: $error");

  //                     // context.back();
  //                   },
  //                   onCancel: (params) {
  //                     log('cancelled: $params');

  //                     // context.back();
  //                   },
  //                 )
  //               : UsePaypal(
  //                   sandboxMode: gateway.sandbox,
  //                   secretKey: gateway.privateKey!,
  //                   clientId: gateway.publicKey!,
  //                   returnURL: gateway.notifyUrl!,
  //                   cancelURL: gateway.cancelUrl!,
  //                   transactions: paypalTransactions,
  //                   note: "Contact us for any questions on your donation.",
  //                   onSuccess: (Map params) async {
  //                     log("onSuccess: $params");
  //                     paymentPayload = params;
  //                     await sendReceiptToServer(context);
  //                     context.to(RoutePaths.paymentSuccessfulScreen);
  //                     // context.back();
  //                   },
  //                   onError: (error) {
  //                     log("onError: $error");

  //                     // context.back();
  //                   },
  //                   onCancel: (params) {
  //                     log('cancelled: $params');

  //                     // context.back();
  //                   },
  //                 ),
  //         ),
  //       ),
  //     );
  //   }
  // }

  sendReceiptToServer(BuildContext context) async {
    loading = true;

    log('Nonce: ${btRes?.paymentMethodNonce.nonce}');

    String purpose = (paymentDetail.value?.purpose?.trim() ?? '').isEmpty
        ? 'Not Specified'
        : paymentDetail.value!.purpose!.trim();

    Map<String, dynamic> data = {
      "payload": paymentPayload,
      "payment_method": method?.title?.toLowerCase(),
      "purpose": purpose,
      "amount": paymentDetail.value?.amounts?.userSubmittedAmount,
      "plan": paymentDetail.value?.gateway?.plan,
      "interval": interval?.replaceAll('ly', ''),
      "subscription_id": paymentDetail.value?.subscriptionId,
      
    };

    if (paymentType != PaymentType.deposit) {
      data["id"] = paymentDetail.value?.cause?.id;
    }

    Response res = await client.post(
      finalEndpoint,
      data: data,
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json'
        },
        extra: {'context': context},
      ),
    );

    if (res.isValid) {
       html.window.open('https://app.kiind.co.uk/callback?__route=payment_successful', '_self');
      // if (paymentType == PaymentType.deposit ||
      //     (paymentDetail.value?.cause is Post)) {
      //   context.off(
      //     RoutePaths.paymentSuccessfulScreen,
      //     args: {
      //       '__type': paymentType.index,
      //       '__paid_livestream': (paymentDetail.value?.cause is Post),
      //     },
      //     popCount: method?.id == 3 ? 3 : 2,
      //   );
      // } else {
      //   context.offAll(RoutePaths.paymentSuccessfulScreen);
      // }
    } else {
      context.back(
        times: method?.id == 3 ? 3 : 2,
      ); // you can also route to the payment failed page 😏
    }

    loading = false;
  }
}
