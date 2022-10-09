import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:sizer/sizer.dart';
import 'package:vnrdn_tai/models/Keyword.dart';
import 'package:vnrdn_tai/services/KeywordService.dart';
import 'package:vnrdn_tai/shared/snippets.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late Future<List<Keyword>> keywords = KeywordSerivce().GetKeywordList();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        body: SafeArea(
          child: FutureBuilder<List<Keyword>>(
              key: UniqueKey(),
              future: keywords,
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
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Container(
                                height: 20.h,
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 2),
                                  child: TextField(
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(25.0),
                                          borderSide:
                                              BorderSide(color: Colors.orange)),
                                      hintText: 'Tra cứu luật',
                                    ),
                                  ),
                                )),
                            Container(
                              width: double.infinity,
                              height: 60.h,
                              child: GridView.count(
                                crossAxisCount: 3,
                                children: List.generate(snapshot.data!.length,
                                    (index) {
                                  return Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        IconButton(
                                            onPressed: () {},
                                            icon: Icon(Icons.telegram)),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 70.0),
                                          child: Text(
                                              '${snapshot.data![index].name}',
                                              maxLines: 2),
                                        )
                                      ]);
                                }),
                              ),
                            ),
                          ]),
                    );
                  }
                }
              }),
        ));
  }
}
