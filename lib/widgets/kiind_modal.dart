// ignore_for_file: prefer_const_constructors, unused_local_variable
import 'package:flutter/material.dart';
import 'package:kiind_web/core/constants/app_colors.dart';
import 'package:kiind_web/core/constants/texts.dart';
import 'package:kiind_web/core/models/donation_info_model.dart';

const _adoptPayments = ['£5', '£10', '£20', '£50'];

class KiindDonateModal extends StatefulWidget {
  final Function(DonationInfoModel) onContinue;
  final ScrollController? controller;

  const KiindDonateModal({super.key, required this.onContinue, this.controller});

  @override
  State<KiindDonateModal> createState() => _KiindDonateModalState();
}

class _KiindDonateModalState extends State<KiindDonateModal> {
  int? selectedOption;
  int _selectedDonation = 0;
  final bool _isManual = false;
  bool _addGiftAid = false;
  late final TextEditingController _priceController;

  void changeDonation(int index) {
    setState(() {
      _selectedDonation = index;
    });
    if (index >= 0) {
      _priceController.text = _adoptPayments[index].replaceAll('£', '');
      // _priceController.text = '';
    }
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
      amount = double.parse(_adoptPayments[0].replaceAll('£', ''));
    } else {
      amount =
          double.parse(_adoptPayments[_selectedDonation].replaceAll('£', ''));
    }
    return ((amount * 25) / 100).toStringAsFixed(2);
  }

  @override
  void initState() {
    super.initState();
    _priceController =
        TextEditingController(text: _adoptPayments[0].replaceAll('£', ''));
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SizedBox(
      height: size.height * 0.9,
      child: Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 24, horizontal: 28),
                child: Column(
                  children: [
                    customTextNormal(
                        'How much do you want to donate to your Portfolio?',
                        fontWeight: FontWeight.w600,
                        alignment: TextAlign.center),
                    const SizedBox(height: 28),
                    Row(
                      children: List.generate(
                          _adoptPayments.length ~/ 2,
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
                                        vertical: 12,
                                      ),
                                      child: customTextNormal(
                                          _adoptPayments[index],
                                          fontWeight: FontWeight.bold,
                                          textColor: _selectedDonation == index
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
                          _adoptPayments.length ~/ 2,
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
                                        vertical: 12,
                                      ),
                                      child: customTextNormal(
                                          _adoptPayments[index + 2],
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
                    customTextNormal('Or', fontWeight: FontWeight.w600),
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
                          hintText: 'Enter price manually'),
                    ),
                    const SizedBox(height: 18),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                          child: customTextSmall(
                              'Would you like to add a gift aid of 25%?',
                              alignment: TextAlign.start,
                              fontWeight: FontWeight.w600,
                              fontSize: 12),
                        ),
                        // const SizedBox(width: 4),
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
                      onPressed: () => widget.onContinue(DonationInfoModel(
                          amount: _priceController.value.text,
                          interval: 'single',
                          giftAid: _addGiftAid ? 1 : 0)),
                      color: AppColors.primaryColor,
                      minWidth: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(38)),
                      child: customTextNormal('Continue',
                          textColor: Colors.white, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 48),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
