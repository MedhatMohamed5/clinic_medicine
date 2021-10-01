import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';

import 'colors.dart';

ThemeData darkTheme(BuildContext context) => ThemeData(
      brightness: Brightness.dark,
      appBarTheme: AppBarTheme(
        iconTheme: IconThemeData(color: Colors.white),
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: HexColor('333739'),
          statusBarIconBrightness: Brightness.light,
        ),
        backgroundColor: HexColor('333739'),
        elevation: 0,
        titleTextStyle: GoogleFonts.aBeeZee(
          textStyle: Theme.of(context).appBarTheme.titleTextStyle?.copyWith(
                color: defaultColor, //Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        enabledBorder: const OutlineInputBorder(
          borderSide: const BorderSide(
            color: Colors.white,
          ),
        ),
      ),
      hintColor: Colors.white,
      iconTheme: IconThemeData(color: Colors.white),
      scaffoldBackgroundColor: HexColor('333739'),
      primarySwatch: defaultColor,
      // primaryColor: Colors.white,
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: defaultColor,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: HexColor('333739'),
        selectedItemColor: defaultColor,
        unselectedItemColor: Colors.grey,
        elevation: 20,
        type: BottomNavigationBarType.fixed,
      ),
      textTheme: TextTheme(
        subtitle1: GoogleFonts.aBeeZee(
          textStyle: Theme.of(context)
              .textTheme
              .subtitle1
              ?.copyWith(color: Colors.white),
        ),
        bodyText2: GoogleFonts.aBeeZee(
          textStyle: Theme.of(context)
              .textTheme
              .bodyText2
              ?.copyWith(color: Colors.white),
        ),
        bodyText1: GoogleFonts.aBeeZee(
          textStyle: Theme.of(context)
              .textTheme
              .bodyText1
              ?.copyWith(color: Colors.white),
        ),
      ),
    );

ThemeData lightTheme(BuildContext context) => ThemeData(
      brightness: Brightness.light,
      appBarTheme: AppBarTheme(
        iconTheme: IconThemeData(color: Colors.black),
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.white,
          statusBarIconBrightness: Brightness.dark,
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        titleTextStyle: GoogleFonts.aBeeZee(
          color: defaultColor,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      scaffoldBackgroundColor: Colors.white,
      primarySwatch: defaultColor,
      textTheme: TextTheme(
        subtitle1: GoogleFonts.aBeeZee(
          textStyle: Theme.of(context)
              .textTheme
              .subtitle1
              ?.copyWith(color: Colors.black),
        ),
        bodyText2: GoogleFonts.aBeeZee(
          textStyle: Theme.of(context)
              .textTheme
              .bodyText2
              ?.copyWith(color: Colors.black),
        ),
        bodyText1: GoogleFonts.aBeeZee(
          textStyle: Theme.of(context)
              .textTheme
              .bodyText1
              ?.copyWith(color: Colors.black),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: defaultColor,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        selectedItemColor: defaultColor,
        elevation: 20,
        type: BottomNavigationBarType.fixed,
      ),
    );
