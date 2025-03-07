import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:tiengviet/tiengviet.dart';
import 'package:vnrdn_tai/controllers/global_controller.dart';
import 'package:vnrdn_tai/controllers/search_controller.dart';
import 'package:vnrdn_tai/models/dtos/searchSignDTO.dart';
import 'package:vnrdn_tai/models/dtos/signCategoryDTO.dart';
import 'package:vnrdn_tai/screens/search/components/search_bar.dart';
import 'package:vnrdn_tai/screens/search/sign/search_sign_list.dart';
import 'package:vnrdn_tai/services/SignService.dart';
import 'package:vnrdn_tai/shared/constants.dart';
import 'package:vnrdn_tai/shared/snippets.dart';

class SearchSignScreen extends StatefulWidget {
  const SearchSignScreen({super.key, this.signName});
  final String? signName;

  @override
  State<SearchSignScreen> createState() => _SearchSignScreenState();
}

class _SearchSignScreenState extends State<SearchSignScreen>
    with TickerProviderStateMixin {
  GlobalController gc = Get.find<GlobalController>();
  SearchController sc = Get.put(SearchController());
  List<SignCategoryDTO> listSignCategoryDTO = [];
  late Future<List<SignCategoryDTO>> signCategories =
      SignService().GetSignCategoriesDTOList();

  final List<Color> listTabColors = <Color>[
    Colors.greenAccent.shade700,
    Colors.red,
    Colors.orangeAccent,
    Colors.blue.shade300,
    Colors.blueAccent.shade700,
    Colors.grey.shade800,
  ];

  List<SearchSignDTO> getListAll(List<SignCategoryDTO> categories) {
    List<SearchSignDTO> list = [];
    categories.forEach((cate) {
      list.addAll(cate.searchSignDTOs);
    });
    return list;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TabController _tabController;
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: SafeArea(
        child: FutureBuilder<List<SignCategoryDTO>>(
          key: UniqueKey(),
          future: signCategories,
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
                listSignCategoryDTO.add(
                    SignCategoryDTO('', 'Tất cả', getListAll(snapshot.data!)));
                snapshot.data!.asMap().forEach((i, e) {
                  listSignCategoryDTO.add(e);
                });
                _tabController = TabController(
                    length: (listSignCategoryDTO.length), vsync: this);
                if (sc.isFromAnalysis.value) {
                  listSignCategoryDTO.asMap().forEach((index, element) {
                    for (var element2 in element.searchSignDTOs) {
                      if (TiengViet.parse(element2.name.trim().toLowerCase())
                          .contains(sc.query.value.trim().toLowerCase())) {
                        sc.updateSignCategoryNo(index);
                        sc.updateSignCategory(listSignCategoryDTO[index].name);
                        sc.updateIsFromAnalysis(false);
                        _tabController.index = index;
                      }
                    }
                  });
                } else {
                  _tabController.index = sc.signCategoryNo.value;
                }
                return KeyboardVisibilityBuilder(
                  builder: (p0, isKeyboardVisible) {
                    return Obx(
                      () => Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(
                              width: 100.w,
                              height: 6.h,
                              child: TabBar(
                                controller: _tabController,
                                isScrollable: true,
                                onTap: (value) {
                                  sc.updateSignCategoryNo(value);
                                  if (value > 0) {
                                    sc.updateSignCategory(
                                        listSignCategoryDTO[value].name);
                                  }
                                },
                                labelColor: listTabColors[_tabController.index],
                                indicatorColor:
                                    listTabColors[_tabController.index],
                                indicatorWeight: 3.6,
                                unselectedLabelColor: Colors.black54,
                                labelStyle: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: FONTSIZES.textPrimary,
                                ),
                                unselectedLabelStyle: const TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontSize: FONTSIZES.textMedium),
                                tabs: <Tab>[
                                  ...listSignCategoryDTO
                                      .map((signCategory) => Tab(
                                            text: signCategory.name,
                                          ))
                                      .toList(),
                                ],
                              )),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: kDefaultPaddingValue / 2,
                              horizontal: kDefaultPaddingValue,
                            ),
                            child: SearchBar(),
                          ),
                          SizedBox(
                            width: 100.w,
                            height: isKeyboardVisible ? 36.8.h : 66.5.h,
                            child: SearchSignListScreen(
                              searchSignDTOList: listSignCategoryDTO[
                                      sc.signCategoryNo.value]
                                  .searchSignDTOs
                                  .where((element) =>
                                      TiengViet.parse(element.description.trim().toLowerCase())
                                          .contains(TiengViet.parse(sc
                                              .query.value
                                              .trim()
                                              .toLowerCase())) ||
                                      TiengViet.parse(
                                              element.name.trim().toLowerCase())
                                          .contains(TiengViet.parse(
                                              sc.query.value.trim().toLowerCase())))
                                  .toList(),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              }
            }
          },
        ),
      ),
    );
  }
}
