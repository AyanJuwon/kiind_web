import 'package:flutter/material.dart';
import 'package:kiind_web/core/constants/app_colors.dart';
import 'package:kiind_web/core/constants/texts.dart';

class CharityCategoryListItem extends StatelessWidget {
  final String label;
  final Function() onTap;
  final bool isSelected;

  const CharityCategoryListItem(
      {Key? key,
      required this.label,
      required this.onTap,
      required this.isSelected})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 8),
          child: customTextNormal(label,
              textColor: isSelected ? AppColors.primaryColor : null)),
    );
  }
}
