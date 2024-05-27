import 'package:chat_app/util/my_text_field.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegisterPage extends StatefulWidget {
  void Function()? onTap;

  RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _emailController = TextEditingController();

  final _passwordController = TextEditingController();

  final _confirmPasswordController = TextEditingController();

  void register() async {
    if (_passwordController.text == _confirmPasswordController.text) {
      showDialog(
          context: context,
          builder: (context) {
            return const Center(child: CircularProgressIndicator());
          });

      try {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );

        Navigator.of(context).pop();
      } on FirebaseAuthException catch (e) {
        Navigator.of(context).pop();
        if (e.code == 'weak-password') {
          print('The password provided is too weak.');
        } else if (e.code == 'email-already-in-use') {
          print('The account already exists for that email.');
        }
      } catch (e) {
        Navigator.of(context).pop();
        print(e);
      }
    } else {
      print("Passwords do not match");
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
              Text("Welcome To TurqayChat!",
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

              MyTextField(
                  controller: _confirmPasswordController,
                  hintText: "Confirm password",
                  obscureText: true),

              const SizedBox(height: 6),

              // Button
              GestureDetector(
                onTap: register,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  margin: const EdgeInsets.symmetric(horizontal: 70),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Center(
                    child: Text("R E G I S T E R",
                        style: GoogleFonts.openSans(color: Colors.white)),
                  ),
                ),
              ),

              const SizedBox(
                height: 8,
              ),

              // Bottom text
              GestureDetector(
                onTap: widget.onTap,
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Already a member? "),
                    Text(
                      "Login now",
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
