class GPSSign {
  final String id;
  final String? signId;
  final String? signName;
  final String? imageUrl;
  final double latitude;
  final double longitude;

  factory GPSSign.fromJson(Map<String, dynamic> data) {
    return GPSSign(
      data['id'],
      data['signId'],
      data['signName'],
      data['imageUrl'],
      data['latitude'],
      data['longitude'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'signId': signId,
      'signName': signName,
      'imageUrl': imageUrl,
      'latitude': latitude,
      'longitude': longitude
    };
  }

  GPSSign(
    this.id,
    this.signId,
    this.signName,
    this.imageUrl,
    this.latitude,
    this.longitude,
  );
}
