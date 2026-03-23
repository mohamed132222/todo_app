import 'package:flutter/material.dart';

class MyTheme {
  static const Color primaryColor = Color(0xff5D9CEC);
  static const Color backgroundPrimaryColor = Color(0xffDFECDB);
  static const Color backgroundPrimaryDarkColor = Color(0xff060E1E);
  static const Color whiteColor = Color(0xffFFFFFF);
  static const Color blackColor = Color(0xff363636);
  static const Color greyColor = Color(0xff808080);
  static const Color redColor = Color(0xffEC4B4B);
  static const Color greenColor = Color(0xff61E757);
  static const Color darkColor = Color(0xff141922);
  static ThemeData lightTheme = ThemeData(
    primaryColor: primaryColor,
    scaffoldBackgroundColor: backgroundPrimaryColor,

    appBarTheme: AppBarTheme(backgroundColor: primaryColor),

    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: whiteColor,
      selectedItemColor: primaryColor,
      unselectedItemColor: greyColor,
    ),
    textTheme: TextTheme(
      titleLarge: TextStyle(
        color: blackColor,
        fontSize: 18,
        fontWeight: FontWeight.w700,
      ),
      titleMedium: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w400,
        color: blackColor,
      ),
      titleSmall: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: blackColor,
      ),
    ),
  );
  static ThemeData darkTheme = ThemeData(
    primaryColor: darkColor,
    scaffoldBackgroundColor: backgroundPrimaryDarkColor,

    appBarTheme: AppBarTheme(backgroundColor: primaryColor),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: darkColor,
      selectedItemColor: primaryColor,
      unselectedItemColor: greyColor,
    ),
    textTheme: TextTheme(
      titleLarge: TextStyle(
        color: whiteColor,
        fontSize: 18,
        fontWeight: FontWeight.w700,
      ),
      titleMedium: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w400,
        color: whiteColor,
      ),
      titleSmall: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: whiteColor,
      ),
    ),
  );
}
