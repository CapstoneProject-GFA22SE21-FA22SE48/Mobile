import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:vnrdn_tai/models/Paragraph.dart';
import 'package:vnrdn_tai/models/Section.dart';
import 'package:vnrdn_tai/models/SignCategory.dart';
import 'package:vnrdn_tai/models/Statue.dart';
import 'package:vnrdn_tai/models/dtos/searchLawDTO.dart';
import 'package:vnrdn_tai/models/dtos/signCategoryDTO.dart';
import 'package:vnrdn_tai/shared/constants.dart';

class SignService {
  List<SignCategoryDTO> parseSignCategoryDTOList(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed
        .map<SignCategoryDTO>((json) => SignCategoryDTO.fromJson(json))
        .toList();
  }

  Future<List<SignCategoryDTO>> GetSignCategoriesDTOList() async {
    try {
      final res = await http
          .get(Uri.parse(url + "SignCategories/GetSignCategoriesDTOList"))
          .timeout(const Duration(seconds: TIME_OUT));
      if (res.statusCode == 200) {
        // If the server did return a 200 OK response,
        // then parse the JSON.
        return parseSignCategoryDTOList(res.body);
      } else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        throw Exception('Không tải được dữ liệu.');
      }
    } on TimeoutException {
      throw Exception('Không tải được dữ liệu.');
    } on Exception {
      throw Exception('Không thể kết nối');
    }
  }
}
