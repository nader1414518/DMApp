class UserModel {
  String email;
  String userId;
  String displayName;
  List<String> friends = [];

  UserModel({
    this.email,
    this.displayName,
    this.userId,
    this.friends,
  });

  UserModel.fromJson(Map<String, dynamic> json) {
    this.email = json['email'];
    this.displayName = json['displayName'];
    this.userId = json['userId'];

    for (var f in json['friends']) {
      this.friends.add(f.toString());
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'email': this.email,
      'displayName': this.displayName,
      'userId': this.userId,
      'friends': this.friends,
    };
  }
}
