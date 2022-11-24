class Sign {
  final String id;
  final String name;
  final String description;
  final String imageUrl;

  factory Sign.fromJson(Map<String, dynamic> data) {
    return Sign(
        data['id'], data['name'], data['description'], data['imageUrl']);
  }

  Sign(this.id, this.name, this.description, this.imageUrl);
}
