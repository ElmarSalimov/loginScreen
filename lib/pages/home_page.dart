import 'package:chat_app/auth/auth_service.dart';
import 'package:chat_app/data/firestore.dart';
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

  void signOut() {
    auth.signOut();
    // Optionally navigate back to login screen or perform other actions
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("TURQAY NOTES"),
        backgroundColor: Colors.grey[300],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .where('email', isEqualTo: currentUser.email)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text("An error occurred"));
          }
          if (snapshot.hasData) {
            final userDocs = snapshot.data!.docs;
            if (userDocs.isEmpty) {
              return const Center(child: Text("No notes found for this user"));
            }
            final user = userDocs.first;
            final Map<String, dynamic> notes = user['notes'];
            return ListView.builder(
              itemCount: notes.length,
              itemBuilder: (context, index) {
                final noteTitle = notes.keys.elementAt(index);
                final noteContent = notes[noteTitle];
                return ListTile(
                  title: Text(noteTitle),
                  subtitle: Text(noteContent.toString()),
                );
              },
            );
          }
          return const Center(child: Text("No users found"));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: signOut,
        child: const Icon(Icons.logout),
      ),
    );
  }
}
