 /* --Light Theme -- */
import 'package:flutter/material.dart';
import 'package:paysync/src/constants/colors.dart';
import 'package:paysync/src/constants/sizes.dart';

class TElevatedButtonTheme {
   TElevatedButtonTheme._();
static final lightElevatedButtonTheme = ElevatedButtonThemeData(
   style: ElevatedButton.styleFrom(
    elevation: 0,
    shape: RoundedRectangleBorder(),
    foregroundColor: tWhiteColor,
    backgroundColor: tSecondaryColor,
    side: BorderSide (color: tSecondaryColor),
    padding: EdgeInsets.symmetric (vertical: tButtonHeight),
      )

); // ElevatedButtonThemeData
/* --Dark Theme--*/
static final darkElevatedButtonTheme =ElevatedButtonThemeData(
   style: ElevatedButton.styleFrom(
    elevation: 0,
    shape: RoundedRectangleBorder(),
    foregroundColor: tSecondaryColor,
    backgroundColor: tWhiteColor,
    side: BorderSide (color: tSecondaryColor),
    padding: EdgeInsets.symmetric (vertical: tButtonHeight),
      )

); // ElevatedButtonThemeData
}