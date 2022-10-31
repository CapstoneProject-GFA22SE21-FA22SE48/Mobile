class Comment {
  final String? id;
  final String userId;
  final String content;
  final String createdDate;

  factory Comment.fromJson(Map<String, dynamic> data) {
    return Comment(
        data['id'], data['userId'], data['content'], data['createdDate']);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'content': content,
      'createdDate': createdDate
    };
  }

  Comment(this.id, this.userId, this.content, this.createdDate);
}
