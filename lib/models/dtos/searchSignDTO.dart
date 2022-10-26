import 'package:vnrdn_tai/models/Paragraph.dart';
import 'package:vnrdn_tai/models/dtos/searchParagraphDTO.dart';

class SearchSignDTO {
  final String name;
  final String description;
  final String? imageUrl;

  factory SearchSignDTO.fromJson(Map<String, dynamic> data) {
    return SearchSignDTO(data['name'], data['description'], data['imageUrl']);
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
    };
  }

  SearchSignDTO(this.name, this.description, this.imageUrl);
}
