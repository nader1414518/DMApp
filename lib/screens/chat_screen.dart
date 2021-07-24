import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dmapp/models/message_model.dart';
import 'package:dmapp/models/user_model.dart';
import 'package:dmapp/widgets/recent_message.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  UserModel user = UserModel();

  ChatScreen({Key key, this.user}) : super(key: key);

  @override
  ChatScreenState createState() => ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> {
  Color sendButtonColor;

  TextEditingController msgController = TextEditingController();

  @override
  void initState() {
    super.initState();

    sendButtonColor = Colors.green;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: true,
        title: Text(widget.user.email),
        backgroundColor: Colors.blueGrey,
      ),
      body: ListView(
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
        children: [
          StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("users")
                .doc(FirebaseAuth.instance.currentUser.uid)
                .collection("messages")
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return Container(
                  child: Center(
                    child: Text("Couldn't retrieve messages ... "),
                  ),
                );
              }

              if (snapshot.connectionState == ConnectionState.active) {
                return ListView(
                  shrinkWrap: true,
                  physics: ClampingScrollPhysics(),
                  children: [
                    Container(
                      color: Colors.transparent,
                      height: (MediaQuery.of(context).size.height / 4.0) * 3.0,
                      child: ListView(
                        shrinkWrap: true,
                        physics: ClampingScrollPhysics(),
                        children: snapshot.data.docs.map(
                          (doc) {
                            if (doc.id == widget.user.userId) {
                              if (doc['messages'] != null) {
                                for (var message in doc['messages']) {
                                  MessageModel msg =
                                      MessageModel.fromJson(message);
                                  return RecentMessage(
                                    message: msg,
                                  );
                                }
                              }
                            }
                          },
                        ).toList(),
                      ),
                    ),
                    Container(
                      height: (MediaQuery.of(context).size.height / 4.0) * 0.5,
                      width: MediaQuery.of(context).size.width - 40.0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Flexible(
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(10.0, 0.0, 5.0, 5.0),
                              child: TextFormField(
                                decoration: InputDecoration(
                                  isDense: true,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(60.0),
                                  ),
                                  hintText: "Write message here .. ",
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 5.0),
                            child: IconButton(
                              color: sendButtonColor,
                              icon: Icon(Icons.send),
                              onPressed: () {
                                // Should send messages here
                                if (msgController.text != "" &&
                                    msgController.text != null) {}
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }

              return Container(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
