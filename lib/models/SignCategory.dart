class SignCategory {
  final String id;
  final String name;

  factory SignCategory.fromJson(Map<String, dynamic> data) {
    return SignCategory(data['id'], data['name']);
  }

  SignCategory(this.id, this.name);
}
