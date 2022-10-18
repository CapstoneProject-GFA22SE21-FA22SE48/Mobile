import 'package:vnrdn_tai/models/KeywordParagraphs.dart';

class Keyword {
  final String id;
  final String name;
  // final String paragraphId;
  // final List<KeywordParagraphs> keywordParagraphs;

  factory Keyword.fromJson(Map<String, dynamic> data) {
    return Keyword(data['id'], data['name']
        // data['paragraphId'],
        // data['keywordParagraphs']
        //     .map((entry) =>
        //         KeywordParagraphs(entry['keywordId'], entry['paragraphId']))
        //     .toList()
        //     .cast<KeywordParagraphs>()
        );
  }

  Keyword(this.id, this.name);
}
