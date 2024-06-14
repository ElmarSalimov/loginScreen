import 'package:chat_app/auth/auth_service.dart';
import 'package:chat_app/data/firestore.dart';
import 'package:chat_app/util/my_text_field.dart';
import 'package:chat_app/util/my_tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  final auth = AuthService();
  final firestore = FirestoreService();
  final dialogController = TextEditingController();

  void signOut() {
    auth.signOut();
    // Optionally navigate back to login screen or perform other actions
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(
        child: Text("Hello world!"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: signOut,
        child: const Icon(Icons.logout),
      ),
    );
  }
}
