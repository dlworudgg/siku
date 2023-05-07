import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:siku/theme.dart';
import 'package:siku/components/textfields.dart';

import '../components/login_button.dart';
import '../components/login_square_tile.dart';

class LoginPage extends StatelessWidget {
  LoginPage({Key? key}) : super(key: key);

  final emailnameController = TextEditingController();
  final passwordController = TextEditingController();

  void signUserIn() async {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailnameController.text,
         password: passwordController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body:
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
              height: 20
          ),
          // const Text('Share your favorite spots',
          // style: TextStyle(color : AppColors.textDark ,
          //       fontSize: 16),
          // ),
          // const Text('to your favorite sikus',
          //   style: TextStyle(color : AppColors.textDark ,
          //       fontSize: 16),
          // ),
          // Container(
          //   padding: EdgeInsets.all(50),
          //   decoration: const BoxDecoration(
          //     image: DecorationImage(
          //         image: AssetImage('lib/images/new_york_daylight.jpg'),
          //         fit: BoxFit.fitWidth
          //     )
          //     ),
          //   // child: BackdropFilter(
          //   //   filter: ImageFilter.blur(
          //   //       sigmaX : 5 ,sigmaY : 5
          //   //   ),
          //   // )
          // ),
          const SizedBox(
              height: 25
          ),
          MyTextField(
            controller: emailnameController,
            hintText: 'Username',
            obscureText: false,
          ),
          const SizedBox(
              height: 10
          ),
          MyTextField(
            controller: passwordController,
            hintText: 'Password',
            obscureText: true,
          ),
          const SizedBox(
              height: 20
          ),
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
          const SizedBox(
              height: 40
          ),
          LoginButton(
              onTap: signUserIn
          ),
          const SizedBox(
              height: 50
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Row(
              children: const [
                Expanded(child: Divider(
                  thickness: 0.5,
                  color: AppColors.iconLight,
                )
                ),
                Padding(padding: EdgeInsets.symmetric(horizontal: 10.0),
                  child: Text(
                      'Or continue with',
                      style: TextStyle(color: AppColors.iconLight)
                  ),
                ),
                Expanded(child: Divider(
                  thickness: 0.5,
                  color: AppColors.iconLight,
                )
                ),
                SizedBox(
                    height: 40
                ),
              ],
            ),

          ),
          const SizedBox(
              height: 20
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              SquareTile(imagePath: 'lib/images/Google.png'),

              SizedBox(width: 20),

              SquareTile(imagePath: 'lib/images/Apple.png'),
            ],
          ),
          const SizedBox(
              height: 30
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Not a member?',
                  style: TextStyle(color: Colors.grey[700])
              ),
              const SizedBox(width: 5),
              const Text('Register now',
                style: TextStyle(
                    color: Colors.blue, fontWeight: FontWeight.bold),
              ),
            ],
          )
        ],
      ),
      // ),
    );
  }
}

