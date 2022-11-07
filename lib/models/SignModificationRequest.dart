class SignModificationRequest {
  final String? id; // get
  final String modifyingGpssignId;
  final String? modifiedGpssignId;
  final String userId;
  final int operationType;
  final String imageUrl;
  final int? status; // get
  final DateTime? createdDate; // get

  factory SignModificationRequest.fromJson(Map<String, dynamic> data) {
    return SignModificationRequest(
      data['id'],
      data['modifyingGpssignId'],
      data['modifiedGpssignId'],
      data['userId'],
      data['operationType'],
      data['imageUrl'],
      data['status'],
      data['createdDate'],
    );
  }

  SignModificationRequest(
    this.id,
    this.modifyingGpssignId,
    this.modifiedGpssignId,
    this.userId,
    this.operationType,
    this.imageUrl,
    this.status,
    this.createdDate,
  );
}
