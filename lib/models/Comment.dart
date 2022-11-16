class Comment {
  final String? id;
  final String userId;
  final String avatar;
  final String displayName;
  final String content;
  final int rating;
  final String createdDate;

  factory Comment.fromJson(Map<String, dynamic> data) {
    return Comment(
        data['id'],
        data['userId'],
        data['avatar'],
        data['displayName'],
        data['content'],
        data['rating'],
        data['createdDate']);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'avatar': avatar,
      'displayName': displayName,
      'content': content,
      'rating': rating,
      'createdDate': createdDate
    };
  }

  Comment(this.id, this.userId, this.avatar, this.displayName, this.content,
      this.rating, this.createdDate);
}
