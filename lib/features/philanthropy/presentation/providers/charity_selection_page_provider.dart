// ignore: library_prefixes
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:kiind_web/core/constants/app_colors.dart';
import 'package:kiind_web/core/constants/configs.dart';
import 'package:kiind_web/core/constants/endpoints.dart';
import 'package:kiind_web/core/constants/texts.dart';
import 'package:kiind_web/core/models/categories_model.dart';
import 'package:kiind_web/core/models/category_model.dart';
import 'package:kiind_web/core/models/charity_model.dart';
import 'package:kiind_web/core/models/sub_categories_model.dart' ;
import 'package:kiind_web/core/providers/base_provider.dart';
import 'package:kiind_web/core/router/route_paths.dart';
import 'package:kiind_web/core/util/extensions/response_extensions.dart';
import 'package:kiind_web/core/util/visual_alerts.dart'; 
import 'package:shared_preferences/shared_preferences.dart';

class CharitySelectionPageProvider extends BaseProvider {
  final TextEditingController searchController = TextEditingController();
  final FocusNode searchFocusNode = FocusNode();
  final ScrollController categoriesController = ScrollController();
  double? scrollPosition;
  final List<Map>? syncedCharities;
  int selectedCategoryIndex = 0;
  List<Charity> charities = [];
  List<Charity> searchResult = [];
  List<CategoryModel>? categories;
  Set<Charity> selectedCharities = {};
  bool hasError = false;
  bool categoriesError = false;
  bool searchError = false;
  bool isSearchMode = false;
  bool isPreFilled = false;

  var test = <Categories>[];

  Map<String, List<String>> newCategories = {};

  List<String> categoriesList = [];
  List<String> selectedList = [];
  late Map<String, List<String>> selectedSubCategories;

  late Map<String, List<String>> searchResults;

  CharitySelectionPageProvider({this.syncedCharities});

  void changeSelectedCategory(int index) async {
    selectedCategoryIndex = index;
    scrollPosition = categoriesController.offset;
    if (index == 0) {
      await getCharities();
      return;
    }

    await getCharitiesForCategory(categories![index].id);
    notifyListeners();
  }

  void toggleSelectCharity(int index, {bool isSearch = false}) {
    var charities = this.charities;
    if (isSearch) {
      charities = searchResult;
    }

    if (selectedCharities.contains(charities[index])) {
      selectedCharities.remove(charities[index]);
    } else {
      selectedCharities.add(charities[index]);
    }

    notifyListeners();
  }

  getnewCategories() async {
    loading = true;
    
      Response res = await client.get(
        Endpoints.categoriesAll,
      );
      if (res.isValid) {
        // print("categories:::::::; ${res.data["data"]}");
        var apiData = res.data['data']['data'];
        for (var v in apiData) {
          test.add(Categories.fromMap(v));
        }
        // print('Categories now ::::::::::::::${test}');
        for (Categories category in test) {
          newCategories.putIfAbsent(category.title, () {
            return category.children!
                .map((child) => child.title.toString())
                .toList();
          });
          if (category.selected == true) {
            selectedList.add(category.title);
          }
        }
        // print('Categories now ::::::::::::::${categories}');

        categoriesList = newCategories.keys.toList();

        selectedSubCategories = {for (var i in categoriesList) i: []};

        for (Categories category in test) {
          newCategories.putIfAbsent(category.title, () {
            return category.children!
                .map((child) => child.title.toString())
                .toList();
          });
          if (category.selected == true) {
            selectedList.add(category.title);
          }
          for (SubCategories subcat in category.children!) {
            if (subcat.selected == true) {
              addsubCategory(category.title, subcat.title);
            }
          }
        }
        notifyListeners();
        loading = false;
      } else {
        // ignore: avoid_print
        print("categories:::::::; ${res.errorMessage}");
      }
      notifyListeners();
    

    loading = false;
  }

  addsubCategory(key, String value) {
    selectedSubCategories[key]!.add(value);
    notifyListeners();
  }

  void unselectAll() {
    selectedCharities.removeWhere((charity) => charities.contains(charity));
    log('$selectedCharities');
    notifyListeners();
  }

  void selectAll() {
    selectedCharities.addAll(charities);
    log('$selectedCharities');
    notifyListeners();
  }

  addToSelectedList(data) {
    if (selectedList.contains(data)) {
      selectedList.remove(data);
      selectedSubCategories[data] = [];

      notifyListeners();
      return;
    }
    selectedList.add(data);
    selectedSubCategories[data]!.addAll(newCategories[data]!);
    notifyListeners();
  }

  addSubCategories(key, String value) {
    if (selectedSubCategories[key]!.contains(value)) {
      selectedSubCategories[key]!.remove(value);
      if (selectedSubCategories[key]!.isEmpty) {
        selectedList.remove(key);
      }
      notifyListeners();
      return;
    } else {
      selectedSubCategories[key]!.add(value);
      notifyListeners();
    }
  }

  void exitSearchMode() {
    isSearchMode = false;
    searchResult = [];
    searchController.clear();
    searchFocusNode.unfocus();
    notifyListeners();
  }

  bool isAnyCharitySelected() {
    return selectedCharities.any((charity) => charities.contains(charity));
  }

  void getCategories() async {
    if (loading) return;
    loading = true;

    try {
      final result = await client.get(Endpoints.categoriesList);
      if (result.statusCode == 200) {
        final List categoriesData = result.data['data'];
        categories = [
          CategoryModel(id: -1, title: 'All'),
          ...categoriesData
              .map((category) => CategoryModel.fromMap(category))
              .toList()
        ];

        print('api response :::: $categories');
        notifyListeners();

        await getCharities(forced: true);

        await getnewCategories();
      }
    } on DioError {
      categoriesError = true;
      showAlertToast('An error occurred. Please try again');
    }

    loading = false;
  }

  Future<void> getCharities({bool forced = false}) async {
    if (loading && !forced) return;
    loading = true;
    charities = [];

    try {
      final result = await client.get(Endpoints.allCharities);
      if (result.statusCode == 200) {
        final List charitiesData = result.data['data']['data'];
        charities = charitiesData
            .map((charity) => Charity.fromMap({
                  'category_title': charity['category']['title'],
                  ...charity,
                  'category_id':
                      charity['category']['parent'] ?? charity['category']['id']
                }))
            .toList();

        if (syncedCharities != null && !isPreFilled) {
          isPreFilled = true;
          for (var charity in charities) {
            for (var synced in syncedCharities!) {
              if (synced['id'] == charity.id &&
                  synced['categoryId'] == charity.categoryId) {
                selectedCharities.add(charity);
              }
            }
          }
        }
      }

      if (result.statusCode == 404) {
        charities = [];
      }
    } on DioError {
      hasError = true;
      print("error occured ");
      showAlertToast('An error occurred. Please try again');
    }

    loading = false;
  }

  Future<void> getCharitiesForCategory(int categoryId) async {
    if (loading) return;
    loading = true;
    charities = [];

    try {
      final result =
          await client.get('${Endpoints.categoryCharities}/$categoryId');
      if (result.statusCode == 200) {
        final List charitiesData = result.data['data']['data'];
        charities = charitiesData
            .map((charity) => Charity.fromMap({
                  'category_title': charity['category']['title'],
                  ...charity,
                }))
            .toList();
      }
      if (result.statusCode == 404) {
        charities = [];
      }
    } on DioError {
      hasError = true;
      showAlertToast('An error occurred. Please try again');
    }

    loading = false;
  }

  void searchCharity() async {
    if (loading) return;
    isSearchMode = true;
    loading = true;
    searchResult = [];

    try {
      final keyword = searchController.value.text;
      final result = await client.get('${Endpoints.searchCharities}/$keyword');
      if (result.statusCode == 200) {
        final List charitiesData = result.data['data']['data'];
        searchResult = charitiesData
            .map((charity) => Charity.fromMap({
                  'category_title': charity['category']['title'],
                  ...charity,
                }))
            .toList();
      }
      if (result.statusCode == 404) {
        searchResult = [];
      }
    } on DioError {
      searchError = true;
      showAlertToast('An error occurred. Please try again');
    }

    loading = false;
  }

  goToSubGroups(BuildContext context, charity) {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      Navigator.of(context).pushNamed(
        RoutePaths.subGroupsPage,
        arguments: charity,
      );
    });
  }

  enterCharity(BuildContext context, charityId) async {
    loading = true;
    final res = await client.get("${Endpoints.guestGroupFeed}/$charityId");
    if (res.isSuccessful) {
      var pageData = res.data['data'];
      // print('pageData::::::::::$pageData');
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('selectedOrganizationId', charityId);

      print(
          'selectedOrganizationId::::::::::${prefs.getString('selectedOrganizationId')}');
      loading = false;

      Navigator.of(context).pushNamed(RoutePaths.homeScreen,
          arguments: {'guestData': pageData, 'fromCharitySelection': true});
    } else {
      loading = false;
      showAlertFlash(context, "unable to login with id");
    }
  }

  showCategories(BuildContext context) async {
    await showModalBottomSheet(
      // shape: ShapeBorder.lerp(10, b, t),
      context: context,
      isScrollControlled: true,
      builder: (modalContext) {
        return Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 18,
          ),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(32),
            ),
            boxShadow: [
              BoxShadow(
                blurRadius: 25,
                spreadRadius: -10,
              ),
            ],
          ),
          child: Column(
            children: [
              Container(
                height: 4,
                width: MediaQuery.of(context).size.width * 0.3,
                margin: const EdgeInsets.only(bottom: globalPadding / 2),
                decoration: BoxDecoration(
                  color: AppColors.primaryColor,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              customTextNormal(
                'Categories',
                fontWeight: FontWeight.w600,
                // textColor:
              ),
              SingleChildScrollView(
                //  controller: scrollCtrl,
                child: ValueListenableBuilder(
                  valueListenable: loadingAsListenable,
                  builder: (context, _loading, child) {
                    return Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      alignment: WrapAlignment.start,
                      children: List.generate(categoriesList.length, (index) {
                        return Wrap(
                          spacing: 2,
                          runSpacing: 10,
                          children: [
                            // SHow Categories first

                            CategoryPill(
                              textColor:
                                  selectedList.contains(categoriesList[index])
                                      ? Theme.of(context).brightness ==
                                              Brightness.dark
                                          ? Colors.black
                                          : Colors.white
                                      : Theme.of(context).brightness ==
                                              Brightness.dark
                                          ? Colors.white
                                          : Colors.black.withOpacity(0.6),
                              categoryName: categoriesList[index],
                              elevation:
                                  selectedList.contains(categoriesList[index])
                                      ? 1
                                      : 0,
                              onTap: () {
                                addToSelectedList(categoriesList[index]);
                              },
                              pillColor:
                                  selectedList.contains(categoriesList[index])
                                      ? AppColors.welcomeGradient2
                                      : Colors.transparent,
                              shadowColor:
                                  selectedList.contains(categoriesList[index])
                                      ? Colors.grey.withOpacity(0.9)
                                      : Colors.grey.withOpacity(0.01),
                            ),
                            // show subCategories

                            ...List.generate(
                                newCategories[categoriesList[index]]!.length,
                                (valueIndex) {
                              return SubCategory(
                                  pillColor: selectedSubCategories[categoriesList[index]]!
                                          .contains(
                                              newCategories[categoriesList[index]]![
                                                  valueIndex])
                                      ? const Color(0xFFC0EFED)
                                      : Colors.transparent,
                                  textColor: selectedSubCategories[categoriesList[index]]!
                                          .contains(
                                              newCategories[categoriesList[index]]![
                                                  valueIndex])
                                      ? Colors.black.withOpacity(0.6)
                                      : Theme.of(context).brightness ==
                                              Brightness.dark
                                          ? Colors.white70
                                          : Colors.black.withOpacity(0.6),
                                  onTap: () {
                                    addSubCategories(
                                        categoriesList[index],
                                        newCategories[categoriesList[index]]![
                                            valueIndex]);
                                  },
                                  subCategoryName: newCategories[
                                      categoriesList[index]]![valueIndex],
                                  visibility: selectedList
                                      .contains(categoriesList[index]));
                            }),
                          ],
                        );
                      }),
                    );
                  },
                ),
              )
            ],
          ),
        );
      },
    );

    notifyListeners();
  }

  viewAllorganizationData(BuildContext context) async {
    loading = true;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedOrganizationId', '');
    loading = false;
    Navigator.of(context).pushNamed(RoutePaths.homeScreen,
        arguments: {'fromCharitySelection': false});
  }
}
