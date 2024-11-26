import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kiind_web/core/base_page.dart';
import 'package:kiind_web/core/constants/configs.dart';
import 'package:kiind_web/core/constants/texts.dart';
import 'package:kiind_web/core/models/donation_info_model.dart';
import 'package:kiind_web/core/models/payment_method.dart';
import 'package:kiind_web/features/philanthropy/presentation/providers/philanthropy_payment_method_page_provider.dart';

class PhilanthropyPaymentMethodPage extends StatefulWidget {
  final DonationInfoModel donationInfo;

  const PhilanthropyPaymentMethodPage({super.key, required this.donationInfo});

  @override
  _PhilanthropyPaymentMethodPageState createState() =>
      _PhilanthropyPaymentMethodPageState();
}

class _PhilanthropyPaymentMethodPageState
    extends State<PhilanthropyPaymentMethodPage> {
  @override
  Widget build(BuildContext context) {
    print("donation info  :::: ${widget.donationInfo.payload}");
    return BasePage<PhilanthropyPaymentMethodPageProvider>(
        child: null,
        provider: PhilanthropyPaymentMethodPageProvider(),
        builder: (context, provider, child) {
          if (!provider.loading && provider.paymentMethods == null) {
            provider.getPaymentMethods();
          }

          return Scaffold(
              appBar: AppBar(
                iconTheme: Theme.of(context).iconTheme,
                systemOverlayStyle: SystemUiOverlayStyle.dark,
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                title: customTextNormal(
                  'Payment Method',
                  textColor: Theme.of(context).textTheme.bodyLarge!.color,
                ),
                centerTitle: true,
                elevation: 1,
              ),
              body: Padding(
                padding: const EdgeInsets.only(top: globalPadding),
                child: Builder(builder: (context) {
                  if (provider.loading || provider.paymentMethods == null) {
                    return Container();
                  }

                  return ListView.separated(
                      itemCount: provider.paymentMethods!.length,
                      separatorBuilder: (context, index) => Offstage(
                            offstage: index >= provider.paymentMethods!.length,
                            child: const SizedBox(
                              height: 16,
                            ),
                          ),
                      itemBuilder: (_, index) {
                        PaymentMethod method = provider.paymentMethods![index];

                        return Container(
                          margin: const EdgeInsets.symmetric(
                            horizontal: globalPadding,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: const Color(0xFFC8C7C7).withOpacity(0.34),
                          ),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(12),
                            onTap: () => provider.initKiindDonation(
                                context, widget.donationInfo, method),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: globalPadding,
                                vertical: globalPadding,
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
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      });
                }),
              ));
        });
  }
}
