// ignore_for_file: avoid_web_libraries_in_flutter

import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_braintree/flutter_braintree.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
// import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:flutter_stripe_web/flutter_stripe_web.dart';
import 'package:kiind_web/core/constants/endpoints.dart';
import 'package:kiind_web/core/models/campaign_model.dart';
import 'package:kiind_web/core/models/donation_type_model.dart';
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

  // Donation type properties
  List<DonationType> donationTypes = [];
  DonationType? selectedDonationType;
  bool isLoadingDonationTypes = false;

  bool get isSub => interval != 'one_time';


final cancelUrl = Uri.encodeFull('https://app.kiind.co.uk/callback?__route=payment_cancelled');

  @override
  String? token;
  String getInitEndpoint(BuildContext? context) {
    String endpoint = '';

    // Check if this is a charity donation
    bool isCharityDonation = context?.args.containsKey('__charity_id') ?? false;

    if (paymentDetail.value?.purpose == null) {
      if (isCharityDonation) {
        // For charity donations, use charity-specific endpoints
        endpoint = Endpoints.initiateCharityDonation;
      } else {
        // For regular donations, use existing logic
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
      }
    } else {
      endpoint = Endpoints.initiateEcarePay;
    }

    return endpoint;
  }

  String getFinalEndpoint(BuildContext? context) {
    String endpoint = '';

    // Check if this is a charity donation
    bool isCharityDonation = context?.args.containsKey('__charity_id') ?? false;

    if (paymentDetail.value?.purpose == null) {
      if (isCharityDonation) {
        // For charity donations, use charity-specific endpoints
        endpoint = Endpoints.finalizeCharityDonation;
      } else {
        // For regular donations, use existing logic
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
      }
    } else {
      endpoint = Endpoints.finalizeEcarePay;
    }

    return endpoint;
  }

  // Payment method properties
  ValueNotifier<Map<int, kiind_pay.PaymentMethod>> paymentMethods =
      ValueNotifier({});
  kiind_pay.PaymentMethod? selectedPaymentMethod;

  kiind_pay.PaymentMethod? method; // Will be set from selectedPaymentMethod

  late BraintreeDropInRequest btReq;
  BraintreeDropInResult? btRes;

  dynamic paymentPayload;
  User? user;
  List paypalTransactions = [];

  Future<void> fetchDonationTypes(int groupId) async {
    if (isLoadingDonationTypes) return;

    isLoadingDonationTypes = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      token = prefs.getString('token') ?? '';

      final response = await client.get(
        '${Endpoints.getCharityDonationTypes}?group_id=$groupId',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json'
          },
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final donationTypeResponse = DonationTypeResponse.fromMap(response.data);
        donationTypes = donationTypeResponse.donationTypes;

        // Reset selection if previously selected type is no longer available
        if (selectedDonationType != null &&
            !donationTypes.any((type) => type.id == selectedDonationType!.id)) {
          selectedDonationType = null;
        }
      }
    } on DioException catch (e) {
      print('Error fetching donation types: ${e.message}');
      // Show error toast to user
      showAlertToast('Failed to load donation types. Please try again.');
    } finally {
      isLoadingDonationTypes = false;
      notifyListeners();
    }
  }

  Future<void> fetchPaymentMethods(BuildContext context) async {
    // Check if user is guest
    bool isGuest = false;
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      isGuest = (token == null || token.isEmpty);
    } catch (e) {
      print("Error checking if user is guest: $e");
      isGuest = true; // Default to guest if there's an error
    }

    if (isGuest) {
      print("User is guest, skipping payment methods API call");
      // Add default payment methods for guest users
      paymentMethods.value = {
        8: kiind_pay.PaymentMethod(id: 8, title: 'Stripe'),
        10000: kiind_pay.PaymentMethod(id: 10000, title: 'Wallet'),
      };
      notifyListeners();
      return;
    }

    try {
      print("Fetching payment methods from: ${Endpoints.getPaymentMethods}");

      Response res = await client.get(
        Endpoints.getPaymentMethods,
        options: Options(
          extra: {'context': context},
        ),
      );

      print("Payment methods API Response status: ${res.statusCode}");
      print("Payment methods API Response data: ${res.data}");
      print("res.isValid: ${res.isValid}");
      print("res.hasInfo: ${res.hasInfo}");

      if (res.isValid) {
        Map<String, dynamic> detailMap =
            Map<String, dynamic>.from(context.args);
        print("Payment methods detailMap: $detailMap");

        try {
          PaymentDetail _detail = PaymentDetail.fromMap(detailMap);
          print("PaymentDetail created successfully for payment methods");

          // Determine if this is an "other" type donation
          bool _other = false;
          if (_detail.cause != null) {
            try {
              _other = _detail.cause?.isOther ?? false;
              print("_other from cause.isOther: $_other");
            } catch (e) {
              _other = false;
              print("_other defaulted to false: $_other");
            }
          }

          // Process payment methods from API response
          dynamic paymentMethodsData = res.info?.data;
          if (paymentMethodsData == null &&
              res.data is Map &&
              res.data.containsKey('data')) {
            paymentMethodsData = res.data['data'];
            print("Using fallback data access: $paymentMethodsData");
          }

          Map<int, kiind_pay.PaymentMethod> methods = {};

          if (paymentMethodsData is List) {
            for (var v in paymentMethodsData) {
              print("Processing payment method: $v");
              // Exclude method ID 7 (MyPos) for all donations
              if (v['id'] != 7) {
                kiind_pay.PaymentMethod method =
                    kiind_pay.PaymentMethod.fromMap(v);
                methods[v['id']] = method;
                print("Added method: ${method.title} (ID: ${method.id})");
              } else {
                print("Skipped method with ID: ${v['id']}");
              }
            }
          } else {
            print(
                "ERROR: paymentMethodsData is not a List: $paymentMethodsData");
          }

          // Add wallet method for non-"other" donations
          if (!_other) {
            kiind_pay.PaymentMethod walletMethod = kiind_pay.PaymentMethod(
              id: 10000,
              title: 'Wallet',
            );
            methods[10000] = walletMethod;
            print("Added wallet method");
          }

          paymentMethods.value = methods;
          print("Final paymentMethods count: ${methods.length}");
        } catch (e, stackTrace) {
          print("Error creating PaymentDetail for payment methods: $e");
          print("Error stackTrace: $stackTrace");

          // Even if PaymentDetail creation fails, try to add default payment methods
          paymentMethods.value = {
            8: kiind_pay.PaymentMethod(id: 8, title: 'Stripe'),
            10000: kiind_pay.PaymentMethod(id: 10000, title: 'Wallet'),
          };
        }
      } else {
        print("API response not valid for payment methods");
        // Add default payment methods if API fails
        paymentMethods.value = {
          8: kiind_pay.PaymentMethod(id: 8, title: 'Stripe'),
          10000: kiind_pay.PaymentMethod(id: 10000, title: 'Wallet'),
        };
      }
    } catch (e, stackTrace) {
      print("Error in fetchPaymentMethods: $e");
      print("StackTrace: $stackTrace");
      debugPrint('Error fetching payment methods: $e');

      // Add default payment methods in case of error
      paymentMethods.value = {
        8: kiind_pay.PaymentMethod(id: 8, title: 'Stripe'),
        10000: kiind_pay.PaymentMethod(id: 10000, title: 'Wallet'),
      };
    }

    notifyListeners();
  }

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
        // Don't throw exception anymore - we'll allow selection on page
        print("No payment method found in SharedPreferences or context.args['__method'], allowing selection on page");
      }
    }

    // Log the current payment method
    print('Current Payment Method: ${method?.toString() ?? "None selected"}');
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

      // Check if this is a charity donation
      bool isCharityDonation = context.args.containsKey('__charity_id');

      // Fetch payment methods first
      await fetchPaymentMethods(context);

      // Fetch donation types for charity donations
      if (isCharityDonation) {
        // For charity donations, use charity ID from context
        await fetchDonationTypes(context.args['__charity_id']);
      }

      // Set the first payment method as selected if none is selected yet
      if (paymentMethods.value.isNotEmpty && selectedPaymentMethod == null) {
        selectedPaymentMethod = paymentMethods.value.values.first;
        method = selectedPaymentMethod; // Set the method for backward compatibility

        // Automatically initialize payment details for the first selected method
        await initializePaymentForSelectedMethod(context);
      } else {
        // Don't initialize payment automatically - wait for user to click Pay Now
        loading = false;
        notifyListeners();
      }
    } on DioException catch (e) {
      // Handle Dio errors with user-friendly messages
      String errorMessage = 'An error occurred during payment initialization.';

      if (e.response != null) {
        print('Error from payment initialization: ${e.response?.data}');

        // Check for specific error conditions
        if (e.response?.statusCode == 500) {
          errorMessage = 'Server error occurred. Please try again later.';
        } else if (e.response?.statusCode == 400) {
          errorMessage = 'Invalid payment details. Please check and try again.';
        } else if (e.response?.statusCode == 401) {
          errorMessage = 'Unauthorized access. Please log in again.';
        } else if (e.response?.data is Map && e.response?.data['message'] != null) {
          errorMessage = e.response?.data['message'].toString() ?? errorMessage;
        }
      } else if (e.type == DioExceptionType.connectionError || e.type == DioExceptionType.connectionTimeout) {
        errorMessage = 'Connection error. Please check your internet connection.';
      } else {
        print('Error from payment initialization: ${e.message}');
      }

      _showErrorDialog(context, errorMessage);
    } on Exception catch (e) {
      // Handle any other exceptions
      print('Unexpected error during payment initialization: $e');
      _showErrorDialog(context, 'An unexpected error occurred. Please try again later.');
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  // Separate method to initialize payment with a specific method
  Future<void> initializePaymentWithMethod(BuildContext context, kiind_pay.PaymentMethod selectedMethod) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token == null) {
      throw Exception('Token not found');
    }

    // Check if this is a charity donation
    bool isCharityDonation = context.args.containsKey('__charity_id');

    Map<String, dynamic> data = {
      "payment_method": selectedMethod.title?.toLowerCase(),
      "amount": paymentDetail.value?.amounts?.userSubmittedAmount,
      "interval": interval?.toLowerCase() =='one_time'? "single": interval?.replaceAll('ly', ''),
      "device": 'ios',
    };

    if (isCharityDonation) {
      // For charity donations, use charity ID from context
      data["charity_id"] = context.args['__charity_id'];

      // Add donation category ID if selected
      if (selectedDonationType != null) {
        data["donation_category_id"] = selectedDonationType!.id;
      }
    } else {
      // For regular donations, use existing logic
      if (paymentDetail.value!.cause is Campaign) {
        data["id"] = (paymentDetail.value!.cause as Campaign).id;
      } else if (paymentType != PaymentType.deposit) {
        data["id"] = paymentDetail.value?.cause?.id;
      }
    }

    // Initialize Dio
    final dio = Dio(
      BaseOptions(
        baseUrl: 'https://app.kiind.co.uk/api/v2',
        headers: {'Accept': 'application/json'},
      ),
    );

    // API call to initiate payment
    print("init endpoint is ::: ${getInitEndpoint(context)}");
    print("init endpoint is ::: ${data}");
    final response = await dio.post(
      getInitEndpoint(context),
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
      // Show error dialog instead of silent navigation
      _showErrorDialog(context, 'Payment initialization failed. Please try again later.');
      print("Payment initialization failed with status: ${response.statusCode}");
    }
  }

  // Call this method when payment method selection changes
  void onPaymentMethodSelected(BuildContext context) {
    // Update the selected method and re-initialize payment to update service charges
    if (selectedPaymentMethod != null) {
      method = selectedPaymentMethod; // Update the method reference for backward compatibility

      // Re-initialize payment to update service charges displayed on the page
      initializePaymentForSelectedMethod(context);
    }
  }

  // Re-initialize payment with the currently selected method
  Future<void> initializePaymentForSelectedMethod(BuildContext context) async {
    if (selectedPaymentMethod == null) return;

    // Update the method reference for backward compatibility
    method = selectedPaymentMethod;

    // Check if this is a charity donation
    bool isCharityDonation = context.args.containsKey('__charity_id');

    Map<String, dynamic> data = {
      "payment_method": selectedPaymentMethod?.title?.toLowerCase(),
      "amount": paymentDetail.value?.amounts?.userSubmittedAmount,
      "interval": interval?.toLowerCase() =='one_time'? "single": interval?.replaceAll('ly', ''),
      "device": 'ios',
    };

    if (isCharityDonation) {
      // For charity donations, use charity ID from context
      data["charity_id"] = context.args['__charity_id'];

      // Add donation category ID if selected
      if (selectedDonationType != null) {
        data["donation_category_id"] = selectedDonationType!.id;
      }
    } else {
      // For regular donations, use existing logic
      if (paymentDetail.value!.cause is Campaign) {
        data["id"] = (paymentDetail.value!.cause as Campaign).id;
      } else if (paymentType != PaymentType.deposit) {
        data["id"] = paymentDetail.value?.cause?.id;
      }
    }

    // Initialize Dio
    final dio = Dio(
      BaseOptions(
        baseUrl: 'https://app.kiind.co.uk/api/v2',
        headers: {'Accept': 'application/json'},
      ),
    );

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token == null) {
      throw Exception('Token not found');
    }

    // API call to initiate payment
    print("init endpoint is ::: ${getInitEndpoint(context)}");
    print("init endpoint is ::: $data");
    final response = await dio.post(
      getInitEndpoint(context),
      data: data,
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
        },
        extra: {'context': context},
      ),
    );

    if (response.statusCode == 200 && response.data != null) {
      print("data to from response initiate::::: $response");
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
      // Show error dialog instead of silent navigation
      _showErrorDialog(context, 'Payment initialization failed. Please try again later.');
      print("Payment initialization failed with status: ${response.statusCode}");
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
    // Use the selected payment method
    kiind_pay.PaymentMethod? currentMethod = selectedPaymentMethod ?? method;
    print(currentMethod?.id);

    try {
      // If payment hasn't been initialized yet, initialize it
      if (paymentDetail.value?.gateway == null) {
        // Show loading indicator
        loading = true;
        notifyListeners();

        await initializePaymentForSelectedMethod(context);
      }

      switch (currentMethod?.id) {
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
    } catch (e) {
      print("Error during payment processing: $e");
      // Stop loading indicator
      loading = false;
      notifyListeners();

      // Show error dialog to user
      if (context.mounted) {
        showDialog(
          context: context,
          builder: (BuildContext dialogContext) {
            return AlertDialog(
              title: const Text('Payment Error'),
              content: Text(
                  'An error occurred during payment processing. Please try again.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(dialogContext).pop(); // Close dialog
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      }
    }
  }

void redirectToStripeCheckout(String url,) {
  final stripeCheckoutUrl = url;
  html.window.open(stripeCheckoutUrl, '_self');
}

String methodLogo(kiind_pay.PaymentMethod method) {
  String logo = '';

  switch (method.id) {
    case 3:
      logo = 'https://cdn-icons-png.flaticon.com/512/174/174861.png';
      break;
    case 8:
      logo = 'https://cdn-icons-png.flaticon.com/512/1198/1198299.png';
      break;
    case 10000:
    default:
      logo = 'https://img.icons8.com/color/452/wallet--v1.png';
      break;
  }

  return logo;
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
                    showAlertToast("Payment Cancelled");
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

  sendReceiptToServer(BuildContext context, {kiind_pay.PaymentMethod? selectedMethod}) async {
    loading = true;

    log('Nonce: ${btRes?.paymentMethodNonce.nonce}');

    String purpose = (paymentDetail.value?.purpose?.trim() ?? '').isEmpty
        ? 'Not Specified'
        : paymentDetail.value!.purpose!.trim();

    // Use the selected method if provided, otherwise use the stored method
    final methodToUse = selectedMethod ?? method;

    // Check if this is a charity donation
    bool isCharityDonation = context.args.containsKey('__charity_id');

    Map<String, dynamic> data = {
      "payload": paymentPayload,
      "payment_method": methodToUse?.title?.toLowerCase(),
      "purpose": purpose,
      "amount": paymentDetail.value?.amounts?.userSubmittedAmount,
      "plan": paymentDetail.value?.gateway?.plan,
      "interval": interval?.replaceAll('ly', ''),
      "subscription_id": paymentDetail.value?.subscriptionId,
    };

    if (isCharityDonation) {
      // For charity donations, use charity ID
      data["charity_id"] = context.args['__charity_id'];

      // Add donation category ID if selected
      if (selectedDonationType != null) {
        data["donation_category_id"] = selectedDonationType!.id;
      }
    } else if (paymentType != PaymentType.deposit) {
      // For regular donations, use existing logic
      data["id"] = paymentDetail.value?.cause?.id;
    }

    try {
      Response res = await client.post(
        getFinalEndpoint(context),
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
        // Show error dialog instead of silent navigation
        _showErrorDialog(context, 'Payment finalization failed. Please try again later.');
      }
    } on DioException catch (e) {
      // Handle Dio errors during finalization
      String errorMessage = 'An error occurred during payment finalization.';

      if (e.response != null) {
        print('Error from payment finalization: ${e.response?.data}');

        // Check for specific error conditions
        if (e.response?.statusCode == 500) {
          errorMessage = 'Server error occurred during payment finalization. Please try again later.';
        } else if (e.response?.statusCode == 400) {
          errorMessage = 'Invalid payment details. Please check and try again.';
        } else if (e.response?.statusCode == 401) {
          errorMessage = 'Unauthorized access. Please log in again.';
        } else if (e.response?.data is Map && e.response?.data['message'] != null) {
          errorMessage = e.response?.data['message'].toString() ?? errorMessage;
        }
      } else if (e.type == DioExceptionType.connectionError || e.type == DioExceptionType.connectionTimeout) {
        errorMessage = 'Connection error. Please check your internet connection.';
      } else {
        print('Error from payment finalization: ${e.message}');
      }

      _showErrorDialog(context, errorMessage);
    } on Exception catch (e) {
      // Handle any other exceptions during finalization
      print('Unexpected error during payment finalization: $e');
      _showErrorDialog(context, 'An unexpected error occurred during payment finalization. Please try again later.');
    } finally {
      loading = false;
    }
  }
}
