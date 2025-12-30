
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class UsageTracker {

  static void _increment(String field) async {
    final auth = FirebaseAuth.instance;
    final uid = auth.currentUser?.uid;
    final firestore = FirebaseFirestore.instanceFor(app: Firebase.app(), databaseId: "users");
    if (uid == null) return;
    DocumentSnapshot userDoc = await firestore.collection("users").doc(uid).get();
    if (userDoc.exists) {
      Map<String, dynamic> data = userDoc.data() as Map<String, dynamic>;

      var fieldValue = data[field];
      firestore.collection("users").doc(uid).update({
        field: fieldValue + 1,
      });
    }


  }

  static void manual() => _increment('usedManual');
  static void combination() => _increment('usedCombination');
  static void transcript() => _increment('usedTranscript');
}
