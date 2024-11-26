import 'package:flutter/material.dart';
import 'package:kiind_web/core/constants/texts.dart';

class KiindPortfolioItem extends StatelessWidget {
  final String label;
  final double allocation;
  final Color color;
  final List<String> charities;

  const KiindPortfolioItem(
      {Key? key,
      required this.label,
      required this.allocation,
      required this.color,
      required this.charities})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: customTextNormal('All selected charities',
                          textColor: color,
                          fontWeight: FontWeight.bold,
                          alignment: TextAlign.start),
                      content: SizedBox(
                        width: size.width * 0.8,
                        child: Scrollbar(
                          child: ListView.builder(
                              physics: const BouncingScrollPhysics(),
                              itemCount: charities.length,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8),
                                  child: customTextNormal(charities[index],
                                      alignment: TextAlign.start),
                                );
                              }),
                        ),
                      ),
                    );
                  });
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                customTextNormal(label, alignment: TextAlign.start),
                const SizedBox(width: 4),
                const Icon(
                  Icons.arrow_drop_down,
                  size: 20,
                  color: Colors.redAccent,
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Container(
                height: 4,
                width: (size.width - 120) * (allocation / 100),
                decoration: BoxDecoration(
                    color: color, borderRadius: BorderRadius.circular(4)),
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
