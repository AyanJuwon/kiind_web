import 'package:flutter/material.dart';
import 'package:kiind_web/core/constants/texts.dart';
import 'package:kiind_web/core/util/extensions/buildcontext_extensions.dart';
import 'package:oktoast/oktoast.dart';

void showAlertFlash(
  BuildContext context,
  String message, {
  Function? onClose,
  bool showIcon = false,
  Color? background,
  Color? textColor,
  Duration duration = const Duration(seconds: 7),
}) {
  // Using showToastWidget to show custom toast with an optional icon
  showToastWidget(
    Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      decoration: BoxDecoration(
        color: background ?? context.theme.backgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showIcon)
            Icon(
              Icons.check_circle,
              color: context.theme.textTheme.bodyText1?.color,
            ),
          SizedBox(width: 8), // Space between icon and text
          customTextSmall(
            message,
            textColor: textColor ?? context.theme.textTheme.bodyText1?.color,
            alignment: TextAlign.start,
          ),
        ],
      ),
    ),
    duration: duration, // Duration for how long the toast should appear
    position: ToastPosition.top, // Position of the toast (top by default)
  );

  // Optional: Trigger the onClose callback after the duration
  if (onClose != null) {
    Future.delayed(duration, () => onClose());
  }
}

void showAlertToast(String message, {bool long = true}) {
  showToast(
    message,
    duration: long ? Duration(seconds: 3) : Duration(seconds: 1),
    position: ToastPosition.bottom,
  );
}
