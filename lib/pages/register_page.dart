import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:siku/theme.dart';
import 'package:siku/components/textfields.dart';

import '../components/login_button.dart';
import '../components/login_square_tile.dart';

class RegisterPage extends StatefulWidget {
  final Function() onTap;
  const RegisterPage({ super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final emailnameController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmedPasswordController = TextEditingController();

  void signUserUp() async {
    showDialog(
        context: context,
        builder: (context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
    );

    try {
      if (passwordController.text == confirmedPasswordController.text) {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailnameController.text,
          password: passwordController.text,
        );
        Navigator.of(context, rootNavigator: true).pop(context);
      } else {
        wrongPasswordMessage();
      }

      // ignore: use_build_context_synchronously
      // Navigator.pop(context);
      // Navigator.of(context, rootNavigator: true).pop(context);

      // }
    }
    on FirebaseAuthException catch (e) {
      errorMessage();
    }
  }
  void wrongPasswordMessage() {
    showDialog(
      context: context,
      builder: (context) {
        return const AlertDialog(
          title: Text("Passwords don't match"),
        );
      },
    );
  }

  void errorMessage() {
    showDialog(
      context: context,
      builder: (context) {
        return const AlertDialog(
          title: Text("Error has occured"),
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
                const SizedBox(height: 10),
                Center(
                  child:
                  SingleChildScrollView(
                    child: MyTextField(
                      controller: confirmedPasswordController ,
                      hintText: 'Confirm Password',
                      obscureText: true,
                    ),
                  ),
                ),
                // const SizedBox(height: 20),
                // Padding(
                //   padding: const EdgeInsets.symmetric(horizontal: 25.0),
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.end,
                //     children: [
                //       Text('Forgot Password?',
                //           style: TextStyle(color: Colors.grey[700])),
                //     ],
                //   ),
                // ),
                const SizedBox(height: 40),
                LoginButton(onTap: signUserUp, text : 'Sign Up'),
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
                // const SizedBox(height: 20),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: const [
                //     SquareTile(imagePath: 'lib/images/Google.png'),
                //     SizedBox(width: 20),
                //     SquareTile(imagePath: 'lib/images/Apple.png'),
                //   ],
                // ),
                // const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Already a member?', style: TextStyle(color: Colors.grey[700])),
                    const SizedBox(width: 5),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: const Text(
                        'Sign in now',
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
