import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const kPrimaryColor = Color(0XFFDE550D);
const kBackgroundColor = Color(0xFFFAF3F0);

var kLogoTextStyle = GoogleFonts.rochester(
  color: kPrimaryColor,
  fontSize: 128.0,
  shadows: [
    const Shadow(
        offset: Offset(1.0, 3.0), blurRadius: 6.0, color: Colors.black54)
  ],
);
var kTitleTextStyle = GoogleFonts.rochester(
  color: kPrimaryColor,
  fontSize: 36.0,
  shadows: [
    const Shadow(
        offset: Offset(0.0, 2.0), blurRadius: 6.0, color: Colors.black54)
  ],
);

var kFoodTextStyle = GoogleFonts.rochester(
  color: Colors.white,
  fontSize: 34.0,
  shadows: [
    const Shadow(
        offset: Offset(0.0, 2.0), blurRadius: 6.0, color: Colors.black54)
  ],
);

var kNameTextStyle = GoogleFonts.rochester(
  color: Colors.black,
  fontSize: 48.0,
  shadows: [
    const Shadow(
        offset: Offset(0.0, 2.0), blurRadius: 6.0, color: Colors.black54)
  ],
);

var kHeadingTextStyle = GoogleFonts.robotoSlab(
  fontSize: 24.0,
);
var kPriceTextStyle = GoogleFonts.robotoMono(
  fontSize: 24.0,
  color: Colors.white,
);
var kCartPriceTextStyle = GoogleFonts.robotoMono(
  fontSize: 24.0,
  color: Colors.black,
);

const kAppBarIconThemeData = IconThemeData(color: kPrimaryColor, size: 30.0);

var kBottomSheetTextStyle = GoogleFonts.robotoCondensed(
  color: Colors.white,
  fontSize: 38,
  fontWeight: FontWeight.w400,
  height: 0.01,
  letterSpacing: 12,
);

var kCartOrderTextStyle = GoogleFonts.rochester(
  color: const Color(0xFF262626),
  fontSize: 34,
  fontWeight: FontWeight.w400,
);
