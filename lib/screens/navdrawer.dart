import 'package:dmapp/screens/login.dart';
import 'package:dmapp/screens/welcome_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:path/path.dart';

import 'home.dart';

class NavDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Colors.teal[100],
        child: ListView(
          children: [
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(10.0, 30.0, 0.0, 5.0),
                  child: CircleAvatar(
                    backgroundColor: Color(0xff333B56),
                    child: FirebaseAuth.instance.currentUser.displayName != null
                        ? Text(
                            FirebaseAuth.instance.currentUser.displayName
                                    .split(' ')[0][0]
                                    .toUpperCase() +
                                FirebaseAuth.instance.currentUser.displayName
                                    .split(' ')[1][0]
                                    .toUpperCase(),
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          )
                        : Icon(Icons.account_circle),
                    radius: MediaQuery.of(context).size.height / 20.0,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(10.0, 20.0, 0.0, 25.0),
                  child: Text(
                    FirebaseAuth.instance.currentUser.displayName != null
                        ? FirebaseAuth.instance.currentUser.displayName
                        : FirebaseAuth.instance.currentUser.email,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
              ],
            ),
            Divider(
              color: Colors.black54,
              height: 5.0,
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) {
                      return Home();
                    },
                  ),
                );
              },
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
              ),
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(5.0, 15.0, 0.0, 0.0),
                    child: Icon(Icons.home),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(10.0, 15.0, 0.0, 0.0),
                    child: Text("Home"),
                  ),
                ],
              ),
            ),
            TextButton(
              onPressed: () {},
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
              ),
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(5.0, 15.0, 0.0, 0.0),
                    child: Icon(Icons.account_circle),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(10.0, 15.0, 0.0, 0.0),
                    child: Text("Account"),
                  ),
                ],
              ),
            ),
            TextButton(
              onPressed: () {},
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
              ),
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(5.0, 15.0, 0.0, 0.0),
                    child: Icon(Icons.settings),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(10.0, 15.0, 0.0, 0.0),
                    child: Text("Settings"),
                  ),
                ],
              ),
            ),
            TextButton(
              onPressed: () async {
                GoogleSignIn inst = GoogleSignIn();
                await inst.signOut();

                await FirebaseAuth.instance.signOut();

                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) {
                      return WelcomeScreen();
                    },
                  ),
                );
              },
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
              ),
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(5.0, 5.0, 0.0, 0.0),
                    child: Icon(Icons.logout),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(10.0, 5.0, 0.0, 0.0),
                    child: Text("Logout"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
