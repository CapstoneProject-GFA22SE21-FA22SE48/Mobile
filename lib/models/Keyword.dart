import 'package:vnrdn_tai/models/KeywordParagraphs.dart';

class Keyword {
  final String id;
  final String name;

  factory Keyword.fromJson(Map<String, dynamic> data) {
    return Keyword(data['id'], data['name']);
  }

  Keyword(this.id, this.name);
}
