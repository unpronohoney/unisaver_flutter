import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UsageTracker {
  static final _firestore = FirebaseFirestore.instance;
  static final _auth = FirebaseAuth.instance;

  static void _increment(String field) {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;

    _firestore.collection('users').doc(uid).update({
      field: FieldValue.increment(1),
    });
  }

  static void manual() => _increment('usedManual');
  static void combination() => _increment('usedCombination');
  static void transcript() => _increment('usedTranscript');
}
