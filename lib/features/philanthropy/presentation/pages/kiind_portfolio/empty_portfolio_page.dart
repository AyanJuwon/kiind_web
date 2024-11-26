import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kiind_web/core/constants/app_colors.dart';
import 'package:kiind_web/core/constants/texts.dart';
import 'package:kiind_web/core/router/route_paths.dart';
import 'package:kiind_web/widgets/full_width_button.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EmptyKiindPortfolioPage extends StatelessWidget {
  const EmptyKiindPortfolioPage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final translation = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        iconTheme: Theme.of(context).iconTheme,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: customTextNormal(translation!.myKiindPortfolio,
            textColor: Theme.of(context).textTheme.bodyLarge!.color),
        centerTitle: true,
        elevation: 1,
      ),
      body: Center(
        child: Stack(
          children: [
            Center(
              child: customTextNormal(translation.youHaveNoKiindPortfolio),
            ),
            Positioned(
              bottom: 20,
              left: size.width * 0.1,
              right: size.width * 0.1,
              child: FullWidthButton(
                  onPressed: () async {
                    await Navigator.of(context)
                        .pushNamed(RoutePaths.charitySelectionScreen);

                    Navigator.of(context)
                        .pushReplacementNamed(RoutePaths.kiindPortfolioScreen);
                  },
                  text: translation.createKiindPortfolio,
                  color: AppColors.primaryColor),
            )
          ],
        ),
      ),
    );
  }
}
