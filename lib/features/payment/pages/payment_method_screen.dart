import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kiind_web/core/base_page.dart';
import 'package:kiind_web/core/constants/app_colors.dart';
import 'package:kiind_web/core/constants/configs.dart';
import 'package:kiind_web/core/constants/texts.dart';
import 'package:kiind_web/core/models/campaign_model.dart';
import 'package:kiind_web/core/models/options.model.dart';
import 'package:kiind_web/core/models/payment_method.dart';
import 'package:kiind_web/core/util/extensions/buildcontext_extensions.dart';
import 'package:kiind_web/features/payment/provider/payment_method_page_provider.dart';
import 'package:kiind_web/widgets/refresh_widget.dart';

class PaymentMethodPage extends StatefulWidget {
  const PaymentMethodPage({Key? key}) : super(key: key);

  @override
  _PaymentMethodPageState createState() => _PaymentMethodPageState();
}

class _PaymentMethodPageState extends State<PaymentMethodPage> {
  final keyRefresh = GlobalKey<RefreshIndicatorState>();

  @override
  Widget build(BuildContext context) {
    return BasePage<PaymentMethodPageProvider>(
      child: null,
      provider: PaymentMethodPageProvider(),
      builder: (context, provider, child) {
        provider.init(context);
        if (context.args['campaign'] != null) {
          provider.campaign = Campaign.fromMap(context.args['campaign']);
        } else {
          provider.campaign = Campaign(
            title: 'Fund Wallet',
            featuredImage: 'https://img.icons8.com/color/452/wallet--v1.png',
            type: 'Other',
            options: Options.forWallet(),
          );
        }

        // Get screen width to adjust layout dynamically
        double screenWidth = MediaQuery.of(context).size.width;
        bool isMobile = screenWidth < 600; // Adjust this threshold as needed

        return Scaffold(
          appBar: AppBar(
            iconTheme: Theme.of(context).iconTheme,
            systemOverlayStyle: SystemUiOverlayStyle.dark,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            title: customTextNormal(
              'Select Payment Method',
              textColor: Theme.of(context).textTheme.bodyLarge!.color,
            ),
            centerTitle: true,
            elevation: 1,
          ),
          body: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ValueListenableBuilder<bool>(
                valueListenable: provider.loadingAsListenable,
                builder: (context, loading, child) {
                  return loading
                      ? LinearProgressIndicator(
                          color: AppColors.primaryColor,
                          backgroundColor:
                              AppColors.primaryColor.withOpacity(.25),
                        )
                      : const Offstage();
                },
              ),
              Expanded(
                child: RefreshWidget(
                  onRefresh: () async {
                    provider.init(
                      context,
                      needsUser: false,
                    );
                  },
                  keyRefresh: keyRefresh,
                  child: Container(
                    margin: EdgeInsets.only(top: globalPadding),
                    child: ListView.separated(
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      itemCount: provider.paymentMethods.length,
                      itemBuilder: (context, index) {
                        PaymentMethod method =
                            provider.paymentMethods.values.elementAt(index);

                        return Container(
                          margin: EdgeInsets.symmetric(
                            horizontal: isMobile
                                ? globalPadding
                                : 20, // Adjust margin for mobile
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: const Color(0xFFC8C7C7).withOpacity(0.34),
                          ),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(12),
                            onTap: () => provider.selectMethod(
                                method,
                                context,
                                context.args['amounts']
                                    ['user_submitted_amount']),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: isMobile
                                    ? globalPadding
                                    : 16, // Adjust padding for mobile
                                vertical: isMobile
                                    ? globalPadding
                                    : 12, // Adjust padding for mobile
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    height: 25,
                                    width: 25,
                                    margin: const EdgeInsetsDirectional.only(
                                        end: globalPadding),
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: NetworkImage(
                                          provider.methodLogo(method),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: customTextMedium(
                                      method.label,
                                      alignment: TextAlign.start,
                                      fontSize: isMobile
                                          ? 14
                                          : 16, // Adjust font size for mobile
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (context, index) => const SizedBox(
                        height: 16,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
