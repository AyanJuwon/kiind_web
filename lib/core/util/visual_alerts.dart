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
  // Using showAlertToastWidget to show custom toast with an optional icon
  showToastWidget(
    Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      decoration: BoxDecoration(
        color: background ?? context.theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showIcon)
            Icon(
              Icons.check_circle,
              color: context.theme.textTheme.bodyLarge?.color,
            ),
          const SizedBox(width: 8), // Space between icon and text
          customTextSmall(
            message,
            textColor: textColor ?? context.theme.textTheme.bodyLarge?.color,
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
    duration: long ? const Duration(seconds: 3) : const Duration(seconds: 1),
    position: ToastPosition.bottom,
  );
}
