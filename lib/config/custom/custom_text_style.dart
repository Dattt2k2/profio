
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:responsive_framework/responsive_framework.dart';


// final responsive = ResponsiveBreakpoints.of(context);
//     final isMobile = responsive.isMobile;
//     final isTablet = responsive.isTablet;
//     final isDesktop = responsive.isDesktop;

//     late final fontSize;

late double fontSize;

class ScreenUtils {
  static bool isMobile(BuildContext context) {
    return ResponsiveBreakpoints.of(context).isMobile;
  }

  static bool isTablet(BuildContext context) {
    return ResponsiveBreakpoints.of(context).isTablet;
  }

  static bool isDesktop(BuildContext context) {
    return ResponsiveBreakpoints.of(context).isDesktop;
  }
}

class CustomTextStyle{
  static TextStyle headlineBig(BuildContext context){
    


    ScreenUtils.isMobile(context) ? fontSize = 24 : ScreenUtils.isTablet(context) ? fontSize = 28 : ScreenUtils.isDesktop(context) ? fontSize = 48 : fontSize = 24;


    return TextStyle(
      fontSize: fontSize,
      fontWeight: FontWeight.bold,
    );
  }

  static TextStyle headlineMedium(BuildContext context){

    ScreenUtils.isMobile(context) ? fontSize = 20 : ScreenUtils.isTablet(context) ? fontSize = 24 : ScreenUtils.isDesktop(context) ? fontSize = 36 : fontSize = 20;

    return TextStyle(
      fontSize: fontSize,
      fontWeight: FontWeight.w600
    );
  }

  static TextStyle bodyText(BuildContext context){
    
    ScreenUtils.isMobile(context) ? fontSize = 16 : ScreenUtils.isTablet(context) ? fontSize = 18 : ScreenUtils.isDesktop(context) ? fontSize = 18 : fontSize = 16;

    return TextStyle(
      fontSize: fontSize,
      fontWeight: FontWeight.normal,
    );
  }

  static TextStyle subtitle(BuildContext context) {
   
    ScreenUtils.isMobile(context) ? fontSize = 14 : ScreenUtils.isTablet(context) ? fontSize = 16 : ScreenUtils.isDesktop(context) ? fontSize = 20 : fontSize = 14;    

    return TextStyle(
      fontSize: fontSize,
      fontWeight: FontWeight.w400,
    );
  }

  static TextStyle buttonText(BuildContext context){
    
    ScreenUtils.isMobile(context) ? fontSize = 20 : ScreenUtils.isTablet(context) ? fontSize = 18 : ScreenUtils.isDesktop(context) ? fontSize = 20 : fontSize = 16;

    return TextStyle(
      fontSize: fontSize,
      fontWeight: FontWeight.w600,
    );
  }
  static TextStyle splastTitle(BuildContext context){

    ScreenUtils.isMobile(context) ? fontSize = 30 : ScreenUtils.isTablet(context) ? fontSize = 40 : ScreenUtils.isDesktop(context) ? fontSize = 46 : fontSize = 30;

    return TextStyle(
      fontSize: fontSize,
      fontWeight: FontWeight.w600
    );
  }

  static TextStyle headlineSuperBig(BuildContext context){
    


    ScreenUtils.isMobile(context) ? fontSize = 24 : ScreenUtils.isTablet(context) ? fontSize = 28 : ScreenUtils.isDesktop(context) ? fontSize = 48 : fontSize = 60;


    return TextStyle(
      fontSize: fontSize,
      fontWeight: FontWeight.bold,
      fontFamily: 'Bungee'
    );
  }
}