import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dmapp/models/chat_model.dart';
import 'package:dmapp/models/message_model.dart';
import 'package:dmapp/models/structures.dart';
import 'package:dmapp/models/user_model.dart';
import 'package:dmapp/widgets/recent_message.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
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
            stream: FirebaseFirestore.instance.collection("users").snapshots(),
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
                List<Widget> msgWidgets = [];

                snapshot.data.docs.map(
                  (doc) {
                    if (doc.id == FirebaseAuth.instance.currentUser.uid) {
                      // Globals.currentUser = UserModel.fromJson(doc.data());
                      Globals.currentUser.email = doc['email'];
                      Globals.currentUser.displayName = doc['displayName'];
                      Globals.currentUser.userId = doc['userId'];
                      Globals.currentUser.friends = [];
                      for (var f in doc['friends']) {
                        Globals.currentUser.friends.add(f.toString());
                      }

                      Globals.currentUser.chats = [];
                      for (var c in doc['chats']) {
                        Globals.currentUser.chats.add(ChatModel.fromJson(c));
                      }

                      for (var c in Globals.currentUser.chats) {
                        if ((c.from.userId ==
                                    FirebaseAuth.instance.currentUser.uid &&
                                c.to.userId == widget.user.userId) ||
                            (c.from.userId == widget.user.userId &&
                                c.to.userId ==
                                    FirebaseAuth.instance.currentUser.uid)) {
                          // Add messages in this chat to the UI
                          for (var message in c.messages) {
                            msgWidgets.add(RecentMessage(
                              message: message,
                            ));
                          }
                        }
                      }
                    }
                  },
                ).toList();
                // msgs.sort(
                //   (a, b) => DateTime.parse(a.message.date).compareTo(
                //     DateTime.parse(b.message.date),
                //   ),
                // );

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
                        children: msgWidgets,
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
                              onPressed: () async {
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

                                  ChatModel chatModel = ChatModel();
                                  chatModel.from = UserModel();
                                  chatModel.from.userId =
                                      FirebaseAuth.instance.currentUser.uid;
                                  chatModel.from.email =
                                      FirebaseAuth.instance.currentUser.email;
                                  chatModel.from.displayName = FirebaseAuth
                                      .instance.currentUser.displayName;
                                  chatModel.from.friends = [];
                                  chatModel.to = UserModel();
                                  chatModel.to = widget.user;
                                  chatModel.messages = [];

                                  // Clear the controller before proceeding ...
                                  setState(
                                    () {
                                      msgController.text = "";
                                    },
                                  );

                                  // Get the chat models in the current user record
                                  var cU = await FirebaseFirestore.instance
                                      .collection("users")
                                      .doc(
                                          FirebaseAuth.instance.currentUser.uid)
                                      .get();

                                  // Get old messages for this chat
                                  for (var c in cU['chats']) {
                                    UserModel tempFromUser =
                                        UserModel.fromJson(c['from']);
                                    UserModel tempToUser =
                                        UserModel.fromJson(c['to']);

                                    if ((tempToUser.userId ==
                                                chatModel.to.userId &&
                                            tempFromUser.userId ==
                                                chatModel.from.userId) ||
                                        (tempToUser.userId ==
                                                chatModel.from.userId &&
                                            tempFromUser.userId ==
                                                chatModel.to.userId)) {
                                      for (var m in c['messages']) {
                                        MessageModel ms =
                                            MessageModel.fromJson(m);
                                        chatModel.messages.add(ms);
                                      }
                                    }
                                  }

                                  chatModel.messages.add(messageModel);

                                  Globals.currentUser.chats.removeWhere(
                                      (element) =>
                                          (element.from.userId ==
                                                  chatModel.from.userId &&
                                              element.to.userId ==
                                                  chatModel.to.userId) ||
                                          (element.from.userId ==
                                                  chatModel.to.userId &&
                                              element.to.userId ==
                                                  chatModel.from.userId));

                                  Globals.currentUser.chats.add(chatModel);

                                  List chts = [];
                                  for (var c in Globals.currentUser.chats) {
                                    chts.add(c.toJson());
                                  }

                                  // Save the chat model for the current user
                                  await FirebaseFirestore.instance
                                      .collection("users")
                                      .doc(
                                          FirebaseAuth.instance.currentUser.uid)
                                      .update({'chats': chts});

                                  chatModel.messages = [];

                                  // Get the chat models in the current user record
                                  cU = await FirebaseFirestore.instance
                                      .collection("users")
                                      .doc(widget.user.userId)
                                      .get();

                                  // Get old messages for this chat
                                  UserModel uModel =
                                      UserModel.fromJson(cU.data());
                                  for (var c in cU['chats']) {
                                    UserModel tempFromUser =
                                        UserModel.fromJson(c['from']);
                                    UserModel tempToUser =
                                        UserModel.fromJson(c['to']);

                                    if ((tempToUser.userId ==
                                                chatModel.to.userId &&
                                            tempFromUser.userId ==
                                                chatModel.from.userId) ||
                                        (tempToUser.userId ==
                                                chatModel.from.userId &&
                                            tempFromUser.userId ==
                                                chatModel.to.userId)) {
                                      for (var m in c['messages']) {
                                        MessageModel ms =
                                            MessageModel.fromJson(m);
                                        chatModel.messages.add(ms);
                                      }
                                    }
                                  }

                                  chatModel.messages.add(messageModel);

                                  uModel.chats.removeWhere((element) =>
                                      (element.from.userId ==
                                              chatModel.from.userId &&
                                          element.to.userId ==
                                              chatModel.to.userId) ||
                                      (element.from.userId ==
                                              chatModel.to.userId &&
                                          element.to.userId ==
                                              chatModel.from.userId));

                                  uModel.chats.add(chatModel);

                                  chts = [];
                                  for (var c in uModel.chats) {
                                    chts.add(c.toJson());
                                  }

                                  // Save the chat model for the other user
                                  await FirebaseFirestore.instance
                                      .collection("users")
                                      .doc(widget.user.userId)
                                      .update({'chats': chts});
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
