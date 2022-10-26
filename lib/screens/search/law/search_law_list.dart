import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:vnrdn_tai/controllers/search_controller.dart';
import 'package:vnrdn_tai/models/Keyword.dart';
import 'package:vnrdn_tai/models/Section.dart';
import 'package:vnrdn_tai/models/dtos/searchLawDTO.dart';
import 'package:vnrdn_tai/screens/search/components/search_bar.dart';
import 'package:vnrdn_tai/screens/search/components/search_list_item.dart';
import 'package:vnrdn_tai/services/KeywordService.dart';
import 'package:vnrdn_tai/services/LawService.dart';
import 'package:vnrdn_tai/shared/constants.dart';
import 'package:vnrdn_tai/shared/snippets.dart';

class SearchListScreen extends StatefulWidget {
  SearchListScreen({super.key, required this.query});
  late String query;

  @override
  State<SearchListScreen> createState() => _SearchListScreenState();
}

class _SearchListScreenState extends State<SearchListScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SearchController sc = Get.put(SearchController());
    late Future<List<SearchLawDTO>> searchRes = LawSerivce()
        .GetSearchListByQuery(widget.query, sc.vehicleCategory.value);
    return Scaffold(
        body: SafeArea(
      child: FutureBuilder<List<SearchLawDTO>>(
          key: UniqueKey(),
          future: searchRes,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return loadingScreen();
            } else {
              if (snapshot.hasError) {
                Future.delayed(
                    Duration.zero,
                    () => {
                          handleError(snapshot.error
                              ?.toString()
                              .replaceFirst('Exception:', ''))
                        });
                throw Exception(snapshot.error);
              } else {
                return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      AppBar(
                        title: SearchBar(),
                        backgroundColor: Colors.white,
                        iconTheme: IconThemeData(color: Colors.black),
                      ),
                      const Divider(),
                      Padding(
                        padding:
                            const EdgeInsets.only(left: kDefaultPaddingValue),
                        child: Text(
                            'Có ${snapshot.data!.length} kết quả được tìm thấy',
                            style: Theme.of(context)
                                .textTheme
                                .headline4
                                ?.copyWith(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: FONTSIZES.textMedium)),
                      ),
                      SizedBox(
                        width: 100.w,
                        height: 100.h,
                        child: ListView.separated(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            separatorBuilder: (context, index) =>
                                SizedBox(height: kDefaultPaddingValue),
                            itemBuilder: ((context, index) {
                              return Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: SearchListItem(
                                    searchLawDto: snapshot.data![index]),
                              );
                            }),
                            itemCount: snapshot.data!.length),
                      ),
                    ]);
              }
            }
          }),
    ));
  }
}
