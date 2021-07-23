import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dmapp/models/structures.dart';
import 'package:dmapp/models/user_model.dart';
import 'package:dmapp/screens/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  @override
  LoginState createState() => LoginState();
}

class LoginState extends State<Login> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();

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
            padding: EdgeInsets.fromLTRB(40.0, 10.0, 40.0, 0.0),
            child: TextButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                  Colors.blue,
                ),
                elevation: MaterialStateProperty.all<double>(3.0),
                foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
              ),
              child: Text("Login"),
              onPressed: () async {
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

                FirebaseAuth.instance
                    .signInWithEmailAndPassword(
                        email: emailController.text,
                        password: passController.text)
                    .then(
                  (value) async {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) {
                          return Home();
                        },
                      ),
                    );
                    Globals.currentUser = UserModel(
                      displayName: value.user.displayName,
                      email: value.user.email,
                      userId: value.user.uid,
                      friends: [],
                    );

                    FirebaseFirestore.instance
                        .collection("users")
                        .doc(Globals.currentUser.userId)
                        .get()
                        .then((uT) {
                      if (uT.data().containsKey('friends')) {
                        for (var f in uT.data().values) {
                          Globals.currentUser.friends.add(f.toString());
                        }

                        print("Retrieved friends list ... ");
                      }
                    }).onError((error, stackTrace) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            error.toString(),
                          ),
                        ),
                      );
                    });
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
