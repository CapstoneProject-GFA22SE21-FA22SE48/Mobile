import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
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
  final List<IconData> iconData = <IconData>[
    Icons.dangerous_outlined,
    Icons.turn_right,
    Icons.perm_device_info,
    Icons.speed,
    Icons.fire_truck,
    Icons.local_parking,
    Icons.swap_vert,
    Icons.train,
    Icons.shop,
    Icons.invert_colors,
    Icons.style,
    Icons.ice_skating
  ];
  final List<Color> iconColors = <Color>[
    Colors.deepOrange,
    Colors.greenAccent.shade200,
    Colors.yellow.shade700,
    Colors.purpleAccent,
    Colors.blueAccent,
    Colors.redAccent.shade200,
    Colors.lightGreenAccent.shade700,
    Colors.indigoAccent.shade200,
    Colors.tealAccent.shade700,
    Colors.pinkAccent,
    Colors.deepOrangeAccent.shade100,
    Colors.grey.shade300
  ];
  final List<Image> images = <Image>[
    Image.asset("/assets/images/law/turn-left.png", scale: 5),
    Image.asset("/assets/images/law/speed-limit.png", scale: 5),
    Image.asset("/assets/images/law/no-alcohol.png", scale: 5),
    Image.asset("/assets/images/law/parking.png", scale: 5),
    Image.asset("/assets/images/law/delivery.png", scale: 5),
    Image.asset("/assets/images/law/driving-license.png", scale: 5),
    Image.asset("/assets/images/law/direction.png", scale: 5),
    Image.asset("/assets/images/law/delivery-truck.png", scale: 5),
    Image.asset("/assets/images/law/jack.png", scale: 5),
    Image.asset("/assets/images/law/priority.png", scale: 5),
    Image.asset("/assets/images/law/road-barrier.png", scale: 5),
    Image.asset("/assets/images/law/speed-limit.png", scale: 5),
  ];

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
                                child: SizedBox(
                                  width: 100.w,
                                  height: 8.h,
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
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: kDefaultPaddingValue / 2),
                              child: SizedBox(
                                width: 100.w,
                                height: isKeyboardVisible ? 42.h : 64.h,
                                child: GridView.count(
                                  clipBehavior: Clip.hardEdge,
                                  crossAxisCount: 3,
                                  children: List.generate(
                                    growable: true,
                                    snapshot.data!.length,
                                    (index) {
                                      return Container(
                                        margin: const EdgeInsets.all(
                                          kDefaultPaddingValue / 2,
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
                                            animationDuration: const Duration(
                                                milliseconds: 500),
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        10.0)),
                                            shadowColor: Colors.grey.shade200,
                                          ),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              // IconButton(
                                              //   iconSize: 48,
                                              //   padding: const EdgeInsets.only(
                                              //       bottom: 5),
                                              //   onPressed: () {
                                              //     Get.to(() =>
                                              //         SearchLawListScreen(
                                              //             keywordId: snapshot
                                              //                 .data![index]
                                              //                 .id));
                                              //   },
                                              //   // color: Colors.accents[index],
                                              //   color: iconColors[index],
                                              //   icon: Icon(iconData[index]),
                                              // ),
                                              images[index],
                                              Text(
                                                snapshot.data![index].name,
                                                maxLines: 2,
                                                textAlign: TextAlign.center,
                                                style: const TextStyle(
                                                  color: Colors.black54,
                                                  fontSize:
                                                      FONTSIZES.textPrimary,
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
