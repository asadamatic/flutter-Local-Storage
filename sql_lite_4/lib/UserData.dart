class UserData{

  String email, username, password;

  UserData({this.email, this.username, this.password});

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'username': username,
      'password': password,
    };
  }
}