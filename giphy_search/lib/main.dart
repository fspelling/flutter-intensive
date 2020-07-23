import 'package:flutter/material.dart';
import 'package:giphy_search/screens/home_page.dart';

void main() {
  runApp(MaterialApp(
    theme: ThemeData(
      inputDecorationTheme: InputDecorationTheme(
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
      ),
    ),
    home: HomePage(),
  ));
}
