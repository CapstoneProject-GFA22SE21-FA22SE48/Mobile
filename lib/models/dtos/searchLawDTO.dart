class SearchLawDTO {
  final String sectionDesc;
  final String? paragraphDesc;
  final String minPenalty;
  final String maxPenalty;
  final String? additionalPenalty;


  factory SearchLawDTO.fromJson(Map<String, dynamic> data) {
    return SearchLawDTO(data['sectionDesc'], data['paragraphDesc'],
        data['minPenalty'], data['maxPenalty'], data['additionalPenalty']);
  }

  Map<String, dynamic> toJson() {
    return {
      'sectionDesc': sectionDesc,
      'paragraphDesc': paragraphDesc,
      'minPenalty': minPenalty,
      'maxPenalty': maxPenalty,
      'additionalPenalty': additionalPenalty,

    };
  }

  SearchLawDTO(
      this.sectionDesc, this.paragraphDesc, this.minPenalty, this.maxPenalty, this.additionalPenalty);
}
