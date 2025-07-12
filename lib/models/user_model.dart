class UserModel {
  String? userId;
  String? username;
  String? email;
  String? password;

  UserModel({this.userId, this.username, this.email, this.password});

  UserModel.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    username = json['username'];
    email = json['email'];
    password = json['password'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId'] = this.userId;
    data['username'] = this.username;
    data['email'] = this.email;
    data['password'] = this.password;
    return data;
  }
}
