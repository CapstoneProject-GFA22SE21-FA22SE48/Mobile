class SearchParagraphDTO {
  final String id;
  final String name;
  final String sectionId;
  final String description;
  final String? additionalPenalty;
  final String? maxPenalty;
  final String? minPenalty;

  factory SearchParagraphDTO.fromJson(Map<String, dynamic> data) {
    return SearchParagraphDTO(
      data['id'],
      data['name'],
      data['sectionId'],
      data['description'],
      data['additionalPenalty'],
      data['maxPenalty'],
      data['minPenalty'],
    );
  }

  SearchParagraphDTO(this.id, this.name, this.sectionId, this.description,
      this.additionalPenalty, this.maxPenalty, this.minPenalty);
}
