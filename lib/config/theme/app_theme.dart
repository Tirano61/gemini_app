


import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const seedColor = Color(0xFF1E1C36);

class AppTheme {
  final bool isDarkMode;

  AppTheme({required this.isDarkMode});

  ThemeData geTheme() => ThemeData(
    useMaterial3: true,
    colorSchemeSeed: seedColor,
    brightness: isDarkMode ? Brightness.dark : Brightness.light,

    listTileTheme: const ListTileThemeData(
      iconColor: seedColor,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: Color(0xFF1E1C36),
      surfaceTintColor: Colors.transparent,
    ),
  );

  static setSystemUiOverlayStyle({ required bool isDarkMode }) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarBrightness: isDarkMode ? Brightness.dark : Brightness.light,
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: isDarkMode ? Brightness.light : Brightness.dark,
        systemNavigationBarIconBrightness: isDarkMode ? Brightness.light : Brightness.dark,
        systemNavigationBarColor: Colors.transparent,
      )
    );
  }

}