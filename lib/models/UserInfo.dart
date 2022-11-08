class UserInfo {
  final String username;
  final String password;
  final String? email;
  final String? avatar;
  final String? displayName;
  final int? role;

  factory UserInfo.fromJson(Map<String, dynamic> data) {
    return UserInfo(
      data['username'],
      data['password'],
      data['email'],
      data['avatar'],
      data['displayName'],
      data['role'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'password': password,
      'email': email,
      'avatar': avatar,
      'displayName': displayName,
      'role': role,
    };
  }

  UserInfo(this.username, this.password, this.email, this.avatar,
      this.displayName, this.role);
}
