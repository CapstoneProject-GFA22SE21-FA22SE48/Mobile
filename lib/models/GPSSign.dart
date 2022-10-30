class GPSSign {
  final String id;
  final String signId;
  final String imageUrl;
  final double latitude;
  final double longtitude;

  factory GPSSign.fromJson(Map<String, dynamic> data) {
    return GPSSign(
      data['id'],
      data['signId'],
      data['signImageUrl'],
      data['latitude'],
      data['longtitude'],
    );
  }

  GPSSign(
    this.id,
    this.signId,
    this.imageUrl,
    this.latitude,
    this.longtitude,
  );
}
