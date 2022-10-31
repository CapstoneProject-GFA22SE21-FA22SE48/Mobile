import 'package:vnrdn_tai/models/Answer.dart';

class TestCategoryDTO {
  final String id;
  final String name;
  final int count;

  factory TestCategoryDTO.fromJson(Map<String, dynamic> data) {
    return TestCategoryDTO(
      data['testCategoryId'],
      data['testCategoryName'],
      data['questionsCount'],
    );
  }

  TestCategoryDTO(this.id, this.name, this.count);
}
