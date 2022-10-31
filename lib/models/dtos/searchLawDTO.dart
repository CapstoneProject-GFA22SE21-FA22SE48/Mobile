import 'package:vnrdn_tai/models/dtos/searchParagraphDTO.dart';
class SearchLawDTO {
  final String statueDesc;
  final String sectionDesc;
  final String? paragraphDesc;
  final String minPenalty;
  final String maxPenalty;
  final String? additionalPenalty;
  final List<SearchParagraphDTO>? referenceParagraph;

  factory SearchLawDTO.fromJson(Map<String, dynamic> data) {
    return SearchLawDTO(
        data['statueDesc'],
        data['sectionDesc'],
        data['paragraphDesc'],
        data['minPenalty'],
        data['maxPenalty'],
        data['additionalPenalty'],
        data['referenceParagraph']
            .map((entry) => SearchParagraphDTO(
                  entry['id'],
                  entry['name'],
                  entry['sectionId'],
                  entry['description'],
                  entry['additionalPenalty'],
                  entry['maxPenalty'],
                  entry['minPenalty'],
                ))
            .toList()
            .cast<SearchParagraphDTO>());
  }

  Map<String, dynamic> toJson() {
    return {
      'statueDesc': statueDesc,
      'sectionDesc': sectionDesc,
      'paragraphDesc': paragraphDesc,
      'minPenalty': minPenalty,
      'maxPenalty': maxPenalty,
      'additionalPenalty': additionalPenalty,
      'referenceParagraphs': referenceParagraph,
    };
  }

  SearchLawDTO(
      this.statueDesc,
      this.sectionDesc,
      this.paragraphDesc,
      this.minPenalty,
      this.maxPenalty,
      this.additionalPenalty,
      this.referenceParagraph);
}
