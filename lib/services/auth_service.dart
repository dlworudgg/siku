// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:the_apple_sign_in/the_apple_sign_in.dart';
//
// class AuthService{
//   signInWithGoogle() async{
//     // final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();
//     final GoogleSignInAuthentication gAuth = await gUser!.authentication;
//     final credential = GoogleAuthProvider.credential(
//       accessToken : gAuth.accessToken,
//       idToken: gAuth.idToken,
//     );
//     return await FirebaseAuth.instance.signInWithCredential(credential);
//   }
//
//   // getProfileImage() async{
//   //
//   // }
// }

import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:the_apple_sign_in/the_apple_sign_in.dart';

class AuthService{
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  signInWithGoogle() async{
    final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication gAuth = await gUser!.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken : gAuth.accessToken,
      idToken: gAuth.idToken,
    );

    UserCredential authResult = await firebaseAuth.signInWithCredential(credential);

    String userId = firebaseAuth.currentUser!.uid;

    final docRef = _firestore.collection('ShareRoom').doc(userId);
    final docSnapshot = await docRef.get();
    if (!docSnapshot.exists) {
      await docRef.collection("My List").doc("Dummy Plcae ID").set({
        'placeholder': true,
      });
    }

    return authResult;
  }


// getProfileImage() async{
//   String? photoUrl = firebaseAuth.currentUser?.photoURL;
//   if (photoUrl != null){
//     return Image.network(photoUrl, height: 100, width: 100);
//   } else {
//     return const Icon(Icons.account_circle, size : 100);
//   }
// }
  Future<String?> getProfileImageUrl() async {
    return firebaseAuth.currentUser?.photoURL;
  }

}

// class AuthService {
//   final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
//
//   AuthService._privateConstructor();
//
//   static final AuthService instance = AuthService._privateConstructor();
//
//   signInWithGoogle() async {
//     final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();
//     final GoogleSignInAuthentication gAuth = await gUser!.authentication;
//     final credential = GoogleAuthProvider.credential(
//       accessToken: gAuth.accessToken,
//       idToken: gAuth.idToken,
//     );
//     return await firebaseAuth.signInWithCredential(credential);
//   }
//
//   Future<String?> getProfileImageUrl() async {
//     return firebaseAuth.currentUser?.photoURL;
//   }
// }