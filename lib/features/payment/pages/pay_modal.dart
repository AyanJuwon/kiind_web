import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:kiind_web/core/constants/app_colors.dart'; 
import 'package:kiind_web/core/constants/endpoints.dart';
import 'package:kiind_web/core/models/campaign_model.dart';
import 'package:kiind_web/core/models/options.model.dart' as payment_options;
import 'package:kiind_web/core/models/payment_detail.dart';
import 'package:kiind_web/core/models/post_model.dart';
import 'package:kiind_web/core/router/route_paths.dart';
import 'package:kiind_web/core/util/extensions/buildcontext_extensions.dart';
import 'package:kiind_web/core/util/extensions/num_extentions.dart';
import 'package:kiind_web/features/payment/provider/payment_summary_page_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/constants/texts.dart';

class PayModal extends StatefulWidget {
  final String? subInterval;
  final num? preset;
  // final Options options;
  final Color themeColor;
  final bool forWallet;
  final dynamic paymentDetails;
  final dynamic cause;
  final Function(String)? onSelectSubscription;
  final ValueNotifier<String?>? subscriptionOption;

  const PayModal({
    super.key,
    this.paymentDetails,
    // required this.options,

    this.themeColor = AppColors.primaryColor,
    this.forWallet = false,
    this.preset,
    this.subInterval = 'One Time',
    this.cause,
    this.subscriptionOption,
    this.onSelectSubscription,
  });

  @override
  State<PayModal> createState() => _PayModalState();
}

class _PayModalState extends State<PayModal> {
  final ValueNotifier<int> presetIndex = ValueNotifier(-1);
  payment_options.Options? options;
  final _priceController = TextEditingController();
  final _purposeController = TextEditingController();
  Campaign? campaign;
  Campaign? walletFundCampaign;
  ValueNotifier<num> multiplier = ValueNotifier(1);

  int idx = 0;
  num? _preset;

  ValueNotifier<String?> priceStr = ValueNotifier(null);
  final Dio dio = Dio();

  Future<void> fetchData() async {
     if(widget.paymentDetails['campaign_id']!= null){
       try {
      options = payment_options.Options.forWallet();
      final prefs = await SharedPreferences.getInstance();
      final token = (prefs.getString('token'))!;
 
      final response = await dio.get(
        "https://app.kiind.co.uk/api/v2${Endpoints.campaignDetail}/${widget.paymentDetails['campaign_id']}",
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json'
          },
          extra: {'context': context},
        ),
      );

      campaign = Campaign.fromMap(response.data['data']);
      setState(() {
        options = campaign!.options!;
      });
    } catch (e) {
      // print('Error: $e');
      campaign = Campaign(
        title: 'Fund Wallet',
        featuredImage: 'https://img.icons8.com/color/452/wallet--v1.png',
        type: 'Other',
        options: payment_options.Options.forWallet(),
      );
      options = payment_options.Options.forWallet();
    }
  }else{
      campaign = Campaign(
        title: 'Fund Wallet',
        featuredImage: 'https://img.icons8.com/color/452/wallet--v1.png',
        type: 'Other',
        options: payment_options.Options.forWallet(),
      );
      options = payment_options.Options.forWallet();
  }
 
  }

  void changeDonation(int index) {
    presetIndex.value = index;

    // -1 is passed to clear the selected preset
    if (index >= 0) {
      _priceController.text = options!.valueAt(
        index,
        multiplier: multiplier.value,
      );
    }

    idx = index;
  }

  void setMultiplier(String key) {
    switch (key.toLowerCase()) {
      case 'yearly':
        multiplier.value =
            (widget.cause!.yearly ?? 0) / (widget.cause!.monthly ?? 1);
        break;
      case 'one time':
        multiplier.value =
            (widget.cause!.yearly ?? 0) / (widget.cause!.oneTime ?? 1);
        break;
      default:
        multiplier.value = 1;
        break;
    }
  }

  void setDefault(String? key) {
    dynamic _cause = widget.cause;

    if (_cause?.isOther ?? false) {
      switch (key?.toLowerCase()) {
        case 'yearly':
          _preset = _cause!.yearly;
          break;
        case 'one time':
          _preset = _cause!.oneTime;
          break;
        case 'monthly':
        default:
          _preset = _cause!.monthly;
          break;
      }
    }
  }

  @override
  void initState() {
    fetchData();

    _priceController.addListener(() {
      priceStr.value = _priceController.text;
    });

    if (widget.preset == null) {
      changeDonation(0);
    } else {
      changeDonation(-1);

      setDefault(null);
      _priceController.text = (_preset ?? widget.preset)!.leanString;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _size = MediaQuery.of(context).size;
//  final translation = AppLocalizations.of(context);
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: SizedBox(
        height: _size.height * 0.9,
        child: Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (widget.cause?.isOther ?? false)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 18,
                        ),
                        color: context.brightness == Brightness.light
                            ? const Color(0xFFE2E2E2)
                            : const Color(0xFF1C1C1C),
                        child: customTextMedium(
                          'CHOOSE A SUBSCRIPTION PLAN',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      ValueListenableBuilder<String?>(
                        valueListenable: widget.subscriptionOption!,
                        builder: (context, _option, child) {
                          Campaign? cause = widget.cause as Campaign?;
                          return Row(
                            children: (cause?.subscriptionOptions ?? {})
                                .keys
                                .map(
                                  (key) => SubscriptionTile(
                                    themeColor: AppColors.primaryColor,
                                    active: _option == key,
                                    onTap: () {
                                      FocusScope.of(context).unfocus();

                                      widget.onSelectSubscription!(key);

                                      // update selected subscription based on new frequency
                                      setMultiplier(key);

                                      // update selected subscription based on new frequency
                                      changeDonation(idx);
                                    },
                                    title: key,
                                    isLast: key ==
                                        widget.cause!.subscriptionOptions.keys
                                            .last,
                                  ),
                                )
                                .toList(),
                          );
                        },
                      ),
                    ],
                  ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 24,
                    horizontal: 28,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (widget.cause is Post)
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextField(
                              controller: _purposeController,
                              textAlign: TextAlign.center,
                              onChanged: (value) {
                                if (['', null].contains(value.trim())) {
                                  // set purpose
                                }
                              },
                              decoration: InputDecoration(
                                fillColor:
                                    const Color(0xFFC4C4C4).withOpacity(0.34),
                                filled: true,
                                border: InputBorder.none,
                                hintText: 'Input your purpose of donation',
                              ),
                            ),
                            const SizedBox(height: 28),
                          ],
                        ),
                      ValueListenableBuilder<String?>(
                        valueListenable: (widget.cause?.isOther ?? false)
                            ? widget.subscriptionOption!
                            : ValueNotifier(null),
                        builder: (context, _option, child) {
                          bool isSub = !['One Time', null].contains(_option);

                          return customTextNormal(
                              widget.forWallet
                                  ? 'How much do you want to add?'
                                  : 'How much do you want to donate${isSub ? (' ' + (_option?.toLowerCase() ?? '')) : ''}?',
                              fontWeight: FontWeight.w600,
                              textColor: Colors.black);
                        },
                      ),
                      const SizedBox(height: 18),
                      ValueListenableBuilder<num>(
                        valueListenable: multiplier,
                        builder: (context, _multiplier, child) {
                          return ValueListenableBuilder(
                            valueListenable: presetIndex,
                            builder: (context, _donation, child) {
                              return Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Row(
                                    children: List.generate(
                                      options!.values.length ~/ 2,
                                      (index) => Expanded(
                                        child: InkWell(
                                          onTap: () {
                                            FocusScope.of(context).unfocus();
                                            changeDonation(index);
                                          },
                                          child: AnimatedContainer(
                                            duration: const Duration(
                                                milliseconds: 500),
                                            margin: const EdgeInsets.symmetric(
                                                horizontal: 2),
                                            decoration: BoxDecoration(
                                              color: _donation == index
                                                  ? AppColors.primaryColor
                                                  : AppColors.primaryColor
                                                      .withOpacity(0.45),
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                vertical: 12,
                                              ),
                                              child: customTextNormal(
                                                options!.faceValueAt(
                                                  index,
                                                  multiplier: _multiplier,
                                                ),
                                                textColor: _donation == index
                                                    ? Colors.white
                                                    : Colors.black87,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: List.generate(
                                      options!.values.length ~/ 2,
                                      (index) => Expanded(
                                        child: InkWell(
                                          onTap: () {
                                            FocusScope.of(context).unfocus();
                                            changeDonation(index + 2);
                                          },
                                          child: AnimatedContainer(
                                            duration: const Duration(
                                                milliseconds: 500),
                                            margin: const EdgeInsets.symmetric(
                                                horizontal: 2),
                                            decoration: BoxDecoration(
                                              color: _donation == index + 2
                                                  ? AppColors.primaryColor
                                                  : AppColors.primaryColor
                                                      .withOpacity(0.45),
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                vertical: 12,
                                              ),
                                              child: customTextNormal(
                                                options!.faceValueAt(
                                                  (index + 2),
                                                  multiplier: _multiplier,
                                                ),
                                                textColor:
                                                    _donation == index + 2
                                                        ? Colors.white
                                                        : Colors.black87,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                      const SizedBox(height: 28),
                      customTextNormal('Or',
                          fontWeight: FontWeight.w600, textColor: Colors.black),
                      const SizedBox(height: 28),
                      TextField(
                        controller: _priceController,
                        textAlign: TextAlign.center,
                        onChanged: (value) {
                          if (presetIndex.value >= 0) {
                            changeDonation(-1);
                          }
                        },
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        decoration: InputDecoration(
                          fillColor: const Color(0xFFC4C4C4).withOpacity(0.34),
                          filled: true,
                          border: InputBorder.none,
                          hintText: 'Enter price manually',
                        ),
                      ),
                      const SizedBox(height: 48),
                      ValueListenableBuilder<String?>(
                        valueListenable: priceStr,
                        builder: (context, _priceStr, child) {
                          bool enabled =
                              (double.tryParse(_priceStr ?? '') ?? 0) > 0;
// if campaign
                          print("building button");
                          return MaterialButton(
                            onPressed: enabled
                                ? () async {
                                    bool isOther = (campaign?.isOther ?? false);
                                    String opt = '';

                                    Amounts amounts = Amounts(
                                      userSubmittedAmount: double.tryParse(
                                          _priceController.text),
                                    );
                                    Map<String, dynamic> detail = PaymentDetail(
                                      amounts: amounts,
                                      cause: campaign,
                                    ).toMap();
                                    if (isOther) {
                                      // _opt = (subscriptionOption.value ?? '')
                                      //     .toLowerCase()
                                      //     .replaceAll(' ', '_');
                                      detail["__interval"] = opt;
                                      detail["__type"] = (opt.contains('_')
                                              ? PaymentType.oneTime
                                              : PaymentType.subscription)
                                          .index;
                                      // preset = _campaign
                                      //     ?.subscriptionOptions[subscriptionOption.value ?? ''];
                                    }
                                    if (campaign!.title == 'Fund Wallet') {
                                      detail['__type'] =
                                          PaymentType.deposit.index;
                                    }

                                   

                                    await context.off(
                                      RoutePaths.paymentMethodScreen,
                                      // RoutePaths.paymentSummaryScreen,
                                      args: detail,
                                    );
                                  }
                                : null, // Pass null when disabled
                            color:
                                enabled ? AppColors.primaryColor : Colors.grey,
                            minWidth: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 22),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(38),
                            ),
                            child: customTextNormal(
                              "Continues",
                              textColor: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          );

                   
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 48),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SubscriptionTile extends StatelessWidget {
  final Color themeColor;
  final String title;
  final bool active;
  final bool isLast;
  final Function() onTap;

  const SubscriptionTile({
    Key? key,
    this.themeColor = AppColors.primaryColor,
    required this.active,
    required this.onTap,
    required this.title,
    this.isLast = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: active ? null : onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(
            vertical: 18,
          ),
          decoration: BoxDecoration(
            color: context.brightness == Brightness.light
                ? null
                : const Color(0xFF1C1C1C),
            border: isLast
                ? BorderDirectional(
                    bottom: BorderSide(
                      width: 2,
                      color: active ? themeColor : Colors.grey.withOpacity(.5),
                    ),
                  )
                : BorderDirectional(
                    bottom: BorderSide(
                      width: 2,
                      color: active ? themeColor : Colors.grey.withOpacity(.5),
                    ),
                    end: BorderSide(
                      width: 1,
                      color: Colors.grey.withOpacity(.5),
                    ),
                  ),
          ),
          child: customTextNormal(
            title,
            textColor: active ? themeColor : null,  
          ),
        ),
      ),
    );
  }
}
