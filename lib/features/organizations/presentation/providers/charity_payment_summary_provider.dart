import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_paypal_payment/flutter_paypal_payment.dart';
import 'package:flutter_stripe_web/flutter_stripe_web.dart';
import 'package:kiind_web/core/constants/endpoints.dart';
import 'package:kiind_web/core/models/charity_donation_type_model.dart';
import 'package:kiind_web/core/models/gateway_model.dart';
import 'package:kiind_web/core/models/payment_detail.dart';
import 'package:kiind_web/core/models/payment_method.dart' as kiind_pay;
import 'package:kiind_web/core/models/post_model.dart';
import 'package:kiind_web/core/providers/base_provider.dart';
import 'package:kiind_web/core/router/route_paths.dart';
import 'package:kiind_web/core/util/extensions/buildcontext_extensions.dart';
import 'package:kiind_web/core/util/extensions/response_extensions.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:html' as html;
import 'dart:convert';

class CharityPaymentSummaryProvider extends BaseProvider {
  ValueNotifier<PaymentDetail?> paymentDetail = ValueNotifier(null);
  ValueNotifier<bool> processingPayment = ValueNotifier(false);

  String? interval = 'one_time';
  String? charityId;

  // Model property to hold user data
  User? model;

  // Donation type properties
  ValueNotifier<List<CharityDonationType>> donationTypes = ValueNotifier([]);
  ValueNotifier<CharityDonationType?> selectedDonationType = ValueNotifier(null);
  ValueNotifier<bool> loadingDonationTypes = ValueNotifier(false);

  bool get isSub => interval != 'one_time';

  String get initEndpoint => Endpoints.initiateCharityDonation;
  String get finalEndpoint => Endpoints.finalizeCharityDonation;

  // Payment method properties - now nullable to allow selection on page
  kiind_pay.PaymentMethod? method;
  List<kiind_pay.PaymentMethod> availablePaymentMethods = [];
  ValueNotifier<bool> isLoadingPaymentMethods = ValueNotifier(false);

  dynamic paymentPayload;
  List paypalTransactions = [];

  Future<void> fetchPaymentMethods() async {
    if (isLoadingPaymentMethods.value) return;

    isLoadingPaymentMethods.value = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      token = prefs.getString('token') ?? '';

      final response = await client.get(
        Endpoints.getPaymentMethods,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json'
          },
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final List methods = response.data['data'];
        availablePaymentMethods = methods
            .map((method) => kiind_pay.PaymentMethod.fromMap(method))
            .toList();
      }
    } on DioException catch (e) {
      print('Error fetching payment methods: ${e.message}');
      // Show error toast to user
      // showAlertToast('Failed to load payment methods. Please try again.');
    } finally {
      isLoadingPaymentMethods.value = false;
      notifyListeners();
    }
  }

  String _processInterval(String? interval) {
    if (interval == null) return 'one_time';

    String processed = interval.toLowerCase().trim();

    // Map different interval formats to API expected values
    switch (processed) {
      case 'one off':
      case 'one_off':
      case 'oneoff':
        return 'one_time';
      case 'monthly':
        return 'month';
      case 'yearly':
        return 'year';
      default:
        // For other cases, remove 'ly' suffix and return
        return processed.replaceAll('ly', '');
    }
  }

  @override
  Future init(
    BuildContext context, {
    String? dbKey,
    bool needsUser = true,
    bool shouldGetUser = false,
    Function(BuildContext)? callback,
    bool refresh = true,
  }) async {
    await super.init(
      context,
      callback: () async {
        // Load user profile first
        model = await getUserProfile();
        // Then fetch payment details
        await fetchPaymentDetails(context);
        // Call the additional callback if provided
        if (callback != null) {
          await callback(context);
        }
      },
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

  // Separate method to initialize payment with a specific method
  Future<void> initializePaymentWithMethod(BuildContext context, kiind_pay.PaymentMethod selectedMethod) async {
    final prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token') ?? '';

    Map<String, dynamic> _data = {
      "payment_method": selectedMethod.title?.toLowerCase(),
      "amount": paymentDetail.value?.amounts?.userSubmittedAmount,
      "interval": _processInterval(interval),
      "id": charityId,
    };

    // Add donation category ID if selected
    if (selectedDonationType.value?.id != null) {
      _data['donation_category_id'] = selectedDonationType.value!.id;
    }

    print("Charity payment details - Request data: $_data");
    print("Charity payment details - API endpoint: $initEndpoint");

    Response res = await client.post(
      initEndpoint,
      data: _data,
      options: Options(
        extra: {'context': context},
      ),
    );

    print("Charity payment details - API Response status: ${res.statusCode}");
    print("Charity payment details - API Response data: ${res.data}");
    print("Charity payment details - res.isValid: ${res.isValid}");
    print("Charity payment details - res.isSuccessful: ${res.isSuccessful}");
    print("Charity payment details - res.hasInfo: ${res.hasInfo}");
    print("Charity payment details - res.info: ${res.info}");

    if (res.isValid) {
      print("Charity donation initialized successfully");
      String? initialPurpose = paymentDetail.value?.purpose;

      PaymentDetail _detail = PaymentDetail.fromMap(Map<String, dynamic>.from(res.info!.data));

      paymentDetail.value = _detail.copyWith(purpose: initialPurpose);

      loading = false;
      notifyListeners();
      await initializeGateway(context, _detail.html ?? '');
    } else {
      print("Charity donation initialization failed: ${res.statusCode}");
      print("Response data: ${res.data}");
      print("Response error message: ${res.errorMessage}");

      // Try to show a more specific error message
      if (res.data != null && res.data is Map) {
        print("Detailed error info: ${res.data}");
      }

      loading = false;
      notifyListeners();
      Navigator.of(context).pop();
    }
  }

  fetchPaymentDetails(BuildContext context) async {
    try {
      print("Charity payment details - Starting fetch");

      // Check if context.args is available
      if (context.args == null) {
        print("ERROR: context.args is null!");
        loading = false;
        notifyListeners();
        Navigator.of(context).pop();
        return;
      }

      Map<String, dynamic> _paymentDetailMap = Map<String, dynamic>.from(context.args);
      print("Charity payment details - Args received: $_paymentDetailMap");
      print("Charity payment details - Args keys: ${_paymentDetailMap.keys.toList()}");

      // Validate required arguments
      if (_paymentDetailMap.isEmpty) {
        print("ERROR: Payment detail map is empty!");
        loading = false;
        notifyListeners();
        Navigator.of(context).pop();
        return;
      }

      // Try to create PaymentDetail from the map
      try {
        paymentDetail.value = PaymentDetail.fromMap(_paymentDetailMap);
        print("PaymentDetail created successfully: ${paymentDetail.value?.cause?.title}");
      } catch (e) {
        print("ERROR creating PaymentDetail: $e");
        loading = false;
        notifyListeners();
        Navigator.of(context).pop();
        return;
      }

      if (context.args['__interval'] != null) {
        interval = context.args['__interval'];
        print("Interval set to: $interval");
        print("Original interval value: ${context.args['__interval']}");

        // Process interval for API
        String processedInterval = interval?.replaceAll('ly', '') ?? 'one_time';
        print("Processed interval for API: $processedInterval");
      } else {
        interval = 'one_time';
        print("No interval provided, defaulting to: $interval");
      }

      // Use the charity's numeric ID from the payment detail instead of the slug from args
      if (paymentDetail.value?.cause?.id != null) {
        charityId = paymentDetail.value!.cause!.id.toString();
        print("Charity ID set to: $charityId (from payment detail cause.id)");
      } else if (context.args['__charity_id'] != null) {
        // Fallback to the arg if cause.id is not available
        charityId = context.args['__charity_id'];
        print("Charity ID set to: $charityId (from args as fallback)");
      }

      // Handle payment method using the reusable function
      await handlePaymentMethod(context.args);

      // Fetch available payment methods
      await fetchPaymentMethods();

      // Fetch donation types after payment details are loaded
      await fetchDonationTypes(context);

      // If we have a method selected, initialize the gateway
      if (method != null) {
        await initializePaymentWithMethod(context, method!);
      }
    } catch (e, stackTrace) {
      print("Error in charity payment details: $e");
      print("Stack trace: $stackTrace");
      loading = false;
      notifyListeners();
      Navigator.of(context).pop();
    }
  }

  // Method to be called when user selects a payment method from the dropdown
  Future<void> onPaymentMethodSelected(BuildContext context, kiind_pay.PaymentMethod selectedMethod) async {
    // Save the selected method to shared preferences
    final prefs = await SharedPreferences.getInstance();
    final paymentMethodJson = jsonEncode(selectedMethod.toMap());
    await prefs.setString('payment_method', paymentMethodJson);

    // Update the provider's method
    method = selectedMethod;

    // Initialize payment with the selected method
    await initializePaymentWithMethod(context, selectedMethod);
  }

  Future<void> fetchDonationTypes(BuildContext context) async {
    if (charityId == null) {
      print("Cannot fetch donation types: charityId is null");
      return;
    }

    loadingDonationTypes.value = true;
    notifyListeners();

    try {
      print("Fetching donation types for charity ID: $charityId");

      Response res = await client.get(
        Endpoints.getCharityDonationTypes,
        queryParameters: {
          'group_id': charityId,
        },
        options: Options(
          extra: {'context': context},
        ),
      );

      print("Donation types API Response status: ${res.statusCode}");
      print("Donation types API Response data: ${res.data}");

      if (res.isValid && res.data != null) {
        // Extract the actual list from the nested response structure
        dynamic responseData = res.data;
        List<dynamic> donationTypesList;

        // Check if the response has the nested structure with pagination
        if (responseData is Map && responseData.containsKey('data')) {
          // Handle the case where data contains pagination info with the actual list in data.data
          var innerData = responseData['data'];
          if (innerData is Map && innerData.containsKey('data')) {
            donationTypesList = innerData['data'] as List<dynamic>;
          } else if (innerData is List) {
            // If the inner data is directly a list
            donationTypesList = innerData as List<dynamic>;
          } else {
            donationTypesList = [];
          }
        } else if (responseData is List) {
          // Handle the case where response is directly a list
          donationTypesList = responseData as List<dynamic>;
        } else {
          donationTypesList = [];
        }

        if (donationTypesList is List) {
          List<CharityDonationType> types =
              CharityDonationType.listFromJson(donationTypesList);

          donationTypes.value = types;
          print("Successfully loaded ${types.length} donation types");
        } else {
          print("Unexpected response format for donation types");
          donationTypes.value = [];
        }
      } else {
        print("Failed to fetch donation types: ${res.statusCode}");
        print("Response data: ${res.data}");
        donationTypes.value = [];
      }
    } catch (e, stackTrace) {
      print("Error fetching donation types: $e");
      print("Stack trace: $stackTrace");
      donationTypes.value = [];
    } finally {
      loadingDonationTypes.value = false;
      notifyListeners();
    }
  }

  initializeGateway(BuildContext context, data) async {
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

      // await WebStripe.instance.applySettings();

      // await WebStripe.instance.initPaymentSheet(
      //   paymentSheetParameters: SetupPaymentSheetParameters(
      //     returnURL: _gateway.notifyUrl,
      //     merchantDisplayName: 'Kiind',
      //     customerId: null,
      //     paymentIntentClientSecret: _gateway.paymentIntent!,
      //     customerEphemeralKeySecret: _gateway.privateKey!,
      //     applePay: PaymentSheetApplePay(
      //       merchantCountryCode: 'GB',
      //     ),
      //     style: context.brightness == Brightness.dark
      //         ? ThemeMode.dark
      //         : ThemeMode.light,
      //   ),
      // );

      // await WebStripe.instance.applySettings();
    }
  }

  initPaypal(BuildContext context) {
    PaymentDetail? _detail = paymentDetail.value;

    paypalTransactions = [
      {
        "amount": {
          "total": '${_detail!.amounts?.userSubmittedAmount ?? 0}',
          "currency": "GBP",
          "details": {
            "subtotal": '${_detail.amounts?.userSubmittedAmount ?? 0}',
            "shipping": '0',
            "shipping_discount": 0
          }
        },
        "description": "Charity donation transaction.",
        "item_list": {
          "items": [
            {
              "name": "Charity Donation",
              "quantity": 1,
              "price": '${_detail.amounts?.userSubmittedAmount ?? 0}',
              "currency": "GBP"
            }
          ],
        }
      }
    ];
  }

  launchGateway(BuildContext context, {kiind_pay.PaymentMethod? selectedMethod}) async {
    final methodToUse = selectedMethod ?? method;
    print(methodToUse?.id);
    switch (methodToUse?.id) {
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

  void redirectToStripeCheckout(String url) {
    final stripeCheckoutUrl = url;
    html.window.open(stripeCheckoutUrl, '_self');
  }

  launchStripe(BuildContext context) async {
    Gateway? _gateway = paymentDetail.value?.gateway;
    processingPayment.value = true;
    if (_gateway != null) {
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

  Future launchPaypal(BuildContext context) async {
    processingPayment.value = true;
    print("starting paypal");
    await _launchPaypalModal(context);
    processingPayment.value = false;
  }

  Future launchMyPos(BuildContext context) async {
    processingPayment.value = true;
    print("starting mypos");
    processingPayment.value = false;
  }

  Future _launchPaypalModal(BuildContext context) async {
    Gateway? _gateway = paymentDetail.value?.gateway;
    if (_gateway != null && method?.id == 3) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (BuildContext context) => PaypalCheckoutView(
            sandboxMode: _gateway.sandbox,
            clientId: _gateway.publicKey!,
            secretKey: _gateway.privateKey!,
            transactions: paypalTransactions,
            note: "Contact us for any questions on your donation.",
            onSuccess: (Map params) async {
              log("onSuccess: $params");
              paymentPayload = params;
              await sendReceiptToServer(context);
              context.to(RoutePaths.paymentSuccessfulScreen);
            },
            onError: (error) {
              log("onError: $error");
            },
            onCancel: () {
              log('cancelled');
              Navigator.of(context).pop();
            },
          ),
        ),
      );
    }
  }

  sendReceiptToServer(BuildContext context, {kiind_pay.PaymentMethod? selectedMethod}) async {
    loading = true;

    String _purpose = (paymentDetail.value?.purpose?.trim() ?? '').isEmpty
        ? 'Charity Donation'
        : paymentDetail.value!.purpose!.trim();

    // Use the selected method if provided, otherwise use the stored method
    final methodToUse = selectedMethod ?? method;

    Map<String, dynamic> _data = {
      "payload": paymentPayload,
      "payment_method": methodToUse?.title?.toLowerCase(),
      "purpose": _purpose,
      "amount": paymentDetail.value?.amounts?.userSubmittedAmount,
      "plan": paymentDetail.value?.gateway?.plan,
      "interval": interval?.replaceAll('ly', ''),
      "subscription_id": paymentDetail.value?.subscriptionId,
      "id": charityId,
    };

    // Add donation category ID if selected
    if (selectedDonationType.value?.id != null) {
      _data['donation_category_id'] = selectedDonationType.value!.id;
    }

    Response res = await client.post(
      finalEndpoint,
      data: _data,
      options: Options(
        extra: {'context': context},
      ),
    );

    if (res.isValid) {
      html.window.open('https://app.kiind.co.uk/callback?__route=payment_successful', '_self');
    } else {
      context.back(
        times: methodToUse?.id == 3 ? 3 : 2,
      );
    }

    loading = false;
  }
}