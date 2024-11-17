import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/app_colors.dart';

class AppModel extends ChangeNotifier {
  // User? user;

  Color groupBg = AppColors.primaryColor;
  Color groupFg = Colors.white;
  String? locale;
  Future loadLocale() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    locale = prefs.getString('languageCode') ?? 'en';
  }

  // Group? guestGroup;
}
