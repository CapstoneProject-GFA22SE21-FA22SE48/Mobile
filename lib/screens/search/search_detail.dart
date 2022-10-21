import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:sizer/sizer.dart';
import 'package:vnrdn_tai/models/Keyword.dart';
import 'package:vnrdn_tai/models/Section.dart';
import 'package:vnrdn_tai/screens/search/components/search_bar.dart';
import 'package:vnrdn_tai/services/KeywordService.dart';
import 'package:vnrdn_tai/services/SectionService.dart';
import 'package:vnrdn_tai/shared/constants.dart';
import 'package:vnrdn_tai/shared/snippets.dart';

class SearchDetailScreen extends StatefulWidget {
  SearchDetailScreen({super.key, required this.query});
  late String query;

  @override
  State<SearchDetailScreen> createState() => _SearchDetailScreenState();
}

class _SearchDetailScreenState extends State<SearchDetailScreen> {
  late Future<List<Section>> sections =
      SectionSerivce().GetSectionListByQuery(widget.query);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: FutureBuilder<List<Section>>(
          key: UniqueKey(),
          future: sections,
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
                return Center(
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        AppBar(
                          title: SearchBar(),
                          backgroundColor: Colors.white,
                          iconTheme: IconThemeData(color: Colors.black),
                        ),
                        const Divider(),
                        Container(
                          width: double.infinity,
                          height: 60.h,
                          child: ListView.separated(
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              separatorBuilder: (context, index) =>
                                  SizedBox(height: kDefaultPaddingValue),
                              itemBuilder: ((context, index) {
                                return Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Text(
                                      '${snapshot.data![index].name} \n${snapshot.data![index].description}',
                                      maxLines: 5),
                                );
                              }),
                              itemCount: snapshot.data!.length),
                        ),
                      ]),
                );
              }
            }
          }),
    ));
  }
}
