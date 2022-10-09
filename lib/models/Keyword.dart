class Keyword {
  final String id;
  final String name;
  final String paragraphId;

  factory Keyword.fromJson(Map<String, dynamic> data) {
    return Keyword(
      data['id'],
      data['name'],
      data['paragraphId'],
    );
  }

  Keyword(this.id, this.name, this.paragraphId);
}
