import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dmapp/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  @override
  SignUpState createState() => SignUpState();
}

class SignUpState extends State<SignUp> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  TextEditingController confPassController = TextEditingController();

  bool showPass;
  bool showPass1;

  @override
  void initState() {
    super.initState();

    showPass = false;
    showPass1 = false;
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
            padding: EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 5.0),
            child: TextFormField(
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                    60.0,
                  ),
                ),
                isDense: true,
                hintText: "Password here..",
                floatingLabelBehavior: FloatingLabelBehavior.always,
                prefixIcon: IconButton(
                  icon: Icon(
                    Icons.remove_red_eye,
                  ),
                  onPressed: () {
                    setState(
                      () {
                        showPass = !showPass;
                      },
                    );
                  },
                ),
              ),
              controller: passController,
              obscureText: !showPass,
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 5.0),
            child: TextFormField(
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                    60.0,
                  ),
                ),
                isDense: true,
                hintText: "Confirm password..",
                floatingLabelBehavior: FloatingLabelBehavior.always,
                prefixIcon: IconButton(
                  icon: Icon(
                    Icons.remove_red_eye,
                  ),
                  onPressed: () {
                    setState(
                      () {
                        showPass1 = !showPass1;
                      },
                    );
                  },
                ),
              ),
              controller: confPassController,
              obscureText: !showPass1,
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(40.0, 20.0, 40.0, 0.0),
            child: TextButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                  Colors.blue,
                ),
                elevation: MaterialStateProperty.all<double>(3.0),
                foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
              ),
              child: Text("Create account"),
              onPressed: () {
                if (emailController.text == "" ||
                    emailController.text == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Some fields are empty ... "),
                    ),
                  );
                  return;
                }

                if (passController.text == "" || passController.text == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Some fields are empty ... "),
                    ),
                  );
                  return;
                }

                if (confPassController.text == "" ||
                    confPassController.text == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Some fields are empty ... "),
                    ),
                  );
                  return;
                }

                if (passController.text != confPassController.text) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Passwords don't match ... "),
                    ),
                  );
                  return;
                }

                FirebaseAuth.instance
                    .createUserWithEmailAndPassword(
                        email: emailController.text,
                        password: passController.text)
                    .then(
                  (value) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Created account successfully ... "),
                      ),
                    );

                    UserModel user = UserModel(
                      displayName: value.user.displayName,
                      email: value.user.email,
                      userId: value.user.uid,
                      friends: [],
                      chats: [],
                    );

                    FirebaseFirestore.instance
                        .collection("users")
                        .doc(user.userId)
                        .set(user.toJson())
                        .then((val1) {
                      print("added user record ... ");
                    }).onError((error, stackTrace) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(error.toString()),
                        ),
                      );
                    });
                    Navigator.of(context).pop();
                  },
                ).onError(
                  (error, stackTrace) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(error.toString()),
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
