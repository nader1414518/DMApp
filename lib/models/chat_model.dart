import 'package:dmapp/models/message_model.dart';
import 'package:dmapp/models/user_model.dart';

class ChatModel {
  UserModel from = UserModel();
  UserModel to = UserModel();
  List<MessageModel> messages = [];

  ChatModel({
    this.from,
    this.to,
    this.messages,
  });

  ChatModel.fromJson(Map<String, dynamic> json) {
    this.from = UserModel.fromJson(json['from']);
    this.to = UserModel.fromJson(json['to']);

    this.messages = [];

    for (var msg in json['messages']) {
      this.messages.add(MessageModel.fromJson(msg));
    }
  }

  Map<String, dynamic> toJson() {
    List msgs = [];

    if (this.messages == null) {
      this.messages = [];
    }

    for (var msg in this.messages) {
      msgs.add(msg.toJson());
    }

    return {
      'from': this.from.toJson(),
      'to': this.to.toJson(),
      'messages': msgs,
    };
  }
}
