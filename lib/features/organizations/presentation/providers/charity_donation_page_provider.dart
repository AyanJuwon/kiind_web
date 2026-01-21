import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:kiind_web/core/models/charity_model.dart';
import 'package:kiind_web/core/models/payment_detail.dart';
import 'package:kiind_web/core/providers/base_provider.dart';
import 'package:kiind_web/core/router/route_paths.dart';
import 'package:kiind_web/core/util/extensions/buildcontext_extensions.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CharityDonationPageProvider extends BaseProvider {
  Charity? charity;
  final TextEditingController amountController = TextEditingController();
  String? charityId;
  String? token;

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
      callback: fetchCharityDetails,
    );
  }

  Future<void> fetchCharityDetails(BuildContext context) async {
    loading = true;
    notifyListeners();

    try {
      // Get charity ID from route arguments
      final args = context.args as Map<String, dynamic>?;

      if (args != null) {
        charityId = args['charityId'] as String?;
        token = args['token'] as String?;

        // If token is not provided in args, try to get from shared preferences
        if (token == null) {
          final prefs = await SharedPreferences.getInstance();
          token = prefs.getString('token');
        }
      }

      if (charityId == null) {
        throw Exception('Charity ID is required');
      }

      // Fetch charity details
      final response = await client.get('/v2/groups/$charityId');

      if (response.statusCode == 200) {
        charity = Charity.fromMap(response.data['data']);
      } else {
        throw Exception('Failed to fetch charity details');
      }
    } catch (e) {
      print('Error fetching charity details: $e');
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  void validateAndProceed(BuildContext context) {
    final amount = double.tryParse(amountController.text);

    if (amount == null || amount <= 0) {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid donation amount')),
      );
      return;
    }

    // Create payment detail for charity donation
    final paymentDetail = PaymentDetail(
      cause: charity,
      amounts: Amounts(
        userSubmittedAmount: amount,
      ),
    );

    // Navigate to payment method selection page (following the correct flow)
    final arguments = {
      ...paymentDetail.toMap(),
      '__interval': 'one_time', // Default to one-time donation
      '__charity_id': charityId,
      '__type': 0, // PaymentType.oneTime
    };

    // Navigate to payment method screen
    context.to(
      RoutePaths.paymentMethodScreen,
      args: arguments,
    );
  }

  @override
  void dispose() {
    amountController.dispose();
    super.dispose();
  }
}