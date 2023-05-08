import 'package:flutter/material.dart';
import 'package:siku/theme.dart';

class MyTextField extends StatelessWidget {
  final controller;
  final String hintText;
  final bool obscureText;


  const MyTextField({super.key,
  required this.controller, required this.hintText, required this.obscureText
  });





  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: TextField(
        controller: controller,
          obscureText: obscureText,
        //   enableSuggestions: false,
        //   autocorrect: false,
        // keyboardType: TextInputType.text,
        // smartDashesType: SmartDashesType.disabled,
        decoration: InputDecoration(
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.textLigth),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.cardLight),
          ),
          fillColor: Colors.grey.shade200,
          filled: true,
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey[500])
        ),
      ),
    );
  }
}
