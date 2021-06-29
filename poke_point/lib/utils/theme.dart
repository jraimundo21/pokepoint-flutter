import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';

const PrimaryColor = const Color(0xFF11443c);
const PrimaryColorLight = const Color(0xFF066758);
const PrimaryColorDark = const Color(0xFF092B26);

const SecondaryColor = const Color(0xFFF3A712);
const SecondaryColorLight = const Color(0xFFf2d395);
const SecondaryColorDark = const Color(0xFFb87d08);

const Background = const Color(0xFFFAF3DD);
const TextColor = const Color(0xFFffffff);
const SecondaryTextColor = const Color(0xFF092B26);

class MyTheme {
  static final ThemeData myCustom = _buildMyTheme();

  static ThemeData _buildMyTheme() {
    final ThemeData base = ThemeData.light();

    return base.copyWith(
      appBarTheme: AppBarTheme(brightness: Brightness.dark),
      accentColor: SecondaryColor,
      accentColorBrightness: Brightness.dark,
      primaryColor: PrimaryColor,
      primaryColorDark: PrimaryColorDark,
      primaryColorLight: PrimaryColorLight,
      primaryColorBrightness: Brightness.dark,
      buttonTheme: base.buttonTheme.copyWith(
        buttonColor: SecondaryColor,
        textTheme: ButtonTextTheme.primary,
      ),
      scaffoldBackgroundColor: Background,
      cardColor: Background,
      textSelectionColor: PrimaryColorLight,
      backgroundColor: Background,
      textTheme: base.textTheme.copyWith(
          title: base.textTheme.title.copyWith(color: TextColor),
          body1: base.textTheme.body1.copyWith(color: TextColor),
          body2: base.textTheme.body2.copyWith(color: TextColor)),
    );
  }
}
