// ignore_for_file: use_build_context_synchronously, avoid_print

import 'dart:math' as math;

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:kiind_web/core/constants/app_constants.dart';
import 'package:kiind_web/core/constants/endpoints.dart';
import 'package:kiind_web/core/models/charity_model.dart';
import 'package:kiind_web/core/models/donation_info_model.dart';

import 'package:kiind_web/core/providers/base_provider.dart';
import 'package:kiind_web/core/router/route_paths.dart';
import 'package:kiind_web/core/util/visual_alerts.dart';

class CharityAllocationPageProvider extends BaseProvider {
  double freeAllocation = 0;

  late List<Map<String, dynamic>> selectedCharities;
  late List<Color> colors;
  final math.Random _random = math.Random();

  CharityAllocationPageProvider({required List<Charity> charities}) {
    selectedCharities = charities.map((charity) {
      var charityMap = charity.toMap();
      charityMap['allocation'] = 100 / charities.length;
      return charityMap;
    }).toList();

    colors = List.generate(
        selectedCharities.length,
        (index) => categoriesColors.values
            .toList()[_random.nextInt(categoriesColors.values.length - 1)]
                ['color']!
            .withOpacity(1));
  }

  double getTotalAllocations() {
    double allocations = 0;
    for (var charity in selectedCharities) {
      allocations += charity['allocation'];
    }

    return allocations;
  }

  void changeFreeAllocation(double allocation) {
    freeAllocation = allocation;
    notifyListeners();
  }

  void updateAllocation(int index, double allocation) {
    final oldAllocation = selectedCharities[index]['allocation'];
    if (allocation > (oldAllocation + freeAllocation)) return;

    selectedCharities[index]['allocation'] = allocation;
    freeAllocation = 100 - getTotalAllocations();

    if (freeAllocation <= 1) {
      selectedCharities[index]['allocation'] = allocation + freeAllocation;
      freeAllocation = 0;
    }

    notifyListeners();
  }

  void removeCharity(int index) {
    final allocation = selectedCharities[index]['allocation'];
    selectedCharities.removeAt(index);
    if (selectedCharities.length == 1) {
      freeAllocation = 0;
      selectedCharities[0]['allocation'] = 100.0;
    } else {
      freeAllocation += allocation;
    }

    notifyListeners();
  }

  void syncSelection(BuildContext context, DonationInfoModel? donationInfo,
      int? subscriptionId,
      {bool goToPayment = false, bool fromBanner = false}) async {
    if (loading) return;
    loading = true;

    final selections = {
      'charities': selectedCharities
          .map((charity) => {
                'charity_id': charity['id'],
                'category_id': charity['category_id'],
                'percentage':
                    (charity['allocation'] as double).toStringAsFixed(2)
              })
          .toList()
    };

    try {
      final result =
          await client.post(Endpoints.portfolioSync, data: selections);

      if (result.statusCode == 200 || result.statusCode == 201) {
        if (donationInfo == null) {
          if (subscriptionId != null) {
            await cancelSubscription(context, subscriptionId);
          }

          int count = 0;
          Navigator.popUntil(context, (route) => count++ == 2);
          if (fromBanner) {
            Navigator.of(context).pushNamed(RoutePaths.kiindPortfolioScreen);
          }
          return;
        }

        if (goToPayment) {
          Navigator.of(context).pushNamed(
              RoutePaths.philanthropyPaymentMethodSscreen,
              arguments: donationInfo);
        }
      } else {
        print(result.statusCode);
        print(result.data);
      }
    } on DioError {
      showAlertToast('An error occurred. Please try again');
    }

    loading = false;
  }

  Future<void> cancelSubscription(BuildContext context, int id) async {
    if (loading) return;
    loading = true;

    try {
      final response = await client
          .post(Endpoints.cancelKiindSubscription, data: {'id': id});

      loading = false;

      if (response.statusCode == 200 || response.statusCode == 201) {
        showAlertToast('Subscription cancelled successfully');
        Navigator.of(context)
            .pushReplacementNamed(RoutePaths.kiindPortfolioScreen);
      }
    } on DioError {
      showAlertToast('An error occurred. Please try again.');
      loading = false;
    }
  }
}
