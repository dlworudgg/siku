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

import '../models/login_my_list_creation.dart';

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

    final shareRoomService = ShareRoomService();
    await shareRoomService.ensureShareRoomExists();

    return authResult;
  }

  Future<String?> getProfileImageUrl() async {
    return firebaseAuth.currentUser?.photoURL;
  }

}
