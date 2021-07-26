import 'package:dmapp/models/chat_model.dart';
import 'package:dmapp/models/message_model.dart';

class UserModel {
  String email;
  String userId;
  String displayName;
  List<String> friends = [];
  List<ChatModel> chats = [];

  UserModel({
    this.email,
    this.displayName,
    this.userId,
    this.friends,
    this.chats,
  });

  UserModel.fromJson(Map<String, dynamic> json) {
    this.email = json['email'];
    this.displayName = json['displayName'];
    this.userId = json['userId'];

    this.friends = [];
    for (var f in json['friends']) {
      this.friends.add(f.toString());
    }

    this.chats = [];
    for (var c in json['chats']) {
      this.chats.add(ChatModel.fromJson(c));
    }
  }

  Map<String, dynamic> toJson() {
    List chts = [];

    if (this.chats == null) {
      this.chats = [];
    }

    for (var c in this.chats) {
      chts.add(c.toJson());
    }

    return {
      'email': this.email,
      'displayName': this.displayName,
      'userId': this.userId,
      'friends': this.friends,
      'chats': chts,
    };
  }
}
