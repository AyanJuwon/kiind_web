import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kiind_web/core/base_page.dart';
import 'package:kiind_web/core/constants/app_colors.dart';
import 'package:kiind_web/core/constants/texts.dart';
import 'package:kiind_web/core/models/donation_info_model.dart';
import 'package:kiind_web/core/router/route_paths.dart';
import 'package:kiind_web/features/philanthropy/presentation/pages/charity_selection/widgets/charity_category_list_item.dart';
import 'package:kiind_web/features/philanthropy/presentation/pages/charity_selection/widgets/charity_list_item.dart';
import 'package:kiind_web/features/philanthropy/presentation/pages/charity_selection/widgets/charity_search_view.dart';
import 'package:kiind_web/features/philanthropy/presentation/providers/charity_selection_page_provider.dart';
import 'package:kiind_web/widgets/full_width_button.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class CharitySelectionPage extends StatefulWidget {
  final DonationInfoModel? donationInfo;
  final List<Map>? syncedCharities;
  final int? subscriptionId;

  const CharitySelectionPage(
      {super.key,
      required this.donationInfo,
      this.syncedCharities,
      this.subscriptionId});

  @override
  _CharitySelectionPageState createState() => _CharitySelectionPageState();
}

class _CharitySelectionPageState extends State<CharitySelectionPage> {
  @override
  Widget build(BuildContext context) {
    return BasePage<CharitySelectionPageProvider>(
      child: null,
      provider:
          CharitySelectionPageProvider(syncedCharities: widget.syncedCharities),
      builder: (context, provider, child) {
        if (provider.categoriesController.hasClients &&
            provider.scrollPosition != null) {
          print(provider.scrollPosition!);
          provider.categoriesController.jumpTo(provider.scrollPosition!);
        }

        if (!provider.loading &&
            provider.categories == null &&
            !provider.categoriesError) {
          provider.getCategories();
        }

        return WillPopScope(
          onWillPop: () async {
            if (provider.isSearchMode) {
              provider.exitSearchMode();
              return false;
            }
            return true;
          },
          child: Scaffold(
            appBar: AppBar(
              iconTheme: Theme.of(context).iconTheme,
              systemOverlayStyle: SystemUiOverlayStyle.dark,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              title: customTextNormal('Related Charities',
                  textColor: Theme.of(context).textTheme.bodyLarge!.color),
              centerTitle: true,
              elevation: 0,
            ),
            body: Column(
              children: [
                Container(
                  constraints: const BoxConstraints(maxHeight: 58),
                  decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          spreadRadius: 1,
                          blurRadius: 1,
                          offset: const Offset(0, 3),
                        )
                      ]),
                  child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 18, horizontal: 8),
                      child: ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        controller: provider.categoriesController,
                        itemCount: (provider.loading ||
                                provider.categoriesError ||
                                provider.categories == null)
                            ? 0
                            : provider.categories!.length,
                        itemBuilder: (context, index) {
                          if (index == 0) {
                            return CharityCategoryListItem(
                              label: 'All',
                              onTap: () =>
                                  provider.changeSelectedCategory(index),
                              isSelected:
                                  provider.selectedCategoryIndex == index,
                            );
                          }

                          // index -= 1;
                          return CharityCategoryListItem(
                            // label: provider.categories![index].title,
                            label: provider.categories![index].title,
                            onTap: () => provider.changeSelectedCategory(index),
                            isSelected: provider.selectedCategoryIndex == index,
                          );
                        },
                      )
                      // Builder(
                      //   builder: (context) {
                      //     return ListView.builder(
                      //       physics: const BouncingScrollPhysics(),
                      //       scrollDirection: Axis.horizontal,
                      //       controller: provider.categoriesController,
                      //       itemCount: (
                      //         provider.loading
                      //         || provider.categoriesError
                      //         || provider.categories == null
                      //       ) ? 0 : provider.categories!.length,
                      //       itemBuilder: (context, index) {
                      //         if (index == 0) {
                      //           return CharityCategoryListItem(
                      //             label: 'All',
                      //             onTap: () => provider.changeSelectedCategory(index),
                      //             isSelected: provider.selectedCategoryIndex == index,
                      //           );
                      //         }

                      //         // index -= 1;
                      //         return CharityCategoryListItem(
                      //           label: provider.categories![index].title,
                      //           onTap: () => provider.changeSelectedCategory(index),
                      //           isSelected: provider.selectedCategoryIndex == index,
                      //         );
                      //       },
                      //     );
                      //   }
                      // ),
                      ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 28, horizontal: 18),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? Theme.of(context)
                                            .colorScheme
                                            .surface
                                        : AppColors.lightGrey,
                                    borderRadius: BorderRadius.circular(12)),
                                child: TextField(
                                  controller: provider.searchController,
                                  focusNode: provider.searchFocusNode,
                                  textAlign: TextAlign.center,
                                  onSubmitted: (value) {
                                    if (value.isEmpty) {
                                      provider.exitSearchMode();
                                      return;
                                    }
                                    provider.searchCharity();
                                  },
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    filled: false,
                                    hintText: 'Search all charities',
                                  ),
                                ),
                              ),
                            ),
                            if (provider.isSearchMode)
                              const SizedBox(width: 12),
                            if (provider.isSearchMode)
                              InkWell(
                                splashColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                onTap: () {
                                  provider.exitSearchMode();
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.redAccent.withOpacity(0.8),
                                      shape: BoxShape.circle),
                                  child: const Padding(
                                    padding: EdgeInsets.all(4.0),
                                    child: Icon(
                                      Icons.close,
                                      size: 18,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              )
                          ],
                        ),
                        const SizedBox(height: 18),
                        Expanded(
                          child: Builder(builder: (context) {
                            if (provider.hasError) {
                              return Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    customTextNormal('Failed to get Charities'),
                                    TextButton(
                                        onPressed: () =>
                                            provider.getCharities(),
                                        child: customTextNormal('Retry'))
                                  ],
                                ),
                              );
                            }
                            if (provider.charities.isEmpty &&
                                !provider.isSearchMode) {
                              return Center(
                                child: customTextNormal(
                                    'No Charities found for this category'),
                              );
                            }

                            if (provider.isSearchMode) {
                              return CharitySearchView(
                                keyword: provider.searchController.value.text,
                                charities: provider.searchResult,
                              );
                            }

                            return Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: customTextNormal('All selections',
                                          alignment: TextAlign.start),
                                    ),
                                    const SizedBox(width: 12),
                                    InkWell(
                                      onTap: () {
                                        if (!provider.isAnyCharitySelected()) {
                                          provider.selectAll();
                                        } else {
                                          provider.unselectAll();
                                        }
                                      },
                                      child: AnimatedContainer(
                                        duration:
                                            const Duration(milliseconds: 500),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color:
                                              !provider.isAnyCharitySelected()
                                                  ? AppColors.lightGrey
                                                  : AppColors.primaryColor1,
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(6.0),
                                          child: Icon(
                                            !provider.isAnyCharitySelected()
                                                ? MdiIcons.plusThick
                                                : MdiIcons.minusThick,
                                            size: 12,
                                            color:
                                                !provider.isAnyCharitySelected()
                                                    ? Colors.black45
                                                    : Colors.white,
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                const SizedBox(height: 18),
                                Expanded(
                                  child: ListView.builder(
                                      physics: const BouncingScrollPhysics(),
                                      itemCount: provider.charities.length,
                                      itemBuilder: (context, index) {
                                        return CharityListItem(
                                          label:
                                              provider.charities[index].title,
                                          // isSelected: !provider.unselectedCharities.contains(index),
                                          isSelected: provider.selectedCharities
                                              .contains(
                                                  provider.charities[index]),
                                          image: provider
                                              .charities[index].image_url,
                                          onToggle: () => provider
                                              .toggleSelectCharity(index),
                                        );
                                      }),
                                ),
                                const SizedBox(height: 18),
                                FullWidthButton(
                                  onPressed: provider.selectedCharities.isEmpty
                                      ? null
                                      : () {
                                          Navigator.of(context).pushNamed(
                                              RoutePaths
                                                  .charityAllocationScreen,
                                              arguments: {
                                                'selectedCharities': provider
                                                    .selectedCharities
                                                    .toList(),
                                                'donationInfo':
                                                    widget.donationInfo
                                              });
                                        },
                                  text: 'Continue',
                                  color: AppColors.primaryColor,
                                  borderRadius: 28,
                                ),
                              ],
                            );
                          }),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
