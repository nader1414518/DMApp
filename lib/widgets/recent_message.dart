import 'package:dmapp/models/message_model.dart';
import 'package:flutter/cupertino.dart';

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
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(widget.message.from[0]),
          Text(widget.message.text),
        ],
      ),
    );
  }
}
