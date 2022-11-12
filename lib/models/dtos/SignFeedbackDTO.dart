class SignFeedbackDTO {
  final String? id; // get
  final String? modifyingSignId;
  final String? modifiedSignId;
  final String? userId;
  final String? scribeId; // for scribe
  final int operationType;
  final String imageUrl;
  final int? status;

  factory SignFeedbackDTO.fromJson(Map<String, dynamic> data) {
    return SignFeedbackDTO(
      data['id'],
      data['modifyingSignId'],
      data['modifiedSignId'],
      data['userId'],
      data['scribeId'],
      data['operationType'],
      data['imageUrl'],
      data['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'modifyingSignId': modifyingSignId,
      'modifiedSignId': modifiedSignId,
      'userId': userId,
      'scribeId': scribeId,
      'operationType': operationType,
      'imageUrl': imageUrl,
      'status': status
    };
  }

  SignFeedbackDTO(
    this.id,
    this.modifyingSignId,
    this.modifiedSignId,
    this.userId,
    this.scribeId,
    this.operationType,
    this.imageUrl,
    this.status,
  );
}
