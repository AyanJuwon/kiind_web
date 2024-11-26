import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kiind_web/core/base_page.dart';
import 'package:kiind_web/core/constants/app_colors.dart';
import 'package:kiind_web/core/constants/texts.dart';
import 'package:kiind_web/core/models/charity_model.dart';
import 'package:kiind_web/core/models/donation_info_model.dart';
import 'package:kiind_web/features/philanthropy/presentation/pages/charity_allocation/widgets/charity_allocation_item.dart';
import 'package:kiind_web/features/philanthropy/presentation/providers/charity_allocation_page_provider.dart';
import 'package:kiind_web/widgets/full_width_button.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class CharityAllocationPage extends StatefulWidget {
  final List<Charity> selectedCharities;
  final DonationInfoModel? donationInfo;
  final int? subscriptionId;

  const CharityAllocationPage(
      {Key? key,
      required this.selectedCharities,
      required this.donationInfo,
      required this.subscriptionId})
      : super(key: key);

  @override
  _CharityAllocationPageState createState() => _CharityAllocationPageState();
}

class _CharityAllocationPageState extends State<CharityAllocationPage> {
  @override
  Widget build(BuildContext context) {
    return BasePage<CharityAllocationPageProvider>(
      child: null,
      provider:
          CharityAllocationPageProvider(charities: widget.selectedCharities),
      builder: (context, provider, child) {
        return Scaffold(
          appBar: AppBar(
            iconTheme: Theme.of(context).iconTheme,
            systemOverlayStyle: SystemUiOverlayStyle.dark,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            title: customTextNormal('Donation Options',
                textColor: Theme.of(context).textTheme.bodyLarge!.color),
            centerTitle: true,
            elevation: 1,
          ),
          body: Column(
            children: [
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Theme.of(context).colorScheme.background
                        : AppColors.lightGrey,
                    border: Border(
                        bottom: BorderSide(
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                    ? Colors.white24
                                    : Colors.black26,
                            width: 1))),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 18, horizontal: 28),
                  child: customTextNormal('Select your preferred donation pie',
                      alignment: TextAlign.center),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 18, horizontal: 18),
                child: Row(
                  children: [
                    InkWell(
                      onTap: () => Navigator.of(context).pop(),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 500),
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.primaryColor1),
                        child: Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: Icon(MdiIcons.plusThick,
                              size: 12, color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: customTextNormal(
                          '${provider.getTotalAllocations().toStringAsFixed(2)}%',
                          alignment: TextAlign.end,
                          fontWeight: FontWeight.w600),
                    )
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding:
                      const EdgeInsets.symmetric(vertical: 18, horizontal: 18),
                  child: Column(
                    children: [
                      ...List.generate(
                          provider.selectedCharities.length,
                          (index) => CharityAllocationItem(
                                charity: provider.selectedCharities[index]
                                    ['title'],
                                category: provider.selectedCharities[index]
                                    ['category_title'],
                                image: provider.selectedCharities[index]
                                    ['image'],
                                color: provider.colors[index],
                                onRemove: () {
                                  if (provider.selectedCharities.length <= 1) {
                                    Navigator.of(context).pop();
                                  }

                                  provider.removeCharity(index);
                                },
                                onUpdateValue: (value) =>
                                    provider.updateAllocation(index, value),
                                allocation: provider.selectedCharities[index]
                                    ['allocation'],
                                index: index,
                              )),
                      const SizedBox(height: 18),
                      FullWidthButton(
                        onPressed: provider.freeAllocation > 0
                            ? null
                            : () => provider.syncSelection(context,
                                widget.donationInfo, widget.subscriptionId,
                                goToPayment: true),
                        text: widget.donationInfo == null
                            ? 'Save changes'
                            : 'Donate Now',
                        color: AppColors.primaryColor,
                        borderRadius: 28,
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
