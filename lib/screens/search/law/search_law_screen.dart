import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:vnrdn_tai/controllers/global_controller.dart';
import 'package:vnrdn_tai/controllers/search_controller.dart';
import 'package:vnrdn_tai/models/Keyword.dart';
import 'package:vnrdn_tai/screens/search/components/search_bar.dart';
import 'package:vnrdn_tai/screens/search/law/search_law_list.dart';
import 'package:vnrdn_tai/services/KeywordService.dart';
import 'package:vnrdn_tai/shared/constants.dart';
import 'package:vnrdn_tai/shared/snippets.dart';

class SearchLawScreen extends StatefulWidget {
  const SearchLawScreen({super.key});

  @override
  State<SearchLawScreen> createState() => _SearchLawScreenState();
}

class _SearchLawScreenState extends State<SearchLawScreen>
    with TickerProviderStateMixin {
  late Future<List<Keyword>> keywords = KeywordSerivce().GetKeywordList();
  GlobalController gc = Get.find<GlobalController>();
  SearchController sc = Get.put(SearchController());
  final List<Image> images = <Image>[
    Image.asset("assets/images/law/turn_left.png", scale: 10), // 0
    Image.asset("assets/images/law/speed_limit.png", scale: 10), // 1
    Image.asset("assets/images/law/no_alcohol.png", scale: 10), // 2
    Image.asset("assets/images/law/parking.png", scale: 10), // 3
    Image.asset("assets/images/law/delivery.png", scale: 10), // 4
    Image.asset("assets/images/law/driving_license.png", scale: 10), // 5
    Image.asset("assets/images/law/direction.png", scale: 10), // 6
    Image.asset("assets/images/law/delivery_truck.png", scale: 10), // 7
    Image.asset("assets/images/law/jack.png", scale: 10), // 8
    Image.asset("assets/images/law/priority.png", scale: 10), // 9
    Image.asset("assets/images/law/road_barrier.png", scale: 10), // 10
    Image.asset("assets/images/law/speed_limit.png", scale: 10), // 11
  ];

  Image getImage(String name) {
    name = name.toLowerCase();
    if (name.contains('quá tải')) {
      return images[7];
    } else if (name.contains('dừng xe')) {
      return images[3];
    } else if (name.contains('ưu tiên')) {
      return images[9]; //
    } else if (name.contains('vận chuyển')) {
      return images[4];
    } else if (name.contains('nồng độ')) {
      return images[2];
    } else if (name.contains('tốc độ')) {
      return images[1];
    } else if (name.contains('trang thiết bị')) {
      return images[8];
    } else if (name.contains('chuyển hướng')) {
      return images[0];
    } else if (name.contains('giấy tờ')) {
      return images[5];
    } else if (name.contains('đường cấm')) {
      return images[10];
    } else {
      return images[6];
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TabController _tabController;
    return Scaffold(
        // backgroundColor: Theme.of(context).backgroundColor,
        extendBodyBehindAppBar: true,
        body: SafeArea(
          maintainBottomViewPadding: true,
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
                  _tabController = TabController(length: 3, vsync: this);
                  _tabController.index = sc.vehicleCategoryNo.value;
                  return KeyboardVisibilityBuilder(
                    builder: (context, isKeyboardVisible) {
                      return Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            DefaultTabController(
                                length: 3,
                                child: Container(
                                  width: 100.w,
                                  height: 7.h,
                                  color: Colors.white,
                                  child: TabBar(
                                      controller: _tabController,
                                      onTap: (value) {
                                        sc.updateVehicleCategoryNo(value);
                                        sc.updateVehicleCategory(value);
                                      },
                                      indicatorColor: Colors.blueAccent,
                                      labelColor: kPrimaryButtonColor,
                                      unselectedLabelColor: Colors.black54,
                                      indicatorPadding:
                                          const EdgeInsets.symmetric(
                                        horizontal: kDefaultPaddingValue,
                                      ),
                                      indicatorWeight: 3.6,
                                      tabs: const <Tab>[
                                        Tab(
                                          icon: Icon(Icons.motorcycle_outlined),
                                          iconMargin: EdgeInsets.only(
                                              bottom: kDefaultPaddingValue / 4),
                                          text: 'Xe máy',
                                        ),
                                        Tab(
                                          icon: Icon(Icons.car_crash_outlined),
                                          iconMargin: EdgeInsets.only(
                                              bottom: kDefaultPaddingValue / 4),
                                          text: 'Xe ô tô',
                                        ),
                                        Tab(
                                          icon: Icon(Icons.difference_outlined),
                                          iconMargin: EdgeInsets.only(
                                              bottom: kDefaultPaddingValue / 4),
                                          text: 'Khác',
                                        ),
                                      ]),
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
                              height: isKeyboardVisible ? 35.8.h : 64.h,
                              child: GridView.count(
                                physics: const BouncingScrollPhysics(),
                                clipBehavior: Clip.hardEdge,
                                mainAxisSpacing: kDefaultPaddingValue / 4,
                                crossAxisCount: 3,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: kDefaultPaddingValue / 2,
                                ),
                                children: List.generate(
                                  growable: true,
                                  snapshot.data!.length,
                                  (index) {
                                    return Container(
                                      margin: const EdgeInsets.all(
                                        kDefaultPaddingValue / 4,
                                      ),
                                      child: ElevatedButton(
                                        onPressed: () {
                                          Get.to(() => SearchLawListScreen(
                                              keywordId:
                                                  snapshot.data![index].id));
                                        },
                                        style: ElevatedButton.styleFrom(
                                          // elevation: 5,
                                          backgroundColor: Colors.white,
                                          animationDuration:
                                              const Duration(milliseconds: 500),
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      kDefaultPaddingValue)),
                                          shadowColor: Colors.grey.shade200,
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Container(
                                              height: 8.h,
                                              padding: EdgeInsets.symmetric(
                                                  vertical:
                                                      kDefaultPaddingValue / 2),
                                              child: getImage(
                                                  snapshot.data![index].name),
                                            ),
                                            Container(
                                              height: 5.h,
                                              alignment: Alignment.center,
                                              child: Text(
                                                snapshot.data![index].name,
                                                maxLines: 2,
                                                textAlign: TextAlign.center,
                                                style: const TextStyle(
                                                  color: Colors.black54,
                                                  fontSize:
                                                      FONTSIZES.textMedium,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
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
        ));
  }
}
