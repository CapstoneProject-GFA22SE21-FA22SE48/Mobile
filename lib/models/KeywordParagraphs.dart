class KeywordParagraphs {
  final String keywordId;
  final String paragraphId;

  factory KeywordParagraphs.fromJson(Map<String, dynamic> data) {
    return KeywordParagraphs(
      data['keywordId'],
      data['paragraphId'],
    );
  }

  KeywordParagraphs(this.keywordId, this.paragraphId);
}
