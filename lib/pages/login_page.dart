import 'dart:js';

import 'package:chat_app/auth/auth_service.dart';
import 'package:chat_app/util/my_text_field.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginPage extends StatelessWidget {

  final void Function()? onTap;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  LoginPage({super.key, required this.onTap});

  void login(BuildContext context) async {
    final auth = AuthService();
    try {
      await auth.login(context, _emailController.text, _passwordController.text);
    }
    catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[300],
        body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon
              const Icon(Icons.lock, size: 50),
              const SizedBox(height: 20),

              // Welcome message
              Text("Welcome To The App!",
                  style: GoogleFonts.openSans(
                      textStyle: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold))),

              const SizedBox(height: 12),

              // Email
              MyTextField(
                  controller: _emailController,
                  hintText: "Email",
                  obscureText: false),

              // Password
              MyTextField(
                  controller: _passwordController,
                  hintText: "Password",
                  obscureText: true),

              const SizedBox(height: 6),

              // Button
              GestureDetector(
                onTap: () => login(context),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  margin: const EdgeInsets.symmetric(horizontal: 70),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Center(
                    child: Text("L O G I N",
                        style: GoogleFonts.openSans(color: Colors.white)),
                  ),
                ),
              ),

              const SizedBox(
                height: 8,
              ),

              // Bottom text
              GestureDetector(
                onTap: onTap,
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Not a member? "),
                    Text(
                      "Register now",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              )
            ],
          ),
        ));
  }
}
