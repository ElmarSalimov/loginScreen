import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final currentUser = FirebaseAuth.instance.currentUser!;

  Future<void> addNote(String? email, String title) async {
    final userRef = _db.collection('users').where('email', isEqualTo: email);
    final snapshot = await userRef.get();

    if (snapshot.docs.isNotEmpty) {
      final userDoc = snapshot.docs.first;
      final userNotes = userDoc['notes'] ?? {};
      userNotes[title] = false;

      await _db
          .collection('users')
          .doc(userDoc.id)
          .update({'notes': userNotes});
    }
  }

  Future<void> updateNote(String? email, String title) async {
    final userRef = _db.collection('users').where('email', isEqualTo: email);
    final snapshot = await userRef.get();

    final userDoc = snapshot.docs.first;
    final userNotes = userDoc['notes'] ?? {};
    userNotes[title] = !userNotes[title];

    await _db.collection('users').doc(userDoc.id).update({'notes': userNotes});
  }

  Stream<QuerySnapshot> getCurrentNotes() {
    final notesStream = FirebaseFirestore.instance
            .collection('users')
            .where('email', isEqualTo: currentUser.email)
            .snapshots();

    return notesStream;
  }
}
