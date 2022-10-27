import 'package:vnrdn_tai/models/dtos/searchLawDTO.dart';
import 'package:vnrdn_tai/models/dtos/searchSignDTO.dart';

class SignCategoryDTO {
  final String id;
  final String name;
  final List<SearchSignDTO> searchSignDTOs;

  factory SignCategoryDTO.fromJson(Map<String, dynamic> data) {
    return SignCategoryDTO(
        data['id'],
        data['name'],
        data['searchSignDTOs']
            .map((entry) => SearchSignDTO(
                entry['name'],
                entry['description'],
                entry['imageUrl'],
                entry['searchLawDTOs'].length > 0
                    ? List<SearchLawDTO>.from(entry['searchLawDTOs']
                        !.map((p) => SearchLawDTO.fromJson(p)))
                    : []))
            .toList()
            .cast<SearchSignDTO>());
  }

  SignCategoryDTO(this.id, this.name, this.searchSignDTOs);
}
