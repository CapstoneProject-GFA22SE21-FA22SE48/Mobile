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
            .map((entry) =>
                SearchSignDTO(entry['name'], entry['description'], entry['imageUrl']))
            .toList()
            .cast<SearchSignDTO>());
  }

  SignCategoryDTO(this.id, this.name, this.searchSignDTOs);
}
