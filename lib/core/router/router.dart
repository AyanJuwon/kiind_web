// ignore_for_file: prefer_typing_uninitialized_variables, unused_import

import 'package:flutter/material.dart';
import 'package:kiind_web/core/models/donation_info_model.dart';
import 'package:kiind_web/core/router/route_paths.dart';
import 'package:kiind_web/features/payment/pages/pay_modal.dart';
import 'package:kiind_web/features/payment/pages/payment_method_screen.dart';
import 'package:kiind_web/features/payment/pages/payment_summary/payment_summary_page.dart';
import 'package:kiind_web/features/philanthropy/presentation/pages/charity_allocation/charity_allocation_page.dart';
import 'package:kiind_web/features/philanthropy/presentation/pages/kiind_portfolio/empty_portfolio_page.dart';
import 'package:kiind_web/features/philanthropy/presentation/pages/kiind_portfolio/kiind_portfolio_page.dart';
import 'package:kiind_web/features/philanthropy/presentation/pages/payment_method/philanthropy_payment_method_page.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/pay':
        final arguments = settings.arguments as Map<String, dynamic>? ?? {};
        if (arguments.isEmpty) {
          return MaterialPageRoute(
            builder: (_) => const Scaffold(
              body: Center(
                child: Text('Payment details not provided.'),
              ),
            ),
            settings: settings,
          );
        }
        return MaterialPageRoute(
          builder: (_) => PayModal(
            paymentDetails: arguments,
            preset: null, // Adjust based on your needs
          ),
          settings: settings,
        );

      case RoutePaths.paymentMethodScreen:
        final arguments = settings.arguments as Map<String, dynamic>? ?? {};

        return MaterialPageRoute(
          builder: (_) => const PaymentMethodPage(),
          settings: settings,
        );
      case RoutePaths.paymentSummaryScreen:
        return MaterialPageRoute(
          builder: (_) => const PaymentSummaryPage(),
          settings: settings,
        );
      // case RoutePaths.paymentSuccessfulScreen:
      //   return MaterialPageRoute(
      //     builder: (_) => const PaymentSuccessfulPage(),
      //     settings: settings,
      //   );

      // case RoutePaths.walletScreen:
      //   return MaterialPageRoute(
      //     builder: (_) => const WalletPage(),
      //     settings: settings,
      //   );
      // case RoutePaths.fundWalletScreen:
      //   return MaterialPageRoute(
      //     builder: (_) => const FundWalletPage(),
      //     settings: settings,
      //   );

      case RoutePaths.charityAllocationScreen:
        final arg = settings.arguments as Map<String, dynamic>;

        return MaterialPageRoute(
            builder: (_) => CharityAllocationPage(
                  selectedCharities: arg['selectedCharities'],
                  donationInfo: arg['donationInfo'],
                  subscriptionId: arg['subscriptionId'],
                ));
      case RoutePaths.kiindPortfolioScreen:
        return MaterialPageRoute(builder: (_) => const KiindPortfolioPage());
      case RoutePaths.emptyKiindPortfolioScreen:
        return MaterialPageRoute(
            builder: (_) => const EmptyKiindPortfolioPage());
      case RoutePaths.philanthropyPaymentMethodSscreen:
        final arg = settings.arguments as DonationInfoModel;
        return MaterialPageRoute(
            builder: (_) => PhilanthropyPaymentMethodPage(
                  donationInfo: arg,
                ));

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}
