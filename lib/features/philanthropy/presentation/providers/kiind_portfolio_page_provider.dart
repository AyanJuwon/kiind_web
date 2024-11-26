import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:kiind_web/core/constants/app_constants.dart';
import 'package:kiind_web/core/constants/endpoints.dart';
import 'package:kiind_web/core/models/subscription_model.dart';
import 'package:kiind_web/core/providers/base_provider.dart';
import 'package:kiind_web/core/router/route_paths.dart';
import 'package:kiind_web/core/util/visual_alerts.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class KiindPortfolioPageProvider extends BaseProvider {
  List<Map>? categories;
  Map<int, List<Map>> charities = {};
  int donationCount = 0;
  String donationAmount = '0';
  bool error = false;
  SubscriptionModel? subscriptionDetails;
  final Random _random = Random();
  List<Color>? colors;
  bool hasError = false;

  void getPortfolio() async {
    if (loading) return;
    subscriptionDetails = null;
    categories = null;
    charities = {};
    loading = true;

    try {
      final response = await client.get(Endpoints.philanthropyPortfolio);
      if (response.statusCode == 200) {
        if (response.data['data']['subscription'] != null) {
          subscriptionDetails =
              SubscriptionModel.fromMap(response.data['data']['subscription']);
        }
        donationCount = response.data['data']['donation_count'];
        donationAmount = response.data['data']['donation_amount'];
        final List categoriesData = response.data['data']['categories'] ?? [];
        categories = List.generate(categoriesData.length, (index) {
          final item = categoriesData[index];
          charities[item['id']] =
              List<Map<dynamic, dynamic>>.from(item['charities']);

          return item;
        });
      } else {
        hasError = true;
      }
    } on DioException catch (e) {
      hasError = true;
      if (e.response!.statusCode == 404) {
        loading = false;
        notifyListeners();
      }
    }

    loading = false;
  }

  Map<String, double> getDataMap() {
    final Map<String, double> dataMap = {};
    for (var category in categories!) {
      final String key = "${category['category']}_${category['id']}";
      final temp = category['percentage'];
      late final double value;
      if (temp is int) {
        value = temp.toDouble();
      } else {
        value = temp;
      }

      dataMap[key] = value;
    }

    print("categories color ::: $dataMap");
    return dataMap;
  }

  List<Color> getColors() {
    print("categories color ::: ${this.categories}");
    final List<String> categories = getDataMap().keys.toList();
    print("categories color ::: ${this.categories!.length}");
    final colors =
        categories.map((category) => categoriesColors[category]).toList();

    this.colors = colors.map((color) {
      if (color == null) {
        return categoriesColors.values
            .toList()[_random.nextInt(categoriesColors.values.length - 1)]
                ['color']!
            .withOpacity(1);
      }
      return color['color']!;
    }).toList();

    return this.colors!;
  }

  List<Map> parseSyncedCharities() {
    final List<Map> result = [];
    for (var category in categories!) {
      for (var charity in (category['charities'] as List)) {
        result.add({'id': charity['id'], 'categoryId': category['id']});
      }
    }

    return result;
  }

  String getFormattedInterval(String interval) {
    switch (interval) {
      case 'month':
        return 'monthly';
      case 'year':
        return 'yearly';
      default:
        return 'one off';
    }
  }

  String getPrimaryButtonHint(BuildContext context) {
    if (subscriptionDetails == null) {
      return AppLocalizations.of(context)!.youMayWantToSetUpDonationPlan;
      // return 'You may want to set up a donation plan. Kindly click on the button below to proceed';
    }

    if (subscriptionDetails!.interval == 'month' ||
        subscriptionDetails!.interval == 'year') {
      // return 'You have an active ${getFormattedInterval(subscriptionDetails!.interval)} subscription of £${subscriptionDetails!.amount} to your Portfolio';
      return '${AppLocalizations.of(context)!.youHaveAnActive} ${getFormattedInterval(subscriptionDetails!.interval)} ${AppLocalizations.of(context)!.subscriptionOf} £${subscriptionDetails!.amount} ${AppLocalizations.of(context)!.toYourPortfolio}';
    } else {}
    return AppLocalizations.of(context)!.youMayWantToDonateToYourPortfolio;
    // return 'You may want to donate to your Portfolio again. Kindly click on Be Kiind button to donate';
  }

  String getPrimaryButtonText(BuildContext context) {
    if (subscriptionDetails == null) {
      return AppLocalizations.of(context)!.donateNow;
    }

    if (subscriptionDetails!.interval == 'month' ||
        subscriptionDetails!.interval == 'year') {
      return AppLocalizations.of(context)!.cancelSubscription;
    }

    return 'Be Kiind';
  }

  void cancelSubscription(BuildContext context, int id) async {
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
      } else {
        showAlertToast(AppLocalizations.of(context)!.anErrorOccured);
        // showAlertToast('An error occurred. Please try again.');
        // print('failed to cancel subscription');
        // print(response.statusCode);
        // print(response.data);
      }
    } on DioException {
      showAlertToast(AppLocalizations.of(context)!.anErrorOccured);
      // showAlertToast('An error occurred. Please try again.');
      loading = false;
    }
  }
}
