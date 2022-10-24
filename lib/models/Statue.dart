class Statue {
  final String id;
  final String name;
  final String columnId;
  final String description;

  factory Statue.fromJson(Map<String, dynamic> data) {
    return Statue(
      data['id'],
      data['name'],
      data['columnId'],
      data['description'],
    );
  }

  Statue(this.id, this.name, this.columnId, this.description);
}
