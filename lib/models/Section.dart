class Section {
  final String id;
  final String name;
  final String statueId;
  final String description;
  final double? minPenalty;
  final double? maxPenalty;

  factory Section.fromJson(Map<String, dynamic> data) {
    return Section(
      data['id'],
      data['name'],
      data['statueId'],
      data['description'],
      data['minPenalty'],
      data['maxPenalty'],
    );
  }

  Section(this.id, this.name, this.statueId, this.description, this.minPenalty,
      this.maxPenalty);
}
