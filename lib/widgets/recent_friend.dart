import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dmapp/models/message_model.dart';
import 'package:dmapp/models/structures.dart';
import 'package:dmapp/models/user_model.dart';
import 'package:dmapp/screens/chat_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RecentFriend extends StatefulWidget {
  UserModel user = UserModel();

  RecentFriend({Key key, this.user}) : super(key: key);

  @override
  RecentFriendState createState() => RecentFriendState();
}

class RecentFriendState extends State<RecentFriend> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
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
              icon: Icon(Icons.message),
              onPressed: () {
                // Open chat channel between current user and other user
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) {
                      return ChatScreen(
                        user: widget.user,
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Should show user profile ... ",
            ),
          ),
        );
      },
    );
  }
}
