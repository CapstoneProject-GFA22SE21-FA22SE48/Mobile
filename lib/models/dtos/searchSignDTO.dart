import 'package:vnrdn_tai/models/dtos/searchLawDTO.dart';

class SearchSignDTO {
  final String name;
  final String description;
  final String? imageUrl;
  final List<SearchLawDTO>? searchLawDTOs;

  factory SearchSignDTO.fromJson(Map<String, dynamic> data) {
    return SearchSignDTO(
        data['name'],
        data['description'],
        data['imageUrl'],
        data['searchLawDTOs']
            .map((entry) => SearchLawDTO(
                  entry['name'],
                  entry['statueDesc'],
                  entry['sectionDesc'],
                  entry['paragraphDesc'],
                  entry['minPenalty'],
                  entry['maxPenalty'],
                  entry['additionalPenalty'],
                  entry['referenceParagraph'],
                ))
            .toList()
            .cast<SearchLawDTO>());
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'searchLawDTOs': searchLawDTOs,
    };
  }

  SearchSignDTO(this.name, this.description, this.imageUrl, this.searchLawDTOs);
}
