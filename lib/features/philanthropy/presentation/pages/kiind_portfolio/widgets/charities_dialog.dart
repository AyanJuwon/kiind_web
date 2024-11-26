import 'package:flutter/material.dart';

class KiindPortfolioCharitiesDialog extends StatelessWidget {
  const KiindPortfolioCharitiesDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      width: size.width * 0.2,
      height: size.height * 0.2,
      color: Colors.white,
    );
  }
}
