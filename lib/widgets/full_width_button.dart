import 'package:flutter/material.dart';
import 'package:kiind_web/core/constants/texts.dart';

class FullWidthButton extends StatelessWidget {
  final Function? onPressed;
  final String text;
  final Color color;
  final Color? textColor;
  final bool isLoading;
  final double fontSize;
  final double? elevation;
  final double? borderRadius;

  const FullWidthButton(
      {super.key,
      this.isLoading = false,
      this.fontSize = 18,
      this.textColor,
      this.elevation,
      this.borderRadius,
      required this.onPressed,
      required this.text,
      required this.color});

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      elevation: elevation,
      onPressed: isLoading || onPressed == null ? null : () => onPressed!(),
      color: color,
      disabledColor: color.withOpacity(0.4),
      minWidth: double.infinity,
      shape: RoundedRectangleBorder(
          side: const BorderSide(color: Colors.transparent, width: 0),
          borderRadius: BorderRadius.circular(borderRadius ?? 40)),
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          customTextNormal(text,
              fontSize: fontSize, textColor: textColor ?? Colors.white),
          // SizedBox(width: 48),
          Visibility(
            visible: isLoading,
            child: Container(
              decoration:
                  BoxDecoration(border: Border.all(color: Colors.transparent)),
              width: 20,
              height: 20,
              margin: const EdgeInsets.only(left: 48),
              child: const CircularProgressIndicator.adaptive(
                value: null,
                backgroundColor: Colors.white,
                strokeWidth: 3,
              ),
            ),
          )
        ],
      ),
    );
  }
}

class FlexibleButton extends StatelessWidget {
  final Function? onPressed;
  final String text;
  final Color color;
  final Color? textColor;
  final bool isLoading;
  final double fontSize;
  final double? elevation;
  final double? borderRadius;
  final double? width;

  const FlexibleButton(
      {super.key,
      this.isLoading = false,
      this.fontSize = 18,
      this.textColor,
      this.elevation,
      this.borderRadius,
      this.width,
      required this.onPressed,
      required this.text,
      required this.color});

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      elevation: elevation,
      onPressed: isLoading || onPressed == null ? null : () => onPressed!(),
      color: color,
      disabledColor: color.withOpacity(0.4),
      minWidth: width,
      shape: RoundedRectangleBorder(
          side: const BorderSide(color: Colors.transparent, width: 0),
          borderRadius: BorderRadius.circular(borderRadius ?? 40)),
      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          customTextNormal(text,
              fontSize: fontSize, textColor: textColor ?? Colors.white),
          // SizedBox(width: 48),
          Visibility(
            visible: isLoading,
            child: Container(
              decoration:
                  BoxDecoration(border: Border.all(color: Colors.transparent)),
              width: 20,
              height: 15,
              margin: const EdgeInsets.only(left: 48),
              child: const CircularProgressIndicator.adaptive(
                value: null,
                backgroundColor: Colors.white,
                strokeWidth: 3,
              ),
            ),
          )
        ],
      ),
    );
  }
}
