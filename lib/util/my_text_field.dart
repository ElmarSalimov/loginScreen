import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {

  TextEditingController controller = TextEditingController();
  final String hintText;
  final bool obscureText;
  
  MyTextField({super.key, required this.controller, required this.hintText, required this.obscureText});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 6),
      child: TextField(
        controller: controller,
          obscureText: obscureText,
          decoration: InputDecoration(
            hintText: hintText,
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade400), 
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade500),
            ),
            fillColor: Colors.white,
            filled: true
          ),
        ),
    );
  }
}