class GPSSignManipulateDTO {
  final String? signId;
  final double latitude;
  final double longitude;
  final bool isDeleted;

  factory GPSSignManipulateDTO.fromJson(Map<String, dynamic> data) {
    return GPSSignManipulateDTO(
      data['signId'],
      data['latitude'],
      data['longitude'],
      data['isDeleted'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'signId': signId,
      'latitude': latitude,
      'longitude': longitude,
      'isDeleted': isDeleted
    };
  }

  GPSSignManipulateDTO(
      this.signId, this.latitude, this.longitude, this.isDeleted);
}
