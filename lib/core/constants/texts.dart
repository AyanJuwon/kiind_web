import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Widget customTextSmall(String text,
    {TextAlign alignment = TextAlign.center,
    double fontSize = 14,
    Color? textColor,
    double? lineHeight,
    FontWeight fontWeight = FontWeight.normal,
    int maxLines = 1000}) {
  return Text(
    text,
    textAlign: alignment,
    maxLines: maxLines,
    style: GoogleFonts.notoSans().copyWith(
        decoration: null,
        fontSize: fontSize,
        height: lineHeight,
        fontWeight: fontWeight,
        color: textColor),
  );
}

Widget customTextSmaller(String text,
    {TextAlign alignment = TextAlign.center,
    double fontSize = 10,
    Color? textColor,
    double? lineHeight,
    FontWeight fontWeight = FontWeight.normal,
    int maxLines = 1000}) {
  return Text(
    text,
    textAlign: alignment,
    maxLines: maxLines,
    style: GoogleFonts.notoSans().copyWith(
        decoration: null,
        fontSize: fontSize,
        height: lineHeight,
        fontWeight: fontWeight,
        color: textColor),
  );
}

Widget customTextSmallItalics(String text,
    {TextAlign alignment = TextAlign.center,
    double fontSize = 12,
    Color? textColor,
    double? lineHeight,
    FontWeight fontWeight = FontWeight.normal,
    int maxLines = 1000}) {
  return Text(
    text,
    textAlign: alignment,
    maxLines: maxLines,
    style: GoogleFonts.notoSans().copyWith(
        decoration: null,
        fontSize: fontSize,
        height: lineHeight,
        fontWeight: fontWeight,
        fontStyle: FontStyle.italic,
        color: textColor),
  );
}

Widget customTextNormal(String text,
    {TextAlign alignment = TextAlign.center,
    double fontSize = 16,
    Color? textColor,
    double? lineHeight,
    FontWeight fontWeight = FontWeight.normal,
    TextDecoration decoration = TextDecoration.none,
    int maxLines = 1000}) {
  return Text(
    text,
    textAlign: alignment,
    overflow: TextOverflow.ellipsis,
    maxLines: maxLines,
    style: GoogleFonts.notoSans().copyWith(
      decoration: decoration,
      fontSize: fontSize,
      height: lineHeight,
      fontWeight: fontWeight,
      color: textColor,
    ),
  );
}

Widget customTextNormal2(String text,
    {TextAlign alignment = TextAlign.center,
    double fontSize = 12,
    Color? textColor,
    double? lineHeight,
    FontWeight fontWeight = FontWeight.normal,
    TextDecoration decoration = TextDecoration.none,
    int maxLines = 1000}) {
  return Text(
    text,
    textAlign: alignment,
    overflow: TextOverflow.ellipsis,
    maxLines: maxLines,
    style: GoogleFonts.notoSans().copyWith(
      decoration: decoration,
      fontSize: fontSize,
      height: lineHeight,
      fontWeight: fontWeight,
      color: textColor,
    ),
  );
}

Widget customTextHeader(String text,
    {TextAlign alignment = TextAlign.center,
    double fontSize = 18,
    Color? textColor,
    double? lineHeight,
    FontWeight fontWeight = FontWeight.bold,
    TextDecoration decoration = TextDecoration.none,
    int maxLines = 1000}) {
  return Text(
    text,
    textAlign: alignment,
    overflow: TextOverflow.ellipsis,
    maxLines: maxLines,
    style: GoogleFonts.notoSans().copyWith(
      decoration: decoration,
      fontSize: fontSize,
      height: lineHeight,
      fontWeight: fontWeight,
      color: textColor,
    ),
  );
}

Widget customTextMedium(
  String text, {
  TextAlign alignment = TextAlign.center,
  double fontSize = 18,
  Color? textColor,
  double? lineHeight,
  FontWeight fontWeight = FontWeight.normal,
  int maxLines = 1000,
}) {
  return Text(
    text,
    textAlign: alignment,
    maxLines: maxLines,
    // overflow: TextOverflow.ellipsis,
    style: GoogleFonts.notoSans().copyWith(
      fontSize: fontSize,
      height: lineHeight,
      fontWeight: fontWeight,
      color: textColor,
    ),
  );
}

Widget customTextLarge(String text,
    {TextAlign alignment = TextAlign.center,
    double fontSize = 24,
    Color? textColor,
    double? lineHeight,
    FontWeight fontWeight = FontWeight.normal,
    int maxLines = 1000}) {
  return Text(
    text,
    textAlign: alignment,
    maxLines: maxLines,
    style: GoogleFonts.notoSans().copyWith(
        fontSize: fontSize,
        height: lineHeight,
        fontWeight: fontWeight,
        color: textColor),
  );
}

Widget customTextExtraLarge(String text,
    {TextAlign alignment = TextAlign.center,
    double fontSize = 28,
    Color? textColor,
    double? lineHeight,
    FontWeight fontWeight = FontWeight.normal,
    int maxLines = 1000}) {
  return Text(
    text,
    textAlign: alignment,
    maxLines: maxLines,
    style: GoogleFonts.notoSans().copyWith(
        fontSize: fontSize,
        height: lineHeight,
        fontWeight: fontWeight,
        color: textColor),
  );
}
