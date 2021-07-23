import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dmapp/models/message_model.dart';
import 'package:dmapp/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
