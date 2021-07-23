class MessageModel {
  String from;
  String to;
  String text;
  String photoUrl;

  MessageModel({
    this.from,
    this.text,
    this.photoUrl,
    this.to,
  });

  MessageModel.fromJson(Map<String, dynamic> json) {
    this.from = json['from'];
    this.to = json['to'];
    this.photoUrl = json['photoUrl'];
    this.text = json['text'];
  }

  Map<String, dynamic> toJson() {
    return {
      'from': this.from,
      'to': this.to,
      'text': this.text,
      'photoUrl': this.photoUrl,
    };
  }
}
