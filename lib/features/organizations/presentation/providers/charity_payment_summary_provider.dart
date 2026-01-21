import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_paypal_payment/flutter_paypal_payment.dart';
import 'package:flutter_stripe_web/flutter_stripe_web.dart';
import 'package:kiind_web/core/constants/endpoints.dart';
import 'package:kiind_web/core/models/charity_donation_type_model.dart';
import 'package:kiind_web/core/models/charity_model.dart';
import 'package:kiind_web/core/models/gateway_model.dart';
import 'package:kiind_web/core/models/payment_detail.dart';
import 'package:kiind_web/core/models/payment_method.dart' as kiind_pay;
import 'package:kiind_web/core/models/post_model.dart';
import 'package:kiind_web/core/models/user_model.dart';
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
  ValueNotifier<CharityDonationType?> selectedDonationType =
      ValueNotifier(null);
  ValueNotifier<bool> loadingDonationTypes = ValueNotifier(false);

  bool get isSub => interval != 'one_time';

  String get initEndpoint => Endpoints.initiateCharityDonation;
  String get finalEndpoint => Endpoints.finalizeCharityDonation;

  // Payment method properties
  ValueNotifier<Map<int, kiind_pay.PaymentMethod>> paymentMethods =
      ValueNotifier({});
  kiind_pay.PaymentMethod? selectedPaymentMethod;

  kiind_pay.PaymentMethod? method; // Will be set from selectedPaymentMethod

  dynamic paymentPayload;
  List paypalTransactions = [];

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

  String _processInterval(String? interval) {
    if (interval == null) return 'one_time';

    String processed = interval.toLowerCase().trim();

    // Map different interval formats to API expected values
    switch (processed) {
      case 'one off':
      case 'one_off':
      case 'oneoff':
      case 'one time':
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
  }) {
    return super.init(
      context,
      callback: fetchPaymentDetails,
    );
  }


  // Separate method to initialize payment with a specific method
  Future<void> initializePaymentWithMethod(
      BuildContext context, kiind_pay.PaymentMethod selectedMethod) async {
    final prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token') ?? '';

    // Ensure the amount is properly set from the payment detail or context args
    final amount = paymentDetail.value?.amounts?.userSubmittedAmount ??
                  (context.args['amount'] != null ? double.tryParse(context.args['amount'].toString()) : 0.0);

    Map<String, dynamic> _data = {
      "payment_method": selectedMethod.title?.toLowerCase(),
      "amount": amount,
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

      PaymentDetail _detail =
          PaymentDetail.fromMap(Map<String, dynamic>.from(res.info!.data));

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

      Map<String, dynamic> _paymentDetailMap =
          Map<String, dynamic>.from(context.args);
      print("Charity payment details - Args received: $_paymentDetailMap");
      print(
          "Charity payment details - Args keys: ${_paymentDetailMap.keys.toList()}");

      // Check if token is provided in the arguments and save it to shared preferences
      final tokenFromArgs = _paymentDetailMap['token'] as String?;
      if (tokenFromArgs != null && tokenFromArgs.isNotEmpty) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', tokenFromArgs);
        // Update the token in the provider
        token = tokenFromArgs;
        print("Token saved to shared preferences and provider: $tokenFromArgs");

        // Refresh the client to pick up the new token
        client.refresh();
      }

      // Check if this is coming from the charity donation modal (has amount, interval, etc.)
      if (_paymentDetailMap.containsKey('amount')) {
        // This is coming from the charity donation modal
        // Create a temporary payment detail with the amount
        final amount =
            double.tryParse(_paymentDetailMap['amount'].toString()) ?? 0.0;
        final intervalParam =
            _paymentDetailMap['interval']?.toString() ?? 'one_time';
        final charityIdParam = _paymentDetailMap['charityId']?.toString();

        // Update the interval and charityId
        interval = intervalParam;
        charityId = charityIdParam;

        print(
            "Received from charity modal - Amount: $amount, Interval: $interval, Charity ID: $charityId");

        // Fetch charity details to populate payment detail
        await fetchCharityDetailsForPayment(context, amount);
      } else {
        // Original flow - coming from other sources
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
          print(
              "PaymentDetail created successfully: ${paymentDetail.value?.cause?.title}");
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
          String processedInterval =
              interval?.replaceAll('ly', '') ?? 'one_time';
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
      }

      // Fetch payment methods first
      await fetchPaymentMethods(context);

      // Fetch donation types after payment details are loaded
      await fetchDonationTypes(context);

      // Set the first payment method as selected if none is selected yet
      if (paymentMethods.value.isNotEmpty && selectedPaymentMethod == null) {
        selectedPaymentMethod = paymentMethods.value.values.first;
        method =
            selectedPaymentMethod; // Set the method for backward compatibility
      }

      // Don't initialize payment automatically - wait for user to click Pay Now
      loading = false;
      notifyListeners();
    } catch (e, stackTrace) {
      print("Error in charity payment details: $e");
      print("Stack trace: $stackTrace");
      loading = false;
      notifyListeners();
      Navigator.of(context).pop();
    }
  }

  // Helper method to fetch charity details and create payment detail
  Future<void> fetchCharityDetailsForPayment(
      BuildContext context, double amount) async {
    if (charityId == null) {
      print("ERROR: Charity ID is null when fetching details for payment");
      return;
    }

    try {
      // Fetch charity details
      final response = await client.get('/v2/groups/$charityId');

      if (response.statusCode == 200) {
        // Create a minimal payment detail with the amount and charity info
        final charityData = response.data['data'];

        // Create a Charity object from the data
        final charity = Charity.fromMap(charityData);

        // Create a temporary PaymentDetail object
        paymentDetail.value = PaymentDetail(
          amounts: Amounts(userSubmittedAmount: amount),
          // Use the Charity object as the cause
          cause: charity,
        );

        print(
            "Created payment detail for charity: ${charity.title} with amount: $amount");
      } else {
        // If the API call fails, still create a payment detail with just the amount
        // This allows the flow to continue even if charity details can't be fetched
        paymentDetail.value = PaymentDetail(
          amounts: Amounts(userSubmittedAmount: amount),
          // Use a placeholder charity with the ID
          cause: Charity(
            id: int.tryParse(charityId!) ?? 0,
            title: 'Charity ID: $charityId',
            slug: 'charity_$charityId',
            categoryId: 0,
            categoryTitle: 'Charity',
          ),
        );

        print("Created payment detail with placeholder charity due to API error: ${response.statusCode}");
      }
    } catch (e) {
      // If there's an exception, create a payment detail with a placeholder charity
      print("Error fetching charity details for payment: $e");
      paymentDetail.value = PaymentDetail(
        amounts: Amounts(userSubmittedAmount: amount),
        // Use a placeholder charity with the ID
        cause: Charity(
          id: int.tryParse(charityId!) ?? 0,
          title: 'Charity ID: $charityId',
          slug: 'charity_$charityId',
          categoryId: 0,
          categoryTitle: 'Charity',
        ),
      );
    }
  }

  // Call this method when payment method selection changes
  void onPaymentMethodSelected(BuildContext context) {
    // Update the selected method and re-initialize payment to update service charges
    if (selectedPaymentMethod != null) {
      method =
          selectedPaymentMethod; // Update the method reference for backward compatibility

      // Re-initialize payment to update service charges displayed on the page
      initializePaymentForSelectedMethod(context);
    }
  }

  // Re-initialize payment with the currently selected method
  Future<void> initializePaymentForSelectedMethod(BuildContext context) async {
    if (selectedPaymentMethod == null) return;

    // Update the method reference for backward compatibility
    method = selectedPaymentMethod;

    Map<String, dynamic> _data = {
      "payment_method": selectedPaymentMethod?.title?.toLowerCase(),
      "amount": paymentDetail.value?.amounts?.userSubmittedAmount,
      "interval": _processInterval(interval),
      "id": charityId,
    };

    // Add donation category ID if selected
    if (selectedDonationType.value?.id != null) {
      _data['donation_category_id'] = selectedDonationType.value!.id;
    }

    try {
      Response res = await client.post(
        initEndpoint,
        data: _data,
        options: Options(
          extra: {'context': context},
        ),
      );

      if (res.isValid) {
        print("Payment re-initialized successfully with new method");
        String? initialPurpose = paymentDetail.value?.purpose;

        PaymentDetail _detail =
            PaymentDetail.fromMap(Map<String, dynamic>.from(res.info!.data));

        paymentDetail.value = _detail.copyWith(purpose: initialPurpose);

        loading = false;
        notifyListeners();
        await initializeGateway(context, _detail.html ?? '');
      } else {
        print("Payment re-initialization failed: ${res.statusCode}");
        print("Response data: ${res.data}");
      }
    } catch (e, stackTrace) {
      print("Error re-initializing payment: $e");
      print("Stack trace: $stackTrace");
    }
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
        Endpoints.getCharityDonationType,
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

  launchGateway(BuildContext context,
      {kiind_pay.PaymentMethod? selectedMethod}) async {
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

  sendReceiptToServer(BuildContext context,
      {kiind_pay.PaymentMethod? selectedMethod}) async {
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
      html.window.open(
          'https://app.kiind.co.uk/callback?__route=payment_successful',
          '_self');
    } else {
      context.back(
        times: methodToUse?.id == 3 ? 3 : 2,
      );
    }

    loading = false;
  }
}
