
class TestCategory {
  final String id;
  final String name;

  factory TestCategory.fromJson(Map<String, dynamic> data) {
    return TestCategory(data['id'], data['name']);
  }

  TestCategory(this.id, this.name);
}
