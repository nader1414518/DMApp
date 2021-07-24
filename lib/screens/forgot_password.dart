import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dmapp/models/structures.dart';
import 'package:dmapp/models/user_model.dart';
import 'package:dmapp/screens/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ForgotPassword extends StatefulWidget {
  @override
  ForgotPasswordState createState() => ForgotPasswordState();
}

class ForgotPasswordState extends State<ForgotPassword> {
  TextEditingController emailController = TextEditingController();

  bool showPass;

  @override
  void initState() {
    super.initState();

    showPass = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(0.0, 50.0, 0.0, 0.0),
            child: Hero(
              tag: 'logo',
              child: Container(
                height: 200.0,
                child: Image.asset('images/logo.png'),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 5.0),
            child: TextFormField(
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                    60.0,
                  ),
                ),
                isDense: true,
                hintText: "Email here..",
                floatingLabelBehavior: FloatingLabelBehavior.always,
                prefixIcon: Icon(Icons.account_box),
              ),
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(40.0, 10.0, 40.0, 0.0),
            child: TextButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                  Colors.blue,
                ),
                elevation: MaterialStateProperty.all<double>(3.0),
                foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
              ),
              child: Text("Send reset email"),
              onPressed: () async {
                if (emailController.text == "" ||
                    emailController.text == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Please enter your email ... "),
                    ),
                  );
                  return;
                }

                FirebaseAuth.instance
                    .sendPasswordResetEmail(email: emailController.text)
                    .then(
                  (value) async {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) {
                          return Home();
                        },
                      ),
                    );
                  },
                ).onError(
                  (error, stackTrace) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          error.toString(),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
