import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:to_do_app/components/mybutton.dart';
import 'package:to_do_app/components/textfield.dart';

class RegisterPage extends StatefulWidget {
  final Function()? onTap;
  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // text editing controllers
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  //Strong Password
  bool vis = false;
  bool _isPasswordEightCharacters = false;
  bool _hasPasswordOnespecial = false;
  bool _hasPasswordOneNumber = false;

  @override
  void initState() {
    super.initState();
    passwordController.addListener(() {
      // debugPrint("qwerty");

      final numericRegex = RegExp(r'[0-9]');
      final specialRegex = RegExp(r'(?=.*\W)');

      setState(() {
        _isPasswordEightCharacters = false;
        if (passwordController.text.length >= 8) {
          _isPasswordEightCharacters = true;
        }
        debugPrint(passwordController.text);
        _hasPasswordOneNumber = false;
        if (numericRegex.hasMatch(passwordController.text)) {
          _hasPasswordOneNumber = true;
        }
        _hasPasswordOnespecial = false;
        if (specialRegex.hasMatch(passwordController.text)) {
          debugPrint("Niucey");
          _hasPasswordOnespecial = true;
        }
      });
    });
  }

  // sign user up method
  void signUserUp() async {
    // show loading circle
    UserCredential? authResult;
    if (formKey.currentState!.validate()) {
      showDialog(
        context: context,
        builder: (context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      );

      // try creating the user
      try {
        // check if password is confirmed
        if (passwordController.text == confirmPasswordController.text) {
          authResult =
              await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: emailController.text,
            password: passwordController.text,
          );
          // pop the loading circle
          Navigator.pop(context);
          String uid = authResult.user!.uid;
          debugPrint("jhvjfbsf   =    $uid");
          await FirebaseFirestore.instance.collection(uid).add({
            "key": usernameController
                .text //your data which will be added to the collection and collection will be created after this
          }).then((_) {
            print("collection created");
          }).catchError((_) {
            print("an error occured");
          });
        } else {
          // pop the loading circle
          Navigator.pop(context);

          // show error message, passwords don't match
          showErrorMessage("Passwords don't match!");
        }
        // Navigator.pop(context);
      } on FirebaseAuthException catch (e) {
        // pop the loading circle
        Navigator.pop(context);
        // show error message
        showErrorMessage(e.code);
      }
    }
  }

  // error message to user
  void showErrorMessage(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.deepPurple,
          title: Center(
            child: Text(
              message,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        );
      },
    );
  }

  final formKey = GlobalKey<FormState>(); //key for form

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        backgroundColor: Colors.grey[300],
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 25),

                    // logo
                    const Icon(
                      Icons.lock,
                      size: 50,
                    ),

                    const SizedBox(height: 25),

                    // let's create an account for you
                    Text(
                      'Let\'s create an account for you!',
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 16,
                      ),
                    ),

                    const SizedBox(height: 25),

                    // username textfield
                    MyTextField(
                      controller: usernameController,
                      hintText: 'Username',
                      obscureText: false,
                      type: "user",
                    ),

                    const SizedBox(height: 10),

                    // email textfield
                    MyTextField(
                      controller: emailController,
                      hintText: 'Email',
                      obscureText: false,
                      type: "email",
                    ),

                    const SizedBox(height: 10),

                    // password textfield
                    // MyTextField(
                    //   controller: passwordController,
                    //   hintText: 'Password',
                    //   obscureText: true,
                    //   type: "pwd",
                    // ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: TextFormField(
                        controller: passwordController,
                        obscureText: vis ? false : true,
                        decoration: InputDecoration(
                          enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.grey.shade400,
                            ),
                          ),
                          fillColor: Colors.grey.shade200,
                          filled: true,
                          hintText: 'Password',
                          hintStyle: TextStyle(
                            color: Colors.grey.shade600,
                          ),
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                vis = !vis;
                              });
                            },
                            icon: Icon(vis
                                ? Icons.visibility_rounded
                                : Icons.visibility_off),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    // confirm password textfield
                    MyTextField(
                      controller: confirmPasswordController,
                      hintText: 'Confirm Password',
                      obscureText: true,
                      type: "pwd",
                    ),

                    const SizedBox(height: 25),

                    //strong Password
                    Padding(
                      padding: const EdgeInsets.only(left: 25.0),
                      child: Row(
                        children: [
                          AnimatedContainer(
                            duration: Duration(milliseconds: 500),
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                                color: _isPasswordEightCharacters
                                    ? Colors.green
                                    : Colors.transparent,
                                border: _isPasswordEightCharacters
                                    ? Border.all(color: Colors.transparent)
                                    : Border.all(color: Colors.grey.shade400),
                                borderRadius: BorderRadius.circular(50)),
                            child: Center(
                              child: Icon(
                                Icons.check,
                                color: Colors.white,
                                size: 15,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text("Contains at least 6 characters")
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 25.0),
                      child: Row(
                        children: [
                          AnimatedContainer(
                            duration: Duration(milliseconds: 500),
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                                color: _hasPasswordOneNumber
                                    ? Colors.green
                                    : Colors.transparent,
                                border: _hasPasswordOneNumber
                                    ? Border.all(color: Colors.transparent)
                                    : Border.all(color: Colors.grey.shade400),
                                borderRadius: BorderRadius.circular(50)),
                            child: Center(
                              child: Icon(
                                Icons.check,
                                color: Colors.white,
                                size: 15,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text("Contains at least 1 number")
                        ],
                      ),
                    ),

                    SizedBox(
                      height: 10,
                    ),

                    // Special Character
                    Padding(
                      padding: const EdgeInsets.only(left: 25.0, bottom: 14),
                      child: Row(
                        children: [
                          AnimatedContainer(
                            duration: Duration(milliseconds: 500),
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                                color: _hasPasswordOnespecial
                                    ? Colors.green
                                    : Colors.transparent,
                                border: _hasPasswordOnespecial
                                    ? Border.all(color: Colors.transparent)
                                    : Border.all(color: Colors.grey.shade400),
                                borderRadius: BorderRadius.circular(50)),
                            child: Center(
                              child: Icon(
                                Icons.check,
                                color: Colors.white,
                                size: 15,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text("Contains at least 1 special character")
                        ],
                      ),
                    ),

                    // sign up button
                    MyButton(
                      text: "Sign Up",
                      onTap: signUserUp,
                    ),

                    const SizedBox(height: 50),

                    // or continue with
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Divider(
                              thickness: 0.5,
                              color: Colors.grey[400],
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Text(
                              'Or continue with',
                              style: TextStyle(color: Colors.grey[700]),
                            ),
                          ),
                          Expanded(
                            child: Divider(
                              thickness: 0.5,
                              color: Colors.grey[400],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 50),

                    // google + apple sign in buttons
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.center,
                    //   children: const [
                    //     // google button
                    //     SquareTile(imagePath: 'lib/images/google.png'),

                    //     SizedBox(width: 25),

                    //     // apple button
                    //     SquareTile(imagePath: 'lib/images/apple.png')
                    //   ],
                    // ),

                    const SizedBox(height: 50),

                    // not a member? register now
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Already have an account?',
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                        const SizedBox(width: 4),
                        GestureDetector(
                          onTap: widget.onTap,
                          child: const Text(
                            'Login now',
                            style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
