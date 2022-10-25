import 'package:vnrdn_tai/models/Paragraph.dart';
class SearchLawDTO {
  final String statueDesc;
  final String sectionDesc;
  final String? paragraphDesc;
  final String minPenalty;
  final String maxPenalty;
  final String? additionalPenalty;
  final List<Paragraph>? referenceParagraphs;

  factory SearchLawDTO.fromJson(Map<String, dynamic> data) {
    return SearchLawDTO(
        data['statueDesc'],
        data['sectionDesc'],
        data['paragraphDesc'],
        data['minPenalty'],
        data['maxPenalty'],
        data['additionalPenalty'],
        data['referenceParagraphs']
            .map((entry) => Paragraph(
                  entry['id'],
                  entry['name'],
                  entry['sectionId'],
                  entry['description'],
                  entry['additionalPenalty'],
                ))
            .toList()
            .cast<Paragraph>());
  }

  Map<String, dynamic> toJson() {
    return {
      'statueDesc': statueDesc,
      'sectionDesc': sectionDesc,
      'paragraphDesc': paragraphDesc,
      'minPenalty': minPenalty,
      'maxPenalty': maxPenalty,
      'additionalPenalty': additionalPenalty,
      'referenceParagraphs': referenceParagraphs,
    };
  }

  SearchLawDTO(
      this.statueDesc,
      this.sectionDesc,
      this.paragraphDesc,
      this.minPenalty,
      this.maxPenalty,
      this.additionalPenalty,
      this.referenceParagraphs);
}
