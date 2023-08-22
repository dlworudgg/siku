import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../screens/map_screen.dart';
import 'init_loading_page.dart';
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
            print("initLoading");
            return InitLoadingPage();
            // return MapScreen();
          }
          else {
            print("LoginOrRegister");
            return LoginOrRegisterPage();
          }
        }
      ),


    );
  }
}
