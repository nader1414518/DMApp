import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dmapp/models/message_model.dart';
import 'package:dmapp/models/user_model.dart';
import 'package:dmapp/screens/navdrawer.dart';
import 'package:dmapp/screens/settings.dart';
import 'package:dmapp/screens/welcome_screen.dart';
import 'package:dmapp/widgets/recent_user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
  }

  void SelectedItem(BuildContext context, item) {
    switch (item) {
      case 0:
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => SettingScreen()));
        break;
      case 1:
        // Show account settings here
        break;
      case 2:
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => WelcomeScreen()),
            (route) => false);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            actions: [
              PopupMenuButton<int>(
                icon: Icon(Icons.more_vert),
                itemBuilder: (context) => [
                  PopupMenuItem<int>(
                    child: Text("Settings"),
                    value: 0,
                  ),
                  PopupMenuItem<int>(
                    child: Text("Account"),
                    value: 1,
                  ),
                  PopupMenuItem<int>(
                    child: Text("Logout"),
                    value: 2,
                  ),
                ],
                onSelected: (item) => SelectedItem(context, item),
              ),
            ],
            centerTitle: false,
            title: Text(
              "DM App",
              style: TextStyle(
                fontStyle: FontStyle.italic,
                fontSize: 18,
              ),
            ),
            backgroundColor: Colors.blueGrey,
            bottom: TabBar(
              tabs: [
                Tab(
                  icon: Icon(Icons.chat_bubble),
                ),
                Tab(
                  icon: Icon(Icons.person),
                ),
                Tab(
                  icon: Icon(Icons.person_add),
                ),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              ListView(
                children: [],
              ),
              ListView(
                children: [],
              ),
              StreamBuilder(
                stream:
                    FirebaseFirestore.instance.collection("users").snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Container(
                      child: Center(
                        child: Text("No users available ... "),
                      ),
                    );
                  }

                  if (snapshot.connectionState == ConnectionState.active) {
                    return ListView(
                      children: snapshot.data.docs.map(
                        (doc) {
                          UserModel user = UserModel.fromJson(doc.data());

                          if (user.userId ==
                              FirebaseAuth.instance.currentUser.uid) {
                            return Container();
                          }

                          // Check here if the user is not in the friends list

                          return Padding(
                            padding: EdgeInsets.fromLTRB(
                              20.0,
                              10.0,
                              20.0,
                              5.0,
                            ),
                            child: RecentUser(
                              user: user,
                            ),
                          );
                        },
                      ).toList(),
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
        ),
      ),
      onWillPop: () async {
        return false;
      },
    );
  }
}
