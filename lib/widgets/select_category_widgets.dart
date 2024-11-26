import 'package:flutter/material.dart';
import 'package:kiind_web/core/constants/app_colors.dart';
import 'package:kiind_web/core/constants/texts.dart';

class CategoryPill extends StatelessWidget {
  final Color pillColor;
  final Color textColor;
  final Color shadowColor;
  final double elevation;
  final VoidCallback onTap;
  final String categoryName;
  const CategoryPill(
      {super.key,
      required this.pillColor,
      required this.categoryName,
      required this.onTap,
      required this.textColor,
      required this.elevation,
      required this.shadowColor});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: PhysicalModel(
        elevation: elevation,
        shadowColor: shadowColor,
        borderRadius: BorderRadius.circular(40),
        color: Colors.transparent,
        child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                  width: 0.5,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white54
                      : AppColors.primaryColor),
              borderRadius: BorderRadius.circular(40),
              color: pillColor,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              child: customTextNormal(categoryName, textColor: textColor),
            )),
      ),
    );
  }
}

class SubCategory extends StatelessWidget {
  final Color pillColor;
  final Color textColor;
  final VoidCallback onTap;
  final String subCategoryName;
  final bool visibility;
  const SubCategory(
      {super.key,
      required this.pillColor,
      required this.textColor,
      required this.onTap,
      required this.subCategoryName,
      required this.visibility});

  @override
  Widget build(BuildContext context) {
    return Visibility(
        visible: visibility,
        child: InkWell(
            onTap: onTap,
            child: PhysicalModel(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(40),
                child: Container(
                  decoration: BoxDecoration(
                    border:
                        Border.all(width: 0.5, color: const Color(0xFFC0EFED)),
                    borderRadius: BorderRadius.circular(40),
                    color: pillColor,
                  ),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
                    child: customTextNormal(
                      subCategoryName,
                      textColor: textColor,
                    ),
                  ),
                ))));
  }
}

// #TODO : iMPLEMENT SEARCH FEATURE NEXT, SEARCH WILL RETURN THE CATEGORY EVE IF A SUB CATEGORY IS SEARCHED FOR

// ignore: unused_element
class ItemBadge extends StatelessWidget {
  final Color color;
  final IconData? icon;
  final Widget? iconWidget;

  const ItemBadge({super.key, required this.color, this.icon, this.iconWidget});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: Builder(builder: (context) {
          if (icon != null) {
            return Icon(
              icon,
              size: 20,
              color: Colors.white,
            );
          }

          return iconWidget!;
        }),
      ),
    );
  }
}
