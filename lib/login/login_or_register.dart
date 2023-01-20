import 'package:flutter/material.dart';
import 'package:to_do_app/login/login_page.dart';
import 'package:to_do_app/login/register.dart';

class LoginOrRegisterPage extends StatefulWidget {
  const LoginOrRegisterPage({super.key});

  @override
  State<LoginOrRegisterPage> createState() => _LoginOrRegisterPageState();
}

class _LoginOrRegisterPageState extends State<LoginOrRegisterPage> {
  // initially show login page
  bool showLoginPage = true;

  // toggle between login and register page
  void togglePages() {
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLoginPage) {
      // debugPrint("loginPage");
      return LoginPage(
        onTap: togglePages,
      );
    } else {
      // debugPrint("registerPage");
      return RegisterPage(
        onTap: togglePages,
      );
    }
  }
}