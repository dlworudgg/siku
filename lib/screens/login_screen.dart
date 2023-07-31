import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:siku/services/auth_service.dart';
import 'package:siku/theme.dart';
import 'package:siku/components/textfields.dart';

import '../components/login_button.dart';
import '../components/login_square_tile.dart';
import '../models/login_my_list_creation.dart';
import '../services/auth_service.dart';


class LoginPage extends StatefulWidget {
  final Function() onTap;
  const LoginPage({ super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailnameController = TextEditingController();
  final passwordController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  void signUserIn() async {
    showDialog(
        context: context,
        builder: (context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
    );


    try {

      await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: emailnameController.text,
      password: passwordController.text,
    );

      final shareRoomService = ShareRoomService();
      await shareRoomService.ensureShareRoomExists();

    // ignore: use_build_context_synchronously
    // Navigator.pop(context);
    Navigator.of(context, rootNavigator: true).pop(context);
    } on FirebaseAuthException catch (e) {
    //   Navigator.pop(context);
    Navigator.of(context, rootNavigator: true).pop(context);

      if (e.code == 'user-not-found' ) {
        // print('No user found for that email');
        wrongLoginMessage();
      }
      else if  (e.code == 'user-not-found' ) {
        wrongLoginMessage();
      }
      else {wrongLoginMessage(); }
    }
    // }
  }

  void wrongLoginMessage() {
    showDialog(
      context: context,
      builder: (context) {
        return const AlertDialog(
          title: Text('Incorrect Email or Password'),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child : Center(
          child : SingleChildScrollView(
          child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            const SizedBox(height: 25),
            Center(
              child: SingleChildScrollView(
              child: MyTextField(
                controller: emailnameController,
                hintText: 'Username',
                obscureText: false,
              ),
              ),
            ),
            const SizedBox(height: 10),
            Center(
              child:
                SingleChildScrollView(
              child: MyTextField(
                controller: passwordController,
                hintText: 'Password',
                obscureText: true,
              ),
                ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text('Forgot Password?',
                      style: TextStyle(color: Colors.grey[700])),
                ],
              ),
            ),
            const SizedBox(height: 40),
            LoginButton(onTap: signUserIn , text: 'Sign In'),
            const SizedBox(height: 50),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Row(
                children: const [
                  Expanded(
                      child: Divider(
                    thickness: 0.5,
                    color: AppColors.iconLight,
                  )),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    child: Text('Or continue with',
                        style: TextStyle(color: AppColors.iconLight)),
                  ),
                  Expanded(
                      child: Divider(
                    thickness: 0.5,
                    color: AppColors.iconLight,
                  )),
                  SizedBox(height: 40),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SquareTile(imagePath: 'lib/images/Google.png',
                onTap: () => AuthService().signInWithGoogle(),
                ),
                SizedBox(width: 20),
                SquareTile(imagePath: 'lib/images/Apple.png',
                    onTap: () => AuthService().signInWithGoogle(),
              ),
              ],
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Not a member?', style: TextStyle(color: Colors.grey[700])),
                const SizedBox(width: 5),
                GestureDetector(
                  onTap: widget.onTap,
                child: const Text(
                  'Register now',
                  style:
                      TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                ),
                ),
              ],
            )
          ],
      ),
        ),
        ),
      ),
    );
  }
}
