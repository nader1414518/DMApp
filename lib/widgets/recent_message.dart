import 'package:dmapp/models/message_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RecentMessage extends StatefulWidget {
  MessageModel message = MessageModel();

  RecentMessage({Key key, this.message}) : super(key: key);

  @override
  RecentMessageState createState() => RecentMessageState();
}

class RecentMessageState extends State<RecentMessage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.message.from == FirebaseAuth.instance.currentUser.uid
          ? EdgeInsets.fromLTRB(30.0, 5.0, 5.0, 0.0)
          : EdgeInsets.fromLTRB(5.0, 5.0, 30.0, 0.0),
      child: Container(
        padding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(60.0),
          ),
          color: widget.message.from != FirebaseAuth.instance.currentUser.uid
              ? Colors.blueGrey[100]
              : Colors.green[300],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
              child: Text(widget.message.text),
            ),
          ],
        ),
      ),
    );
  }
}
