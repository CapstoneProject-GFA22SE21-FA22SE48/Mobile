class UserInfo {
  final String username;
  final String password;
  final String? email;

  factory UserInfo.fromJson(Map<String, dynamic> data) {
    return UserInfo(data['username'], data['password'], data['email']);
  }

  Map<String, dynamic> toJson() {
    return {'username': username, 'password': password, 'email': email};
  }

  UserInfo(this.username, this.password, this.email);
}
