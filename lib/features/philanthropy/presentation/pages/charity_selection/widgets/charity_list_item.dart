import 'package:flutter/material.dart';
import 'package:kiind_web/core/constants/app_colors.dart';
import 'package:kiind_web/core/constants/texts.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class CharityListItem extends StatelessWidget {
  final String label;
  final bool isSelected;
  final String? image;
  final Function() onToggle;

  const CharityListItem(
      {Key? key,
      required this.label,
      required this.isSelected,
      required this.onToggle,
      this.image})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Builder(builder: (context) {
            if (image == null) {
              return Container(
                width: 58,
                height: 58,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    image: const DecorationImage(
                        image: AssetImage('assets/icons/app_icon.png'),
                        fit: BoxFit.contain)),
              );
            }

            return Container(
              width: 58,
              height: 58,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  image: DecorationImage(
                      image: NetworkImage(image!), fit: BoxFit.contain)),
            );
          }),
          const SizedBox(width: 12),
          Expanded(
            child: customTextNormal(label, alignment: TextAlign.start),
          ),
          const SizedBox(width: 12),
          InkWell(
            onTap: onToggle,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color:
                    isSelected ? AppColors.primaryColor1 : AppColors.lightGrey,
              ),
              child: Padding(
                padding: const EdgeInsets.all(6.0),
                child: Icon(
                  isSelected ? MdiIcons.minusThick : MdiIcons.plusThick,
                  size: 12,
                  color: isSelected ? Colors.white : Colors.black45,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
