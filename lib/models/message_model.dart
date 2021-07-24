class MessageModel {
  String from;
  String to;
  String text;
  String photoUrl;
  String time;
  String date;

  MessageModel({
    this.from,
    this.text,
    this.photoUrl,
    this.to,
    this.date,
    this.time,
  });

  MessageModel.fromJson(Map<String, dynamic> json) {
    this.from = json['from'];
    this.to = json['to'];
    this.photoUrl = json['photoUrl'];
    this.text = json['text'];
    this.date = json['date'];
    this.time = json['time'];
  }

  Map<String, dynamic> toJson() {
    return {
      'from': this.from,
      'to': this.to,
      'text': this.text,
      'photoUrl': this.photoUrl,
      'date': this.date,
      'time': this.time,
    };
  }
}
