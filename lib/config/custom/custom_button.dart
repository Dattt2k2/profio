import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

import 'custom_text_style.dart';

class CustomButton extends StatelessWidget{
  final String text;
  final VoidCallback onpressed;
  final double? width;
  final double? height;
  final Color? backgroundColor;
  final Color? textColor;

  const CustomButton({
    super.key,
    required this.text,
    required this.onpressed,
    this.width,
    this.height,
    this.backgroundColor = Colors.blue,
    this.textColor = Colors.white,
  });

  @override
  Widget build(BuildContext context){
    return LayoutBuilder(builder: (context, constraints){
      final isMobile = ResponsiveBreakpoints.of(context).isMobile;
      final isTablet = ResponsiveBreakpoints.of(context).isTablet;
      final isDesktop = ResponsiveBreakpoints.of(context).isDesktop;
      

      double buttonWidht;
      double buttonHeight;

      if(isMobile){
        buttonWidht = constraints.maxWidth * 0.9;
        buttonHeight = 60;
      } else if(isTablet){
        buttonWidht = constraints.maxWidth * 0.6;
        buttonHeight = 45;
      } else{
        buttonWidht = constraints.maxWidth * 0.4;
        buttonHeight = 55;
      }

      return SizedBox(
        width: buttonWidht,
        height: buttonHeight,
        child: ElevatedButton(
          onPressed: onpressed,
          child: Text(
            text,
            style: CustomTextStyle.buttonText(context).copyWith(
              color: textColor
            )
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: backgroundColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          )
        ),
      );
    });
  }
}