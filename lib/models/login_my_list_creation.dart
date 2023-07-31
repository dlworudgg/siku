import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ShareRoomService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> ensureShareRoomExists() async {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    final docRef = _firestore.collection('ShareRoom').doc(userId);
    final docSnapshot = await docRef.get();
    if (!docSnapshot.exists) {
      await docRef.collection("ShareRoom").doc("Dummy Place ID").set({
        'placeholder': true,
      });
    }
  }
}
