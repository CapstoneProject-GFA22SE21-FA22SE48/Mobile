class GPSSignFeedbackDTO {
  final String? id; // get
  final String? modifyingGpssignId;
  final String? modifiedGpssignId;
  final String? userId;
  final String? scribeId; // for scribe
  final int operationType;
  final String imageUrl;
  final int? status;

  factory GPSSignFeedbackDTO.fromJson(Map<String, dynamic> data) {
    return GPSSignFeedbackDTO(
      data['id'],
      data['modifyingGPSSignId'],
      data['modifiedGPSSignId'],
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
      'modifyingGPSSignId': modifyingGpssignId,
      'modifiedGPSSignId': modifiedGpssignId,
      'userId': userId,
      'scribeId': scribeId,
      'operationType': operationType,
      'imageUrl': imageUrl,
      'status': status
    };
  }

  GPSSignFeedbackDTO(
    this.id,
    this.modifyingGpssignId,
    this.modifiedGpssignId,
    this.userId,
    this.scribeId,
    this.operationType,
    this.imageUrl,
    this.status,
  );
}
