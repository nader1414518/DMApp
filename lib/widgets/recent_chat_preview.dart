import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dmapp/models/chat_model.dart';
import 'package:dmapp/models/message_model.dart';
import 'package:dmapp/models/user_model.dart';
import 'package:dmapp/screens/chat_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RecentChatPreview extends StatefulWidget {
  ChatModel chatModel = ChatModel();

  RecentChatPreview({
    Key key,
    this.chatModel,
  }) : super(key: key);

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
    return InkWell(
      child: Padding(
        padding: EdgeInsets.fromLTRB(0.0, 5.0, 5.0, 0.0),
        child: Container(
          padding: EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(60.0),
            ),
            color: Colors.white,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CircleAvatar(
                child: Text(widget.chatModel.from.email[0].toUpperCase()),
              ),
              Flexible(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(20.0, 5.0, 10.0, 5.0),
                  child: widget.chatModel.messages.last.from ==
                          FirebaseAuth.instance.currentUser.uid
                      ? Text(
                          "You: " + widget.chatModel.messages.last.text,
                          overflow: TextOverflow.ellipsis,
                        )
                      : Text(
                          widget.chatModel.messages.last.text,
                          overflow: TextOverflow.ellipsis,
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
      onTap: () async {
        if (widget.chatModel.from.userId ==
            FirebaseAuth.instance.currentUser.uid) {
          var res = await FirebaseFirestore.instance
              .collection("users")
              .doc(widget.chatModel.to.userId)
              .get();

          UserModel userModel = UserModel.fromJson(res.data());
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) {
                return ChatScreen(
                  user: userModel,
                );
              },
            ),
          );
        } else {
          var res = await FirebaseFirestore.instance
              .collection("users")
              .doc(widget.chatModel.from.userId)
              .get();

          UserModel userModel = UserModel.fromJson(res.data());
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) {
                return ChatScreen(
                  user: userModel,
                );
              },
            ),
          );
        }
      },
    );
  }
}
