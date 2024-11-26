import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kiind_web/core/base_page.dart';
import 'package:kiind_web/core/constants/app_colors.dart';
import 'package:kiind_web/core/constants/texts.dart';
import 'package:kiind_web/core/models/campaign_model.dart';
import 'package:kiind_web/core/models/payment_detail.dart';
import 'package:kiind_web/core/util/extensions/buildcontext_extensions.dart';
import 'package:kiind_web/core/util/extensions/num_extentions.dart';
import 'package:kiind_web/features/payment/provider/payment_summary_page_provider.dart';

class PaymentSummaryPage extends StatefulWidget {
  const PaymentSummaryPage({super.key});

  @override
  _PaymentSummaryPageState createState() => _PaymentSummaryPageState();
}

class _PaymentSummaryPageState extends State<PaymentSummaryPage> {
  @override
  Widget build(BuildContext context) {
    return BasePage<PaymentSummaryPageProvider>(
      child: null,
      provider: PaymentSummaryPageProvider(),
      builder: (context, provider, child) {
        return ValueListenableBuilder<bool>(
          valueListenable: provider.processingPayment,
          builder: (context, processing, body) {
            return Scaffold(
              appBar: AppBar(
                iconTheme: Theme.of(context).iconTheme,
                systemOverlayStyle: SystemUiOverlayStyle.dark,
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                title: processing
                    ? null
                    : customTextNormal('Payment',
                        textColor:
                            Theme.of(context).textTheme.bodyLarge!.color),
                centerTitle: true,
                leading: processing ? const Offstage() : null,
                elevation: 1,
              ),
              body: body,
              bottomNavigationBar: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 32,
                  horizontal: 24,
                ),
                child: MaterialButton(
                  onPressed: () => provider.launchGateway(context),
                  color: AppColors.primaryColor,
                  minWidth: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: customTextNormal(
                    provider.isSub ? 'Subscribe Now' : 'Pay Now',
                    fontWeight: FontWeight.w600,
                    textColor: Colors.white,
                  ),
                ),
              ),
            );
          },
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height * 0.8),
              // padding: const EdgeInsets.symmetric(horizontal: 18),
              child: ValueListenableBuilder<PaymentDetail?>(
                valueListenable: provider.paymentDetail,
                builder: (context, detail, child) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                          decoration: context.cardDecoration,
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Row(
                              children: [
                                Container(
                                  width: 118,
                                  height: 108,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: NetworkImage(
                                          detail?.cause?.featuredImage ?? ''),
                                      fit: BoxFit.cover,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                const SizedBox(width: 24),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      customTextNormal(
                                        detail?.cause?.title ?? 'N/A',
                                        alignment: TextAlign.start,
                                        maxLines: 2,
                                      ),
                                      if ((detail?.cause is Campaign) &&
                                          detail?.cause?.remainingDays != null)
                                        Builder(
                                          builder: (context) {
                                            int dayCount =
                                                detail?.cause?.remainingDays ??
                                                    0;
                                            return Container(
                                              padding:
                                                  const EdgeInsets.only(top: 6),
                                              child: customTextSmall(
                                                  "$dayCount day${dayCount > 1 ? 's' : ''} left",
                                                  alignment: TextAlign.start,
                                                  // textColor: Colors.white,
                                                  textColor: Colors.black54),
                                            );
                                          },
                                        ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 28),
                        Container(
                          decoration: context.cardDecoration,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 20),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    customTextSmall(
                                      provider.paymentType ==
                                              PaymentType.deposit
                                          ? 'Payee:'
                                          : 'Donor:',
                                      alignment: TextAlign.start,
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: customTextNormal(
                                        provider.user?.name ?? 'N/A',
                                        alignment: TextAlign.end,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                const Divider(color: Colors.black54),
                                const SizedBox(height: 6),
                                Row(
                                  children: [
                                    customTextSmall('Amount:',
                                        alignment: TextAlign.start),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: customTextNormal(
                                          "£${(detail?.amounts?.userSubmittedAmount ?? 0).leanString}${provider.isSub ? (' ${provider.interval!}') : ''}",
                                          alignment: TextAlign.end),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                const Divider(color: Colors.black54),
                                const SizedBox(height: 6),
                                Row(
                                  children: [
                                    customTextSmall('Method:',
                                        alignment: TextAlign.start),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: customTextNormal(
                                        provider.method?.label ?? 'N/A',
                                        alignment: TextAlign.end,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        customTextSmall('Service charge'),
                        const SizedBox(height: 12),
                        Container(
                          decoration: context.cardDecoration,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 20,
                            ),
                            child: Builder(
                              builder: (context) {
                                List<Breakdown>? charges =
                                    detail?.charges?.breakdown ?? [];
                                return Column(
                                  children: [
                                    for (Breakdown charge in charges)
                                      Column(
                                        children: [
                                          Row(
                                            children: [
                                              customTextSmall(
                                                '${charge.name}:',
                                                alignment: TextAlign.start,
                                              ),
                                              const SizedBox(width: 12),
                                              Expanded(
                                                child: customTextNormal(
                                                  '£${(double.tryParse(charge.amount ?? '') ?? 0).leanString}',
                                                  alignment: TextAlign.end,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              SizedBox(height: 6),
                                              Divider(color: Colors.black54),
                                              SizedBox(height: 6),
                                            ],
                                          ),
                                        ],
                                      ),
                                    Row(
                                      children: [
                                        customTextSmall(
                                          provider.paymentType ==
                                                  PaymentType.deposit
                                              ? 'Add to Wallet:'
                                              : (detail?.cause is Campaign)
                                                  ? 'Pay to campaign service:'
                                                  : 'Pay to livestream service',
                                          alignment: TextAlign.start,
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: customTextNormal(
                                              '£${(detail?.netCost ?? 0).leanString}',
                                              alignment: TextAlign.end),
                                        ),
                                      ],
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                        ),
                        // const SizedBox(height: 28),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Padding(
                            padding: const EdgeInsets.only(right: 18),
                            child: customTextMedium(
                              '£${(detail?.amounts?.userSubmittedAmount ?? 0).leanString}',
                            ),
                          ),
                        ),
                        // const SizedBox(height: 48),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
