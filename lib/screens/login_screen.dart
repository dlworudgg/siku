import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:siku/theme.dart';
import 'package:siku/components/textfields.dart';

class LoginPage extends StatelessWidget {
   LoginPage({Key? key}) : super(key: key);

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cardLight,
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('lib/images/new_york_daylight.jpg'),
              fit: BoxFit.fill)
          ),
        child: BackdropFilter(
            filter: ImageFilter.blur(
                sigmaX : 5 ,sigmaY : 5
            ),
          child: Column(
            children:  [
              const SizedBox(
                height: 50
                  ),
              const Text('Welcome back. Share your favorite spots to your favorite sikus',
              style: TextStyle(color : AppColors.textDark ,
                    fontSize: 16),
              ),
               const SizedBox(
                  height: 25
              ),
              MyTextField(
                controller: usernameController,
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: const [
                    Text('Forgot Password?',
                    style : TextStyle(color: Colors.black) ),
                  ],
                ),
              ),
              const SizedBox(
                  height: 25
              ),
            ],
          ),
        ),
      ),
        );
      }
    }

