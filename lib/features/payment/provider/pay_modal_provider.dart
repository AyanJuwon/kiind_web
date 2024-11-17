import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:kiind_web/core/constants/endpoints.dart';
import 'package:kiind_web/core/models/campaign_model.dart';
import 'package:kiind_web/core/providers/base_provider.dart';
import 'package:kiind_web/core/util/extensions/response_extensions.dart';
import 'package:kiind_web/core/util/rest/rest_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PaymentModalProvider extends BaseProvider {
  Campaign? campaign;

  late RestClient client;
  // Initialize client here if not already initialized

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
      callback: initRestClient,
    );
  }

  void initRestClient(BuildContext context) {
    print("i am in provider");
    client = RestClient();
  }

  fetchCampaign(BuildContext context, int campaignID) async {
    final prefs = await SharedPreferences.getInstance();
    token = (await prefs.getString('token'))!;
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
    log("fetched res $res");
    if (res.isValid) {
      campaign = Campaign.fromMap(Map<String, dynamic>.from(res.info!.data));
    }
  }
}
