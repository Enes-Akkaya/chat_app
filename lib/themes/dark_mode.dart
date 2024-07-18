import 'package:flutter/material.dart';

ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    useMaterial3: true,
    colorScheme: ColorScheme.dark(
        background: Colors.grey.shade900,
        primary: Colors.blueGrey.shade200,
        secondary: Colors.blueGrey.shade400,
        tertiary: Colors.blueGrey.shade600,
        inversePrimary: Colors.blueGrey.shade700));
