class SignModificationRequest {
  final String? id; // get
  final String? modifyingSignId;
  final String? modifiedSignId;
  final String? modifyingGpssignId;
  final String? modifiedGpssignId;
  final String? userId;
  final String? scribeId;
  final String? adminId;
  final int operationType;
  final String imageUrl;
  final int? status; // get
  final String? deniedReason; // get
  final String createdDate; // get
  final bool isDeleted; // get

  factory SignModificationRequest.fromJson(Map<String, dynamic> data) {
    return SignModificationRequest(
      data['id'],
      data['modifyingSignId'],
      data['modifiedSignId'],
      data['modifyingGPSSignId'],
      data['modifiedGPSSignId'],
      data['userId'],
      data['scribeId'],
      data['adminId'],
      data['operationType'],
      data['imageUrl'],
      data['status'],
      data['deniedReason'],
      data['createdDate'],
      data['isDeleted'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'modifyingSignId': modifyingSignId,
      'modifiedSignId': modifiedSignId,
      'modifyingGPSSignId': modifyingGpssignId,
      'modifiedGPSSignId': modifiedGpssignId,
      'userId': userId,
      'scribeId': scribeId,
      'adminId': adminId,
      'operationType': operationType,
      'imageUrl': imageUrl,
      'status': status,
      'deniedReason': deniedReason,
      'createdDate': createdDate,
      'isDeleted': isDeleted
    };
  }

  SignModificationRequest(
    this.id,
    this.modifyingSignId,
    this.modifiedSignId,
    this.modifyingGpssignId,
    this.modifiedGpssignId,
    this.userId,
    this.scribeId,
    this.adminId,
    this.operationType,
    this.imageUrl,
    this.status,
    this.deniedReason,
    this.createdDate,
    this.isDeleted,
  );
}
