import 'package:flutter/material.dart';
import 'package:kiind_web/core/constants/app_colors.dart';

class ShareButton extends StatelessWidget {
  final bool shareBusy;
  final Color? color;
  final Color themeColor;
  final Function() share;

  const ShareButton({
    super.key,
    required this.share,
    this.shareBusy = false,
    this.themeColor = AppColors.primaryColor,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Visibility(
          visible: !shareBusy,
          maintainState: true,
          maintainSize: true,
          maintainAnimation: true,
          child: Row(
            children: [
              IconButton(
                onPressed: share,
                icon: Icon(
                  Icons.share_outlined,
                  color: color ??
                      (Theme.of(context).brightness == Brightness.light
                          ? Colors.black54
                          : Colors.white60),
                  size: 20,
                ),
              ),
              // const SizedBox(
              //     width: 6),
              // customTextNormal(
              //   '32',
              //   textColor: Theme.of(
              //                   context)
              //               .brightness ==
              //           Brightness
              //               .light
              //       ? Colors.black54
              //       : Colors
              //           .white60,
              // )
            ],
          ),
        ),
        Positioned.fill(
          child: Visibility(
            visible: shareBusy,
            maintainState: true,
            maintainSize: true,
            maintainAnimation: true,
            child: const Align(
              alignment: Alignment.center,
              child: SizedBox(
                height: 18,
                width: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.primaryColor,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
