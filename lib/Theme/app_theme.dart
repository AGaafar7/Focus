import 'package:flutter/material.dart';

abstract class AppColors {
  static const secondary = Color.fromARGB(255, 0, 0, 0);
  static const accent = Color(0xFFD6755B);
  static const textDark = Colors.white;
  static const textLight = Colors.black;
  static const textFaded = Color(0xFF9899A5);
  static const iconLight = Colors.black;
  static const iconDark = Colors.white;
  static const textHighLight = secondary;
  static const cardLight = Colors.white;
  static const cardDark = Colors.black;
}

abstract class _LightColors {
  static const background = Colors.white;
  static const card = AppColors.cardLight;
}

abstract class _DarkColors {
  static const background = Color(0xFF1B1E1F);
  static const card = AppColors.cardDark;
}

/// Reference to the application theme.
abstract class AppTheme {
  static const accentColor = AppColors.accent;
  static final visualDensity = VisualDensity.adaptivePlatformDensity;

  ///Light Theme and its settings
  static ThemeData light() => ThemeData(
        brightness: Brightness.light,
        appBarTheme: const AppBarTheme(
          titleTextStyle: TextStyle(color: AppColors.textLight),
          color: AppColors.textDark,
        ),
        visualDensity: visualDensity,
        textTheme: const TextTheme().apply(bodyColor: AppColors.textLight),
        backgroundColor: _LightColors.background,
        scaffoldBackgroundColor: _LightColors.background,
        cardColor: _LightColors.card,
        primaryTextTheme:
            const TextTheme(bodyText1: TextStyle(color: AppColors.textLight)),
        iconTheme: const IconThemeData(color: AppColors.iconLight),
      );

  /// Dark theme and its settings.
  static ThemeData dark() => ThemeData(
        brightness: Brightness.dark,
        appBarTheme: const AppBarTheme(
          titleTextStyle: TextStyle(color: AppColors.textDark),
          color: AppColors.textDark,
        ),
        visualDensity: visualDensity,
        textTheme: const TextTheme().apply(bodyColor: AppColors.textDark),
        backgroundColor: _DarkColors.background,
        scaffoldBackgroundColor: _DarkColors.background,
        cardColor: _DarkColors.card,
        primaryTextTheme:
            const TextTheme(bodyText1: TextStyle(color: AppColors.textDark)),
        iconTheme: const IconThemeData(color: AppColors.iconDark),
      );
}
