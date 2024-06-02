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
      appBar: AppBar(
        centerTitle: true,
        title: const Text("TURQAY NOTES"),
        backgroundColor: Colors.grey[300],
        leading: Builder(builder: (context) {
          return GestureDetector(
              onTap: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        actions: [
                          Column(
                            children: [
                              MyTextField(
                                  controller: dialogController,
                                  hintText: "Add notes",
                                  obscureText: false),
                              const SizedBox(
                                height: 20,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  ElevatedButton(
                                      onPressed: () {},
                                      child: const Icon(Icons.delete)),
                                  ElevatedButton(
                                      onPressed: () => firestore.addNote(
                                          currentUser.email,
                                          dialogController.text),
                                      child: const Icon(Icons.add))
                                ],
                              )
                            ],
                          )
                        ],
                      );
                    });
              },
              child: const Icon(Icons.menu));
        }),
      ),
      drawer: const Drawer(),
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
            final sortedNotes = notes.entries.toList()
              ..sort((a, b) => a.key.compareTo(b.key));

            return ListView.builder(
              itemCount: sortedNotes.length,
              itemBuilder: (context, index) {
                final noteTitle = sortedNotes[index].key;
                final noteContent = notes[noteTitle];
                return MyTile(
                    tileText: noteTitle,
                    isDone: noteContent,
                    onChanged: (value) =>
                        firestore.updateNote(currentUser.email, noteTitle));
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
