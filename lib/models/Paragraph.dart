class Paragraph {
  final String id;
  final String name;
  final String sectionId;
  final String description;
  final double? additionalPenalty;

  factory Paragraph.fromJson(Map<String, dynamic> data) {
    return Paragraph(
      data['id'],
      data['name'],
      data['sectionId'],
      data['description'],
      data['additionalPenalty'],
    );
  }

  Paragraph(this.id, this.name, this.sectionId, this.description,
      this.additionalPenalty);
}
