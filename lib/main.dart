import 'dart:html' as html;
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:kiind_web/core/constants/app_colors.dart';
import 'package:kiind_web/core/providers/provider_setup.dart';
import 'package:kiind_web/core/router/router.dart';
import 'package:kiind_web/widgets/donation_modal.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables
  await dotenv.load();

  // Parse the current URL
  final uri = Uri.parse(html.window.location.href);

  // Extract query parameters
  final token = uri.queryParameters['token'];
  final cause = uri.queryParameters['cause'];
  final amounts = uri.queryParameters['amounts'];
  final interval = uri.queryParameters['__interval'];
  final type = uri.queryParameters['__type'];

  // Initialize payment details map
  Map<String, dynamic> paymentDetails = {};

  // Save token to SharedPreferences if present
  final prefs = await SharedPreferences.getInstance();
  if (token != null && token.isNotEmpty) {
    await prefs.setString('token', token);
  } else {
    // Use a default token if not provided in the URL
    await prefs.setString(
        'token', "301|aIMbmUCORPpihhSlf28phQs29wo9CrIidg0UDEyf");
  }
// U5MhyA9rNlOSC8LW0qj1oXIoD9P4reYsbVG8BJ24
// U5MhyA9rNlOSC8LW0qj1oXIoD9P4reYsbVG8BJ24
  // Populate payment details with extracted parameters
  paymentDetails = {
    "campaign_id": cause != null ? int.tryParse(cause) : null,
    "amounts": amounts != null ? double.tryParse(amounts) : null,
    "__interval": interval,
    "__type": type,
    "user_id": 19, // Default or extracted value
  };

  // Determine the initial route based on the URL path
  String initialRoute = uri.path.isEmpty ? '/' : uri.path.split('?').first;

  // Debugging logs for verification
  print('Full URL: ${html.window.location.href}');
  print('Path: $initialRoute');
  print('Query Parameters: ${uri.queryParameters}');
  print('Payment Details: $paymentDetails');

  // Run the app
  runApp(OKToast(
    child: MyApp(
      paymentDetails: paymentDetails,
      initialRoute: initialRoute,
    ),
  ));
}

class MyApp extends StatelessWidget {
  final Map<String, dynamic> paymentDetails;
  final String initialRoute;

  const MyApp(
      {super.key, required this.paymentDetails, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: providers,
      builder: (context, child) {
        return MaterialApp(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          title: 'Kiind',
          theme: ThemeData(
            primarySwatch: createMaterialColor(AppColors.primaryColor),
          ),
          initialRoute: initialRoute, // Set the initial route
          onGenerateRoute: (settings) {
            // Pass payment details to `/pay` route if applicable
            if (settings.name == '/pay') {
              return AppRouter.generateRoute(RouteSettings(
                name: '/pay',
                arguments: paymentDetails,
              ));
            }
            if (settings.name == '/portfolio-payment') {
              return MaterialPageRoute(
                  builder: (_) => const CampaignDonateModal());
            }
            return AppRouter.generateRoute(settings);
          },
        );
      },
    );
  }
}
