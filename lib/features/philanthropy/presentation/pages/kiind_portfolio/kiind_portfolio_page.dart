import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kiind_web/core/base_page.dart';
import 'package:kiind_web/core/constants/app_colors.dart';
import 'package:kiind_web/core/constants/texts.dart';
import 'package:kiind_web/core/router/route_paths.dart';
import 'package:kiind_web/features/philanthropy/presentation/pages/kiind_portfolio/empty_portfolio_page.dart';
import 'package:kiind_web/features/philanthropy/presentation/pages/kiind_portfolio/widgets/kiind_modal.dart';
import 'package:kiind_web/features/philanthropy/presentation/pages/kiind_portfolio/widgets/kiind_portfolio_item.dart';
import 'package:kiind_web/features/philanthropy/presentation/providers/kiind_portfolio_page_provider.dart';
import 'package:kiind_web/widgets/donation_modal.dart';
import 'package:kiind_web/widgets/full_width_button.dart';
import 'package:pie_chart/pie_chart.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class KiindPortfolioPage extends StatefulWidget {
  const KiindPortfolioPage({Key? key}) : super(key: key);

  @override
  _KiindPortfolioPageState createState() => _KiindPortfolioPageState();
}

class _KiindPortfolioPageState extends State<KiindPortfolioPage> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final translation = AppLocalizations.of(context);
    return BasePage<KiindPortfolioPageProvider>(
      child: null,
      provider: KiindPortfolioPageProvider(),
      builder: (context, provider, child) {
        if (provider.categories == null &&
            !provider.error &&
            !provider.hasError) {
          provider.getPortfolio();
        }

        if (provider.loading) {
          return Scaffold(
            appBar: AppBar(
              iconTheme: Theme.of(context).iconTheme,
              systemOverlayStyle: SystemUiOverlayStyle.dark,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              title: customTextNormal(translation!.myKiindPortfolio,
                  textColor: Theme.of(context).textTheme.bodyLarge!.color),
              centerTitle: true,
              elevation: 1,
            ),
          );
        }

        if (!provider.loading && provider.hasError) {
          return Scaffold(
            appBar: AppBar(
              iconTheme: Theme.of(context).iconTheme,
              systemOverlayStyle: SystemUiOverlayStyle.dark,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              title: customTextNormal(translation!.myKiindPortfolio,
                  textColor: Theme.of(context).textTheme.bodyLarge!.color),
              centerTitle: true,
              elevation: 1,
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  customTextNormal(translation.anErrorOccuredPortflio),
                  TextButton(
                      onPressed: () => provider.getPortfolio(),
                      child: customTextSmall(translation.tryAgain))
                ],
              ),
            ),
          );
        }

        if (!provider.loading &&
            (provider.categories == null || provider.categories!.isEmpty)) {
          return const EmptyKiindPortfolioPage();
        }

        return Scaffold(
          appBar: AppBar(
            iconTheme: Theme.of(context).iconTheme,
            systemOverlayStyle: SystemUiOverlayStyle.dark,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            title: customTextNormal(translation!.myKiindPortfolio,
                textColor: Theme.of(context).textTheme.bodyLarge!.color),
            centerTitle: true,
            elevation: 1,
          ),
          body: RefreshIndicator(
            onRefresh: () async {
              provider.getPortfolio();
            },
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 18),
              child: Column(
                children: [
                  Stack(
                    children: [
                      Center(
                        child: PieChart(
                          dataMap: provider.getDataMap(),
                          animationDuration: const Duration(milliseconds: 800),
                          chartLegendSpacing: 32,
                          chartRadius: size.width / 2.2,
                          colorList: provider.getColors(),
                          initialAngleInDegree: 0,
                          chartType: ChartType.ring,
                          ringStrokeWidth: 42,
                          centerText: "",
                          legendOptions: const LegendOptions(
                            showLegends: false,
                          ),
                          chartValuesOptions: const ChartValuesOptions(
                            showChartValues: false,
                          ),
                        ),
                      ),
                      Positioned.fill(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: size.width * 0.25,
                              child: customTextNormal(
                                  '£${provider.donationAmount}',
                                  fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            Container(
                              width: size.width * 0.2,
                              height: 1,
                              color: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? Colors.white38
                                  : Colors.black45,
                            ),
                            const SizedBox(height: 4),
                            customTextSmall('My Kiinds',
                                fontWeight: FontWeight.w600, fontSize: 12),
                            customTextSmall('${provider.donationCount}',
                                fontWeight: FontWeight.bold),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  Align(
                    alignment: Alignment.centerRight,
                    child: MaterialButton(
                      onPressed: () async {
                        showDialog(
                            context: context,
                            builder: (dialogContext) {
                              return AlertDialog(
                                title: customTextMedium(
                                    translation.editPortfolio,
                                    alignment: TextAlign.start),
                                content: customTextNormal(
                                    translation.makeChangesToYourPortfolio,
                                    // 'Making changes to your Portfolio will cancel your active subscription. Do you wish to continue?',
                                    alignment: TextAlign.start),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        Navigator.of(dialogContext).pop();
                                      },
                                      child: customTextNormal('No')),
                                  TextButton(
                                      onPressed: () async {
                                        Navigator.of(dialogContext).pop();
                                        await Navigator.of(context).pushNamed(
                                            RoutePaths.charitySelectionScreen,
                                            arguments: {
                                              'syncedCharities': provider
                                                  .parseSyncedCharities(),
                                              'subscriptionId':
                                                  provider.subscriptionDetails ==
                                                          null
                                                      ? null
                                                      : provider
                                                          .subscriptionDetails!
                                                          .id
                                            });
                                        provider.getPortfolio();
                                      },
                                      child: customTextNormal(translation.yes))
                                ],
                              );
                            });
                      },
                      child: customTextNormal(
                        translation.edit,
                        textColor: Colors.white,
                      ),
                      color: AppColors.primaryColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28)),
                    ),
                  ),
                  const SizedBox(height: 24),
                  ...List.generate(provider.categories!.length, (index) {
                    final temp = provider.categories![index]['percentage'];
                    double allocation;
                    if (temp is int) {
                      allocation = temp.toDouble();
                    } else {
                      allocation = temp;
                    }

                    if (provider.categories!.isEmpty) {
                      return Container();
                    }

                    return KiindPortfolioItem(
                      label: provider.categories![index]['category'],
                      allocation: allocation,
                      color: provider.getColors()[index],
                      charities: List<Map>.from(
                              provider.categories![index]['charities'])
                          .map((charity) => charity['title'].toString())
                          .toList(),
                    );
                  }),
                  const SizedBox(height: 68),
                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 28),
                      child: customTextSmall(
                          provider.getPrimaryButtonHint(context),
                          fontSize: 12)),
                  const SizedBox(height: 12),
                  FullWidthButton(
                    onPressed: () {
                      if (provider.subscriptionDetails == null) {
                        showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            builder: (modalContext) {
                              return CampaignDonateModal(
                                  onContinue: (donationInfo) {
                                Navigator.of(modalContext).pop();
                                Navigator.of(context).pushNamed(
                                    RoutePaths.philanthropyPaymentMethodSscreen,
                                    arguments: donationInfo);
                              });
                            });
                      }

                      if (provider.subscriptionDetails!.interval == 'month' ||
                          provider.subscriptionDetails!.interval == 'year') {
                        showDialog(
                            context: context,
                            builder: (dialogContext) {
                              return AlertDialog(
                                title: customTextMedium('Cancel subscription',
                                    alignment: TextAlign.start),
                                content: customTextNormal(
                                    'Do you wish to cancel your portfolio donation subscription?',
                                    alignment: TextAlign.justify),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        Navigator.of(dialogContext).pop();
                                      },
                                      child: customTextNormal('No')),
                                  TextButton(
                                      onPressed: () {
                                        Navigator.of(dialogContext).pop();
                                        provider.cancelSubscription(context,
                                            provider.subscriptionDetails!.id);
                                      },
                                      child: customTextNormal('Yes',
                                          textColor: Colors.redAccent))
                                ],
                              );
                            });
                      } else {
                        showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            builder: (modalContext) {
                              return KiindDonateModal(
                                  onContinue: (donationInfo) {
                                Navigator.of(modalContext).pop();
                                Navigator.of(context).pushNamed(
                                    RoutePaths.philanthropyPaymentMethodSscreen,
                                    arguments: donationInfo);
                              });
                            });
                      }
                    },
                    text: provider.getPrimaryButtonText(context),
                    color: AppColors.primaryColor,
                    borderRadius: 28,
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
