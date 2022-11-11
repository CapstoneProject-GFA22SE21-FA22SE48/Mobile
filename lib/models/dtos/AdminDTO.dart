class AdminDTO {
  final String id;
  final String username;
  final String? pendingRequests;
  final String? email;
  final String? avatar;
  final String? displayName;
  final int? role;

  factory AdminDTO.fromJson(Map<String, dynamic> data) {
    return AdminDTO(
      data['id'],
      data['username'],
      data['pendingRequests'],
      data['email'],
      data['avatar'],
      data['displayName'],
      data['role'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'pendingRequests': pendingRequests,
      'email': email,
      'avatar': avatar,
      'displayName': displayName,
      'role': role,
    };
  }

  AdminDTO(this.id, this.username, this.pendingRequests, this.email,
      this.avatar, this.displayName, this.role);
}
