import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {

  // Login
  Future<void> login(BuildContext context, String email, String password) async {
    showDialog(
        context: context,
        builder: (context) {
          return const Center(child: CircularProgressIndicator());
        });

    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      if (context.mounted) {
        Navigator.of(context).pop();
      }
    } on FirebaseAuthException {
      if (context.mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Error")));
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Error")));
      }
    }
  }

  // Register
  Future<void> register(BuildContext context, String email, password, conformPassword) async {
    if (password == conformPassword) {
      showDialog(
          context: context,
          builder: (context) {
            return const Center(child: CircularProgressIndicator());
          });

      try {
        // Create user
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        if (context.mounted) {
          Navigator.of(context).pop();
        }

        // Adding user to the database
        addUser(email, password);
        
      } on FirebaseAuthException catch (e) {
        if (context.mounted) {
          Navigator.of(context).pop();
        }
        if (e.code == 'weak-password') {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Password is weak")));
          }
        } else if (e.code == 'email-already-in-use') {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Email is already in use")));
          }
        }
      } catch (e) {
        if (context.mounted) {
          Navigator.of(context).pop();
        }
      }
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Password do not match")));
    }
  }

  // Sign out
  Future<void> signOut() async {
    FirebaseAuth.instance.signOut();
  }

  // Add user
  Future<void> addUser(String email, password) async {
    await FirebaseFirestore.instance.collection('users').add({
      'email': email,
      'password': password
    });
  }
}