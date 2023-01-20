// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';

class MyTextField extends StatefulWidget {
  final controller;
  final String hintText;
  final bool obscureText;
  final String type;

  const MyTextField(
      {super.key,
      this.controller,
      required this.hintText,
      required this.obscureText,
      required this.type});

  @override
  State<MyTextField> createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  bool vis = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: TextFormField(
        controller: widget.controller,
        obscureText: vis ? false : widget.obscureText,
        validator: (value) {
          if (!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                  .hasMatch(value!) &&
              widget.type == 'email') {
            return 'Please enter a valid email address';
          }
          if (widget.type == 'pwd' && value.isEmpty) {
            
            return 'Please enter a valid password';
          }
          return null;
        },
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
          hintText: widget.hintText,
          hintStyle: TextStyle(color: Colors.grey.shade600),
          suffixIcon: widget.type == 'pwd'
              ? IconButton(
                  onPressed: () {
                    if (widget.type == 'pwd') {
                      setState(() {
                        vis = !vis;
                      });
                    }
                  },
                  icon: Icon(
                      vis ? Icons.visibility_rounded : Icons.visibility_off),
                )
              : null,
        ),
      ),
    );
  }
}
