import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dmapp/models/message_model.dart';
import 'package:dmapp/models/structures.dart';
import 'package:dmapp/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RecentUser extends StatefulWidget {
  UserModel user = UserModel();

  RecentUser({Key key, this.user}) : super(key: key);

  @override
  RecentUserState createState() => RecentUserState();
}

class RecentUserState extends State<RecentUser> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Container(
              child: Text(
                widget.user.email,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.person_add),
            onPressed: () {
              UserModel u = UserModel();
              u.email = FirebaseAuth.instance.currentUser.email;
              u.displayName = FirebaseAuth.instance.currentUser.displayName;
              u.userId = FirebaseAuth.instance.currentUser.uid;

              if (Globals.currentUser.friends == null) {
                Globals.currentUser.friends = [];
              }

              u.friends = Globals.currentUser.friends;
              u.friends.add(widget.user.userId);

              if (widget.user.friends == null) {
                widget.user.friends = [];
              }

              widget.user.friends.add(FirebaseAuth.instance.currentUser.uid);

              FirebaseFirestore.instance
                  .collection("users")
                  .doc(FirebaseAuth.instance.currentUser.uid)
                  .update(u.toJson())
                  .then(
                (value) {
                  Globals.currentUser.friends.add(widget.user.userId);
                  FirebaseFirestore.instance
                      .collection("users")
                      .doc(widget.user.userId)
                      .update(widget.user.toJson())
                      .then((t) {})
                      .onError((error, stackTrace) {
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
        ],
      ),
    );
  }
}
