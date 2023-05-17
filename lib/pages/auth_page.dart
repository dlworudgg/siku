import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../screens/home_screen.dart';
import '../screens/login_screen.dart';
import '../screens/map_screen.dart';
import 'login_or_register_page.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context,snapshot) {
          if (snapshot.hasData){
            return MapScreen();
          }
          else {
            return LoginOrRegisterPage();
          }
        }
      ),


    );
  }
}
