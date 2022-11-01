import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:vnrdn_tai/models/Paragraph.dart';
import 'package:vnrdn_tai/models/Section.dart';
import 'package:vnrdn_tai/models/Statue.dart';
import 'package:vnrdn_tai/models/dtos/searchLawDTO.dart';
import 'package:vnrdn_tai/shared/constants.dart';

class LawSerivce {
  List<Section> parseSections(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Section>((json) => Section.fromJson(json)).toList();
  }

  List<Statue> parseStatues(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Statue>((json) => Statue.fromJson(json)).toList();
  }

  List<Paragraph> parseParagraphs(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Paragraph>((json) => Paragraph.fromJson(json)).toList();
  }

  List<SearchLawDTO> parseListSearchLawDTO(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed
        .map<SearchLawDTO>((json) => SearchLawDTO.fromJson(json))
        .toList();
  }

  SearchLawDTO parseSearchLawDTO(String responseBody) {
    final parsed = json.decode(responseBody).cast<String, dynamic>();
    return SearchLawDTO.fromJson(json.decode(responseBody));
  }

  Future<SearchLawDTO> GetSearchParagraphDTOAsync(String paragraphId) async {
    try {
      final res = await http
          .get(Uri.parse("${url}Paragraphs/GetSearchParagraphDTOAsync?paragraphId=$paragraphId"))
          .timeout(const Duration(seconds: TIME_OUT));
      if (res.statusCode == 200) {
        // If the server did return a 200 OK response,
        // then parse the JSON.
        return parseSearchLawDTO(res.body);
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

  Future<List<SearchLawDTO>> GetSearchListByKeywordId(
      String keywordId, String vehicleCategory) async {
    try {
      final res = await http
          .get(Uri.parse(url +
              "Sections/GetSearchListByKeywordId?keywordId=$keywordId&&vehicleCategory=$vehicleCategory"))
          .timeout(const Duration(seconds: TIME_OUT));
      if (res.statusCode == 200) {
        // If the server did return a 200 OK response,
        // then parse the JSON.
        return parseListSearchLawDTO(res.body);
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

  Future<List<SearchLawDTO>> GetSearchListByQuery(
      String query, String vehicleCategory) async {
    try {
      final res = await http
          .get(Uri.parse(url +
              "Sections/GetSearchListByQuery?query=$query&&vehicleCategory=$vehicleCategory"))
          .timeout(const Duration(seconds: TIME_OUT));
      if (res.statusCode == 200) {
        // If the server did return a 200 OK response,
        // then parse the JSON.
        return parseListSearchLawDTO(res.body);
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
