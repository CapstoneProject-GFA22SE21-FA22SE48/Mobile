class ProfileDTO {
  final String? email;
  final String? avatar;
  final String? displayName;

  factory ProfileDTO.fromJson(Map<String, dynamic> data) {
    return ProfileDTO(data['email'], data['avatar'], data['displayName']);
  }

  Map<String, dynamic> toJson() {
    return {'email': email, 'avatar': avatar, 'displayName': displayName};
  }

  ProfileDTO(this.email, this.avatar, this.displayName);
}
