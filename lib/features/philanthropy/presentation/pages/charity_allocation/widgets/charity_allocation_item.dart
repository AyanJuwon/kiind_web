import 'package:flutter/material.dart';

import 'package:kiind_web/core/constants/texts.dart';

class CharityAllocationItem extends StatelessWidget {
  final String charity;
  final String category;
  final Function() onRemove;
  final Function(double value) onUpdateValue;
  final double allocation;
  final int index;
  final String? image;

  final Color color;

  const CharityAllocationItem(
      {super.key,
      required this.charity,
      required this.category,
      required this.onRemove,
      required this.onUpdateValue,
      required this.allocation,
      required this.index,
      required this.color,
      this.image});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        children: [
          Row(
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    customTextNormal(charity,
                        fontWeight: FontWeight.w600,
                        alignment: TextAlign.start),
                    // const SizedBox(height: 4),
                    customTextSmall(category,
                        fontSize: 12, alignment: TextAlign.start)
                  ],
                ),
              ),
              const SizedBox(width: 12),
              InkWell(
                onTap: onRemove,
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.4),
                      shape: BoxShape.circle),
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.close,
                      size: 14,
                      color: Colors.redAccent,
                    ),
                  ),
                ),
              )
            ],
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: SliderTheme(
                  data: SliderThemeData(
                      thumbShape: const RoundSliderThumbShape(
                        enabledThumbRadius: 8,
                      ),
                      trackHeight: 2,
                      thumbColor: color,
                      activeTrackColor: color,
                      inactiveTrackColor: color.withOpacity(0.2)),
                  child: Slider(
                    value: allocation,
                    min: 0,
                    max: 100,
                    divisions: 100,
                    onChanged: onUpdateValue,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              customTextSmall('${allocation.toStringAsFixed(2)}%',
                  fontWeight: FontWeight.w600)
            ],
          )
        ],
      ),
    );
  }
}
