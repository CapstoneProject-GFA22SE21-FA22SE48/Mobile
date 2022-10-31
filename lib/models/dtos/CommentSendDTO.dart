class CommentSendDTO {
  final String userId;
  final String content;

  factory CommentSendDTO.fromJson(Map<String, dynamic> data) {
    return CommentSendDTO(data['userId'], data['content']);
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'content': content,
    };
  }

  CommentSendDTO(this.userId, this.content);
}
