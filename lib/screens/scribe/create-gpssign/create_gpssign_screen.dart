import 'package:flutter/material.dart';
import 'package:vnrdn_tai/models/dtos/signCategoryDTO.dart';
import 'package:vnrdn_tai/services/SignService.dart';

class CreateGpssignScreen extends StatefulWidget {
  const CreateGpssignScreen({Key? key}) : super(key: key);

  @override
  State<CreateGpssignScreen> createState() => _CreateGpssignScreenState();
}

class _CreateGpssignScreenState extends State<CreateGpssignScreen> {
  late Future<List<SignCategoryDTO>> signCategories =
      SignService().GetSignCategoriesDTOList();

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
