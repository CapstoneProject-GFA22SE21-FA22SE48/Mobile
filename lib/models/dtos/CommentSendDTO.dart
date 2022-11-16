class CommentSendDTO {
  final String userId;
  final String content;
  final int rating;

  factory CommentSendDTO.fromJson(Map<String, dynamic> data) {
    return CommentSendDTO(data['userId'], data['content'], data['rating']);
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'content': content,
      'rating': rating,
    };
  }

  CommentSendDTO(this.userId, this.content, this.rating);
}
