class SignModificationRequest {
  final String id; // get
  final String? modifyingSignId;
  final String? modifiedSignId;
  final String? modifyingGpssignId;
  final String? modifiedGpssignId;
  final String? userId;
  final String? scribeId;
  final String? adminId;
  final int operationType;
  final String imageUrl;
  final int status; // get
  final DateTime createdDate; // get

  factory SignModificationRequest.fromJson(Map<String, dynamic> data) {
    return SignModificationRequest(
      data['id'],
      data['modifyingSignId'],
      data['modifiedSignId'],
      data['modifyingGpssignId'],
      data['modifiedGpssignId'],
      data['userId'],
      data['scribeId'],
      data['adminId'],
      data['operationType'],
      data['imageUrl'],
      data['status'],
      data['createdDate'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'modifyingSignId': modifyingSignId,
      'modifiedSignId': modifiedSignId,
      'modifyingGpssignId': modifyingGpssignId,
      'modifiedGpssignId': modifiedGpssignId,
      'userId': userId,
      'adminId': adminId,
      'operationType': operationType,
      'imageUrl': imageUrl,
      'status': status,
      'createdDate': createdDate
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
    this.createdDate,
  );
}
