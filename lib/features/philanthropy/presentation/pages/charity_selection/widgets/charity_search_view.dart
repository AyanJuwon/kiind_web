import 'package:flutter/material.dart';
import 'package:kiind_web/core/constants/texts.dart';
import 'package:kiind_web/core/models/charity_model.dart';
import 'package:kiind_web/features/philanthropy/presentation/pages/charity_selection/widgets/charity_list_item.dart';
import 'package:kiind_web/features/philanthropy/presentation/providers/charity_selection_page_provider.dart';
import 'package:provider/provider.dart';

class CharitySearchView extends StatelessWidget {
  final String keyword;
  final List<Charity> charities;

  const CharitySearchView(
      {super.key, required this.keyword, required this.charities});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CharitySelectionPageProvider>(context);

    if (charities.isEmpty) {
      return Center(
        child: customTextNormal('No Charities found for "$keyword"'),
      );
    }

    return ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: charities.length,
        itemBuilder: (context, index) {
          return CharityListItem(
            label: charities[index].title,
            isSelected: provider.selectedCharities.contains(charities[index]),
            onToggle: () => provider.toggleSelectCharity(index, isSearch: true),
          );
        });
  }
}
