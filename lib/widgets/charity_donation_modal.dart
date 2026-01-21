// ignore_for_file: prefer_const_constructors, unused_local_variable, prefer_typing_uninitialized_variables
import 'package:flutter/material.dart';
import 'package:kiind_web/l10n/app_localizations.dart';
import 'package:kiind_web/core/constants/app_colors.dart';
import 'package:kiind_web/core/constants/texts.dart';
import 'package:kiind_web/core/models/donation_info_model.dart';
import 'package:kiind_web/core/router/route_paths.dart';

const _charityPayments = ['£5', '£10', '£20', '£50'];

class CharityDonationModal extends StatefulWidget {
  final Map<String, dynamic>? arguments;
  
  const CharityDonationModal({
    super.key,
    this.arguments,
  });

  @override
  State<CharityDonationModal> createState() => _CharityDonationModalState();
}

class _CharityDonationModalState extends State<CharityDonationModal> {
  final List<String> _apiSubscriptionPlans = ['Monthly', 'Yearly', 'One off'];
  late final TextEditingController _priceController;

  int _selectedSubscriptionPlan = 2; // Default to One off
  int? selectedOption;
  int _selectedDonation = 0;
  final bool _isManual = false;
  bool _addGiftAid = false;

  @override
  void initState() {
    super.initState();
    _priceController =
        TextEditingController(text: _charityPayments[0].replaceAll('£', ''));
  }

  void changeDonation(int index) {
    setState(() {
      _selectedDonation = index;
      if (index >= 0) {
        _priceController.text = _charityPayments[index].replaceAll('£', '');
      }
    });
  }

  void changeManualDonation(bool manual) {
    if (!manual) {
      _priceController.text = '';
      setState(() {
        _selectedDonation = 0;
      });
    }
  }

  String calculateGiftAid() {
    if (!_isManual && _priceController.value.text.isNotEmpty) {
      final amount = double.parse(_priceController.value.text);
      return ((amount * 25) / 100).toStringAsFixed(2);
    }

    double amount;
    if (_selectedDonation < 0) {
      amount = double.parse(_charityPayments[0].replaceAll('£', ''));
    } else {
      amount =
          double.parse(_charityPayments[_selectedDonation].replaceAll('£', ''));
    }
    return ((amount * 25) / 100).toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final translation = AppLocalizations.of(context);
    final subscriptionPlans = [
      translation!.monthly,
      translation.yearly,
      translation.oneOff,
    ];

    // Initialize the subscription plan map here
    final subscriptionPlanMap = {
      translation.monthly: _apiSubscriptionPlans[0],
      translation.yearly: _apiSubscriptionPlans[1],
      translation.oneOff: _apiSubscriptionPlans[2],
    };

    return Scaffold(
      body: SizedBox(
        height: size.height * 0.9,
        child: Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  color: Theme.of(context).brightness == Brightness.light
                      ? Colors.grey.withOpacity(0.2)
                      : Theme.of(context).colorScheme.surface,
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: customTextNormal(
                        'Charity Donation'.toUpperCase(),
                        fontWeight: FontWeight.w600,
                        alignment: TextAlign.center),
                  ),
                ),
                // Hidden subscription plan selector - always defaults to one-off
                // Row(
                //   children: List.generate(
                //       subscriptionPlans.length,
                //       (index) => Expanded(
                //             child: InkWell(
                //               onTap: () {
                //                 setState(() {
                //                   _selectedSubscriptionPlan = index;
                //                 });
                //               },
                //               child: AnimatedContainer(
                //                 duration: Duration(milliseconds: 500),
                //                 decoration: BoxDecoration(
                //                     color:
                //                         Theme.of(context).colorScheme.surface,
                //                     border: Border(
                //                         bottom: BorderSide(
                //                             color: _selectedSubscriptionPlan ==
                //                                     index
                //                                 ? AppColors.primaryColor1
                //                                 : Theme.of(context)
                //                                             .brightness ==
                //                                         Brightness.light
                //                                     ? Colors.black54
                //                                     : Colors.white54),
                //                         left: BorderSide(
                //                             color: index == 1
                //                                 ? Theme.of(context)
                //                                             .brightness ==
                //                                         Brightness.light
                //                                     ? Colors.black45
                //                                     : Colors.white54
                //                                 : Colors.transparent),
                //                         right: BorderSide(
                //                             color: index == 1
                //                                 ? Theme.of(context)
                //                                             .brightness ==
                //                                         Brightness.light
                //                                     ? Colors.black45
                //                                     : Colors.white54
                //                                 : Colors.transparent))),
                //                 child: Padding(
                //                   padding: const EdgeInsets.all(12.0),
                //                   child: customTextNormal(
                //                       subscriptionPlans[index],
                //                       fontWeight: FontWeight.w600,
                //                       textColor:
                //                           _selectedSubscriptionPlan == index
                //                               ? AppColors.primaryColor1
                //                               : Theme.of(context).brightness ==
                //                                       Brightness.light
                //                                   ? Colors.black87
                //                                   : Colors.white70),
                //                 ),
                //               ),
                //             ),
                //           )),
                // ),
                const SizedBox(height: 8),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 24, horizontal: 28),
                  child: Column(
                    children: [
                      customTextNormal(
                        "${translation.howMuchToDonate} ${subscriptionPlans[_selectedSubscriptionPlan].toLowerCase()}?",
                        fontWeight: FontWeight.w600,
                        alignment: TextAlign.start,
                      ),
                      const SizedBox(height: 18),
                      Row(
                        children: List.generate(
                            _charityPayments.length ~/ 2,
                            (index) => Expanded(
                                  child: InkWell(
                                    onTap: () => changeDonation(index),
                                    child: AnimatedContainer(
                                      duration: Duration(milliseconds: 500),
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 2),
                                      decoration: BoxDecoration(
                                          color: _selectedDonation == index
                                              ? AppColors.primaryColor
                                              : AppColors.primaryColor
                                                  .withOpacity(0.25)),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 12),
                                        child: customTextNormal(
                                            _charityPayments[index],
                                            fontWeight: FontWeight.bold,
                                            textColor:
                                                _selectedDonation == index
                                                    ? Colors.white
                                                    : AppColors.primaryColor),
                                      ),
                                    ),
                                  ),
                                )),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: List.generate(
                            _charityPayments.length ~/ 2,
                            (index) => Expanded(
                                  child: InkWell(
                                    onTap: () => changeDonation(index + 2),
                                    child: AnimatedContainer(
                                      duration: Duration(milliseconds: 500),
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 2),
                                      decoration: BoxDecoration(
                                          color: _selectedDonation == index + 2
                                              ? AppColors.primaryColor
                                              : AppColors.primaryColor
                                                  .withOpacity(0.25)),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 12),
                                        child: customTextNormal(
                                            _charityPayments[index + 2],
                                            fontWeight: FontWeight.bold,
                                            textColor:
                                                _selectedDonation == index + 2
                                                    ? Colors.white
                                                    : AppColors.primaryColor),
                                      ),
                                    ),
                                  ),
                                )),
                      ),
                      const SizedBox(height: 28),
                      customTextNormal(AppLocalizations.of(context)!.or,
                          fontWeight: FontWeight.w600),
                      const SizedBox(height: 28),
                      TextField(
                        controller: _priceController,
                        textAlign: TextAlign.center,
                        onChanged: (value) {
                          if (_selectedDonation >= 0) {
                            setState(() {});
                            changeDonation(-1);
                          }
                        },
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            fillColor: Color(0xFFC4C4C4).withOpacity(0.34),
                            filled: true,
                            border: InputBorder.none,
                            hintText: translation.enterPriceManually),
                      ),
                      const SizedBox(height: 18),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(
                            child: customTextSmall(
                                AppLocalizations.of(context)!
                                    .wouldYouLikeToAdd25,
                                alignment: TextAlign.start,
                                fontWeight: FontWeight.w600,
                                fontSize: 12),
                          ),
                          Checkbox(
                              value: _addGiftAid,
                              activeColor: AppColors.primaryColor,
                              visualDensity: VisualDensity.compact,
                              onChanged: (value) {
                                setState(() {
                                  _addGiftAid = !_addGiftAid;
                                });
                              })
                        ],
                      ),
                      const SizedBox(height: 38),
                      MaterialButton(
                        onPressed: () {
                          // Navigate to charity payment summary screen with donation info
                          // Start with the original arguments from the URL
                          final combinedArguments = {
                            // Preserve original arguments from the URL
                            ...?widget.arguments,
                            // Add the user-selected values
                            'amount': _priceController.value.text,
                            'interval': 'one_off', // Always one-off for charity donations
                            'giftAid': _addGiftAid ? 1 : 0,
                          };

                          Navigator.of(context).pushNamed(
                            RoutePaths.charityPaymentSummaryScreen,
                            arguments: combinedArguments,
                          );
                        },
                        color: AppColors.primaryColor1,
                        minWidth: double.infinity,
                        height: 55,
                        child: customTextNormal(
                            AppLocalizations.of(context)!.continue1,
                            textColor: Colors.white,
                            fontWeight: FontWeight.w600),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}