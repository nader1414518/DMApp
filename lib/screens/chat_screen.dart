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
                .doc(widget.user.userId)
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
                var msgs = snapshot.data.docs.map(
                  (doc) {
                    MessageModel msg = MessageModel.fromJson(doc.data());
                    return RecentMessage(
                      message: msg,
                    );
                  },
                ).toList();
                msgs.sort(
                  (a, b) => DateTime.parse(a.message.date).compareTo(
                    DateTime.parse(b.message.date),
                  ),
                );

                return ListView(
                  padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 5.0),
                  shrinkWrap: true,
                  physics: ClampingScrollPhysics(),
                  children: [
                    Container(
                      color: Colors.transparent,
                      height: (MediaQuery.of(context).size.height / 4.0) * 3.0,
                      child: ListView(
                        shrinkWrap: true,
                        physics: ClampingScrollPhysics(),
                        children: msgs,
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
                                controller: msgController,
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
                                if (msgController.text.isNotEmpty) {
                                  // Forward the message to the chat channel
                                  MessageModel messageModel = MessageModel();
                                  messageModel.from =
                                      FirebaseAuth.instance.currentUser.uid;
                                  messageModel.to = widget.user.userId;
                                  messageModel.text = msgController.text;
                                  messageModel.photoUrl = "";
                                  messageModel.time =
                                      DateTime.now().hour.toString() +
                                          ":" +
                                          DateTime.now().minute.toString();
                                  messageModel.date = DateTime.now().toString();

                                  FirebaseFirestore.instance
                                      .collection("users")
                                      .doc(widget.user.userId)
                                      .collection("messages")
                                      .doc(
                                          FirebaseAuth.instance.currentUser.uid)
                                      .collection("messages")
                                      .add(messageModel.toJson())
                                      .then(
                                    (val1) {
                                      FirebaseFirestore.instance
                                          .collection("users")
                                          .doc(FirebaseAuth
                                              .instance.currentUser.uid)
                                          .collection("messages")
                                          .doc(widget.user.userId)
                                          .collection("messages")
                                          .add(messageModel.toJson())
                                          .then((val2) {
                                        print("Sent message ... ");
                                      }).onError((error, stackTrace) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
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
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            error.toString(),
                                          ),
                                        ),
                                      );
                                    },
                                  );

                                  setState(
                                    () {
                                      msgController.text = "";
                                    },
                                  );
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }

              return Container();
            },
          ),
        ],
      ),
    );
  }
}
