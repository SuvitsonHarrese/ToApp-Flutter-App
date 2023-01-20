import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:to_do_app/login/login_or_register.dart';
import 'package:to_do_app/screens/homepage.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // user is logged in
          if (snapshot.hasData) {
            // Timer(
            //   const Duration(seconds: 3),
            //   () {},
            // );
            return HomePage(
              userID: snapshot.data?.uid,
            );
          }

          // user is logged out
          else {
            // debugPrint('Hello ');
            return LoginOrRegisterPage();
          }
        },
      ),
    );
  }
}
