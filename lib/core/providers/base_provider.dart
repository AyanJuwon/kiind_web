import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:kiind_web/core/constants/app_colors.dart';
import 'package:kiind_web/core/constants/endpoints.dart';
import 'package:kiind_web/core/models/user_model.dart';
import 'package:kiind_web/core/util/extensions/response_extensions.dart';
import 'package:kiind_web/core/util/rest/rest_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class BaseProvider extends ChangeNotifier {
  final ValueNotifier<bool> _initialised = ValueNotifier(false);
  ValueNotifier<bool> get initialisedAsListenable => _initialised;
  String? token;
  late RestClient client;
  User? _user;
  String? shareLink, shareText, shareSubject, shareContent;
  bool closeOnback = false;
  final commentCtrl = TextEditingController();

  String selectedOrganizationSlug = '';

  bool get initialised => _initialised.value;

  set initialised(bool value) {
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        _initialised.value = value;
        log('initialised: $value', name: '$runtimeType');
        _initialised.notifyListeners();
      },
    );
  }

  final ValueNotifier<bool> _loading = ValueNotifier(false);
  ValueNotifier<bool> get loadingAsListenable => _loading;

  bool get loading => _loading.value;
  set loading(bool value) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _loading.value = value;
      log('loading: $value', name: '$runtimeType');
      _loading.notifyListeners();
    });
  }

  Color get bg => AppColors.primaryColor;
  Color get fg => Colors.white;

  init(
    BuildContext context, {
    bool shouldGetUser = false,
    bool needsUser = true,
    String? dbKey,
    Function(BuildContext)? callback,
    bool refresh = true,
  }) async {
    if (!initialised) {
      initialised = true;
      loading = true;

      // Initialize client here if not already initialized
      client = RestClient();

      if (callback != null) await callback(context);
      loading = false;
      return true;
    }
  }

  listenForRefresh(BuildContext context) {}

  getUser(
    BuildContext context, {
    bool load = true,
  }) async {
    if (load) loading = true;

    final prefs = await SharedPreferences.getInstance();
    token = (await prefs.getString('token'))!;

    Response res = await client.get(
      Endpoints.userProfile,
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json'
        },
        extra: {'context': context},
      ),
    );

    if (res.isValid) {
      _user = User.fromMap(res.info!.data!['user']);

      saveUser(_user!);
    }

    if (load) loading = false;
  }

  Future<void> saveUser(User user) async {
    final prefs = await SharedPreferences.getInstance();
    final userMap = user.toMap(); // Call toMap() on the instance 'user'

    final userJson = jsonEncode(userMap); // Convert Map to a JSON string
    await prefs.setString(
        'userData', userJson); // Save JSON string in SharedPreferences

    // If needed, you can set model.user or perform other updates here.
    user = user;
  }

// To retrieve user data from SharedPreferences
  Future<User?> getUserProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString('userData');
    if (userJson != null) {
      final userMap = jsonDecode(userJson);
      if (userMap is Map<String, dynamic>) {
        final newUser = User.fromMap(userMap); // Convert Map to User object
        print("get user from provider  ${newUser.name}");
        return newUser;
      } else {
        print(
            "Error: Expected user data to be a Map but got ${userMap.runtimeType}");
      }
    }
    return null;
  }
}
