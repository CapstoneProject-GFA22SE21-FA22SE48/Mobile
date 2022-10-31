
class QuestionCategory {
  final String id;
  final String testCategoryId;
  final String name;
  final bool isDeleted;
  final int noOfQuestion;

  factory QuestionCategory.fromJson(Map<String, dynamic> data) {
    return QuestionCategory(
        data['id'], data['testCategoryId'], data['name'], data['isDeleted'], data['noOfQuestion']);
  }

  QuestionCategory(this.id, this.testCategoryId, this.name, this.isDeleted, this.noOfQuestion);
}
