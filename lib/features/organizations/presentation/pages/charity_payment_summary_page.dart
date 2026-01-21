import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kiind_web/core/base_page.dart';
import 'package:kiind_web/core/constants/app_colors.dart';
import 'package:kiind_web/core/constants/texts.dart';
import 'package:kiind_web/core/models/charity_donation_type_model.dart';
import 'package:kiind_web/core/models/payment_detail.dart';
import 'package:kiind_web/core/models/payment_method.dart';
import 'package:kiind_web/core/util/extensions/buildcontext_extensions.dart';
import 'package:kiind_web/core/util/extensions/num_extentions.dart';
import 'package:kiind_web/features/organizations/presentation/providers/charity_payment_summary_provider.dart';

class CharityPaymentSummaryPage extends StatefulWidget {
  const CharityPaymentSummaryPage({Key? key}) : super(key: key);

  @override
  _CharityPaymentSummaryPageState createState() =>
      _CharityPaymentSummaryPageState();
}

class _CharityPaymentSummaryPageState extends State<CharityPaymentSummaryPage> {
  bool get _isDarkMode => Theme.of(context).brightness == Brightness.dark;

  Color get _backgroundColor => Theme.of(context).scaffoldBackgroundColor;

  Color get _cardColor => _isDarkMode ? Colors.grey[850]! : Colors.white;

  Color get _borderColor => _isDarkMode ? Colors.grey[700]! : Colors.grey[200]!;

  Color get _labelColor => _isDarkMode ? Colors.grey[400]! : Colors.grey[600]!;

  Color get _valueColor => _isDarkMode ? Colors.white : Colors.black87;

  Color get _titleColor =>
      Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black;

  SystemUiOverlayStyle get _systemOverlayStyle =>
      _isDarkMode ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark;

  @override
  Widget build(BuildContext context) {
    return BasePage<CharityPaymentSummaryProvider>(
      child: null,
      provider: CharityPaymentSummaryProvider(),
      builder: (context, provider, child) {
        return ValueListenableBuilder<bool>(
          valueListenable: provider.processingPayment,
          builder: (context, _processing, child) {
            return Scaffold(
              backgroundColor: _backgroundColor,
              appBar: AppBar(
                iconTheme: Theme.of(context).iconTheme,
                systemOverlayStyle: _systemOverlayStyle,
                backgroundColor: _backgroundColor,
                title: _processing
                    ? null
                    : Text(
                        'Payment',
                        style: TextStyle(
                          color: _titleColor,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                centerTitle: true,
                leading: _processing
                    ? const Offstage()
                    : IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () => Navigator.pop(context),
                      ),
                elevation: 0,
              ),
              body: provider.loading
                  ? const Center(child: CircularProgressIndicator())
                  : ValueListenableBuilder<PaymentDetail?>(
                      valueListenable: provider.paymentDetail,
                      builder: (context, _detail, child) {
                        return SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 16),

                                // Funds Amount Row
                                _buildInfoRow(
                                  'Funds Amount :',
                                  '£${(_detail?.amounts?.userSubmittedAmount ?? 0).leanString}',
                                  valueColor: AppColors.primaryColor,
                                  valueFontWeight: FontWeight.w600,
                                ),

                                const SizedBox(height: 20),

                                // Donation Type Dropdown
                                if (provider.donationTypes.value.isNotEmpty)
                                  _buildDonationTypeDropdown(provider),

                                const SizedBox(height: 20),

                                // Donor Details Card
                                _buildDetailsCard(
                                  children: [
                                    _buildInfoRow(
                                      'Donor :',
                                      provider.model?.name ?? 'N/A',
                                    ),
                                    const SizedBox(height: 12),
                                    _buildInfoRow(
                                      'Amount :',
                                      '£${(_detail?.amounts?.userSubmittedAmount ?? 0).leanString}${provider.isSub ? (' ' + provider.interval!) : ''}',
                                    ),
                                    const SizedBox(height: 12),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Method :',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: _labelColor,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        Expanded(
                                          child: ValueListenableBuilder<
                                              Map<int, PaymentMethod>>(
                                            valueListenable:
                                                provider.paymentMethods,
                                            builder: (context, paymentMethods,
                                                child) {
                                              if (paymentMethods.isEmpty) {
                                                return const SizedBox(
                                                  width: 20,
                                                  height: 20,
                                                  child:
                                                      CircularProgressIndicator(
                                                    strokeWidth: 2,
                                                  ),
                                                );
                                              }
                                              return DropdownButtonFormField<
                                                  PaymentMethod>(
                                                value: provider
                                                    .selectedPaymentMethod,
                                                dropdownColor: _cardColor,
                                                decoration: InputDecoration(
                                                  contentPadding:
                                                      const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 16,
                                                          vertical: 12),
                                                  border: InputBorder.none,
                                                  hintText:
                                                      'Select payment method',
                                                  hintStyle: TextStyle(
                                                    color: _labelColor,
                                                    fontSize: 14,
                                                  ),
                                                ),
                                                icon: Icon(
                                                  Icons.keyboard_arrow_down,
                                                  color: _labelColor,
                                                ),
                                                isExpanded: true,
                                                items: paymentMethods.values
                                                    .map((method) {
                                                  return DropdownMenuItem<
                                                      PaymentMethod>(
                                                    value: method,
                                                    child: Text(
                                                      method.label,
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        color: _valueColor,
                                                      ),
                                                    ),
                                                  );
                                                }).toList(),
                                                onChanged:
                                                    (PaymentMethod? newValue) {
                                                  if (newValue != null) {
                                                    provider.selectedPaymentMethod =
                                                        newValue;
                                                    provider
                                                        .onPaymentMethodSelected(
                                                            context);
                                                  }
                                                },
                                              );
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 24),

                                // Service Charge Header
                                Center(
                                  child: Text(
                                    'Service Charge',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: _labelColor,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 16),

                                // Service Charges Card
                                _buildDetailsCard(
                                  children: [
                                    ..._buildChargesRows(_detail),
                                  ],
                                ),

                                const SizedBox(height: 20),

                                // Total Amount
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    '£ ${(_detail?.amounts?.userSubmittedAmount ?? 0).leanString}',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: _valueColor,
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 32),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
              bottomNavigationBar: _buildPayButton(provider),
            );
          },
        );
      },
    );
  }

  Widget _buildInfoRow(
    String label,
    String value, {
    Color? valueColor,
    FontWeight? valueFontWeight,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: _labelColor,
            fontWeight: FontWeight.w400,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            color: valueColor ?? _valueColor,
            fontWeight: valueFontWeight ?? FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildDonationTypeDropdown(CharityPaymentSummaryProvider provider) {
    return ValueListenableBuilder<CharityDonationType?>(
      valueListenable: provider.selectedDonationType,
      builder: (context, selectedType, child) {
        return Container(
          decoration: BoxDecoration(
            color: _cardColor,
            border: Border.all(
              color: _borderColor,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButtonFormField<CharityDonationType>(
            value: selectedType,
            dropdownColor: _cardColor,
            decoration: InputDecoration(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              border: InputBorder.none,
              hintText: 'Donation type',
              hintStyle: TextStyle(
                color: _labelColor,
                fontSize: 14,
              ),
            ),
            icon: Icon(
              Icons.keyboard_arrow_down,
              color: _labelColor,
            ),
            isExpanded: true,
            items: provider.donationTypes.value.map((type) {
              return DropdownMenuItem<CharityDonationType>(
                value: type,
                child: Text(
                  type.title ?? 'Unknown',
                  style: TextStyle(
                    fontSize: 14,
                    color: _valueColor,
                  ),
                ),
              );
            }).toList(),
            onChanged: (CharityDonationType? newValue) {
              provider.selectedDonationType.value = newValue;
              provider.notifyListeners();
            },
          ),
        );
      },
    );
  }

  Widget _buildDetailsCard({required List<Widget> children}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: _borderColor,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }

  List<Widget> _buildChargesRows(PaymentDetail? detail) {
    List<Widget> rows = [];
    List<Breakdown>? charges = detail?.charges?.breakdown ?? [];

    for (int i = 0; i < charges.length; i++) {
      final charge = charges[i];
      rows.add(
        _buildInfoRow(
          charge.name ?? '',
          '£ ${(double.tryParse(charge.amount ?? '') ?? 0).leanString}',
        ),
      );
      if (i < charges.length - 1) {
        rows.add(const SizedBox(height: 12));
      }
    }

    // Add "Pay to Campaign service" row (amount going to organization)
    if (rows.isNotEmpty) {
      rows.add(const SizedBox(height: 12));
    }
    rows.add(
      _buildInfoRow(
        'Pay to Campaign service',
        '£ ${(detail?.netCost ?? 0).leanString}',
      ),
    );

    return rows;
  }

  Widget _buildPayButton(CharityPaymentSummaryProvider provider) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 24,
        horizontal: 20,
      ),
      decoration: BoxDecoration(
        color: _backgroundColor,
        boxShadow: [
          BoxShadow(
            color: _isDarkMode
                ? Colors.black.withOpacity(0.3)
                : Colors.grey.withOpacity(0.1),
            spreadRadius: 0,
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: () {
              // Check if donation type is selected before proceeding
              if (provider.donationTypes.value.isNotEmpty &&
                  provider.selectedDonationType.value == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please select a donation type'),
                    backgroundColor: Colors.red,
                  ),
                );
                return;
              }
              // Check if payment method is selected
              if (provider.method == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please select a payment method'),
                    backgroundColor: Colors.red,
                  ),
                );
                return;
              }

              provider.launchGateway(context, selectedMethod: provider.method);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              'Pay Now',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
