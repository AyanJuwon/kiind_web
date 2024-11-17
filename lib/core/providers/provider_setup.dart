import 'package:flutter/material.dart';
import 'package:kiind_web/core/models/app_model.dart';
import 'package:kiind_web/core/util/rest/rest_client.dart';
import 'package:kiind_web/features/payment/provider/pay_modal_provider.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

final GlobalKey<NavigatorState> navigator = GlobalKey<NavigatorState>();

List<SingleChildWidget> providers = [
  ...independentServices,
  // ...dependentServices,
];

List<SingleChildWidget> independentServices = [
// Provider.value(value: await Hive.openBox<dynamic>(kPrefBox)),
  Provider.value(value: RestClient()),
  // Provider.value(value: GlobalKey<NavigatorState>()),
  Provider.value(value: navigator),
  ChangeNotifierProvider.value(value: AppModel()),
  ChangeNotifierProvider(
      create: (_) => PaymentModalProvider()), // add PaymentModalProvider
];

List<SingleChildWidget> dependentServices = [];
