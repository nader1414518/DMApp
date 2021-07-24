import 'package:dmapp/models/message_model.dart';
import 'package:dmapp/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RecentChatPreview extends StatefulWidget {
  MessageModel msg = MessageModel();
  String lastMessage;

  RecentChatPreview({Key key, this.msg, this.lastMessage}) : super(key: key);

  @override
  RecentChatPreviewState createState() => RecentChatPreviewState();
}

class RecentChatPreviewState extends State<RecentChatPreview> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 0.0),
      child: Container(
        padding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(60.0),
          ),
          color: Colors.white,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
              child: Text(widget.lastMessage),
            ),
          ],
        ),
      ),
    );
  }
}
