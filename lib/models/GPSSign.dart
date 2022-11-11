class GPSSign {
  final String id;
  final String signId;
  final String? imageUrl;
  final double latitude;
  final double longitude;

  factory GPSSign.fromJson(Map<String, dynamic> data) {
    return GPSSign(
      data['id'],
      data['signId'],
      data['imageUrl'],
      data['latitude'],
      data['longitude'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'signId': signId,
      'imageUrl': imageUrl,
      'latitude': latitude,
      'longitude': longitude
    };
  }

  GPSSign(
    this.id,
    this.signId,
    this.imageUrl,
    this.latitude,
    this.longitude,
  );
}
