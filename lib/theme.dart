import 'package:flutter/material.dart';

ColorScheme myColorScheme = ColorScheme.fromSeed(
  seedColor: const Color.fromARGB(255, 23, 78, 123),
);

ThemeData myTheme = ThemeData().copyWith(
  useMaterial3: true,
  colorScheme: myColorScheme,
  // appbar and tabs
  appBarTheme: const AppBarTheme().copyWith(
    backgroundColor: myColorScheme.onSecondaryContainer,
    foregroundColor: myColorScheme.primaryContainer,
  ),
  tabBarTheme: const TabBarTheme().copyWith(
    labelColor: myColorScheme.primaryContainer,
    unselectedLabelColor: myColorScheme.outline,
  ),
  // backgrounds
  scaffoldBackgroundColor: myColorScheme.onSecondaryContainer,
  cardTheme: const CardTheme().copyWith(
    color: myColorScheme.tertiary,
    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
  ),
  datePickerTheme: const DatePickerThemeData().copyWith(
    yearForegroundColor: MaterialStatePropertyAll(
      myColorScheme.primaryContainer,
    ),
    rangePickerBackgroundColor: myColorScheme.primaryContainer,
    weekdayStyle: TextStyle(
      color: myColorScheme.primaryContainer,
      fontWeight: FontWeight.bold,
    ),
    dayForegroundColor: MaterialStatePropertyAll(
      myColorScheme.primaryContainer,
    ),
    headerHeadlineStyle: const TextStyle(
      fontSize: 24,
    ),
    backgroundColor: myColorScheme.tertiary,
  ),
  // Text
  inputDecorationTheme: InputDecorationTheme(
    fillColor: myColorScheme.tertiary,
    prefixStyle: TextStyle(
      color: myColorScheme.primaryContainer,
      fontSize: 16,
    ),
    labelStyle: TextStyle(
      color: myColorScheme.primaryContainer,
      fontSize: 16,
    ),
    errorStyle: TextStyle(
      color: myColorScheme.inversePrimary,
      fontSize: 14,
    ),
  ),
  textTheme: ThemeData().textTheme.copyWith(
        titleLarge: TextStyle(
          fontWeight: FontWeight.bold,
          color: myColorScheme.primaryContainer,
          fontSize: 16,
        ),
        titleMedium: TextStyle(
          fontWeight: FontWeight.bold,
          color: myColorScheme.primaryContainer,
          fontSize: 14,
        ),
        titleSmall: TextStyle(
          fontWeight: FontWeight.bold,
          color: myColorScheme.primaryContainer,
          fontSize: 12,
        ),
        bodyLarge: TextStyle(
          color: myColorScheme.inversePrimary,
          fontSize: 16,
        ),
        bodyMedium: TextStyle(
          color: myColorScheme.primaryContainer,
          fontSize: 14,
        ),
        bodySmall: TextStyle(
          color: myColorScheme.primaryContainer,
          fontSize: 12,
        ),
        labelLarge: TextStyle(
          color: myColorScheme.inversePrimary,
          fontSize: 16,
        ),
        labelMedium: TextStyle(
          color: myColorScheme.inversePrimary,
          fontSize: 14,
        ),
        labelSmall: TextStyle(
          color: myColorScheme.inversePrimary,
          fontSize: 12,
        ),
        headlineLarge: TextStyle(
          color: myColorScheme.primaryContainer,
          fontSize: 16,
        ),
        headlineMedium: TextStyle(
          color: myColorScheme.primaryContainer,
          fontSize: 14,
        ),
        headlineSmall: TextStyle(
          color: myColorScheme.primaryContainer,
          fontSize: 12,
        ),
      ),
  // Buttons
  floatingActionButtonTheme: const FloatingActionButtonThemeData().copyWith(
    backgroundColor: myColorScheme.primaryContainer,
    foregroundColor: myColorScheme.onSecondaryContainer,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: myColorScheme.onSecondaryContainer,
      foregroundColor: myColorScheme.primaryContainer,
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: myColorScheme.primaryContainer,
    ),
  ),
  // \todo: how to them dropdown menu button?
);
