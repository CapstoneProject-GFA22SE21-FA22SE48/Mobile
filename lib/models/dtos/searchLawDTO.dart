class SearchLawDTO {
  final String statueDesc;
  final String sectionDesc;
  final String? paragraphDesc;
  final String minPenalty;
  final String maxPenalty;
  final String? additionalPenalty;

  factory SearchLawDTO.fromJson(Map<String, dynamic> data) {
    return SearchLawDTO(
        data['statueDesc'],
        data['sectionDesc'],
        data['paragraphDesc'],
        data['minPenalty'],
        data['maxPenalty'],
        data['additionalPenalty']);
  }

  Map<String, dynamic> toJson() {
    return {
      'statueDesc': statueDesc,
      'sectionDesc': sectionDesc,
      'paragraphDesc': paragraphDesc,
      'minPenalty': minPenalty,
      'maxPenalty': maxPenalty,
      'additionalPenalty': additionalPenalty,
    };
  }

  SearchLawDTO(this.statueDesc, this.sectionDesc, this.paragraphDesc,
      this.minPenalty, this.maxPenalty, this.additionalPenalty);
}
