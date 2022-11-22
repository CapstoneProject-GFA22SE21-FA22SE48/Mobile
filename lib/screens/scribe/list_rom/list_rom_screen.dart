import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:sizer/sizer.dart';
import 'package:styled_text/styled_text.dart';
import 'package:vnrdn_tai/controllers/global_controller.dart';
import 'package:vnrdn_tai/controllers/question_controller.dart';
import 'package:vnrdn_tai/models/SignModificationRequest.dart';
import 'package:vnrdn_tai/screens/container_screen.dart';
import 'package:vnrdn_tai/screens/scribe/confirm/confirm_screen.dart';
import 'package:vnrdn_tai/services/SignModificationRequestService.dart';
import 'package:vnrdn_tai/shared/constants.dart';
import 'package:vnrdn_tai/shared/snippets.dart';

class ListRomScreen extends StatefulWidget {
  ListRomScreen({super.key});

  @override
  State<ListRomScreen> createState() => _ListRomScreenState();
}

class _ListRomScreenState extends State<ListRomScreen> {
  late Future<List<SignModificationRequest>> roms;

  getScreen(
      GlobalController gc, String categoryName, String categoryId, int count) {
    QuestionController qc = Get.put(QuestionController());
    qc.updateTestCategoryId(categoryId);
    qc.updateTestCategoryName(categoryName);
    qc.updateTestCategoryCount(count);
    gc.updateTab(TABS.MOCK_TEST);
  }

  String getType(int operationType) {
    String text = "Loại yêu cầu: ";
    switch (operationType) {
      case 0:
        text += "Thêm";
        break;
      case 1:
        text += "Thay đổi";
        break;
      default:
        text += "Xoá";
    }
    return '$text biển báo';
  }

  @override
  void initState() {
    super.initState();
    roms = SignModificationRequestService().getClaimedRequests();
  }

  @override
  Widget build(BuildContext context) {
    GlobalController gc = Get.find<GlobalController>();
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          iconSize: FONTSIZES.textHuge,
          onPressed: () {
            Get.offAll(const ContainerScreen());
          },
        ),
        title: const Text("Quản lý yêu cầu"),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.replay),
            iconSize: FONTSIZES.textHuge,
            onPressed: () {
              Get.reload(force: true);
            },
          ),
        ],
      ),
      body: FutureBuilder<List<SignModificationRequest>>(
        key: UniqueKey(),
        future: roms,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting ||
              snapshot.data == null) {
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
              return SizedBox(
                width: 100.w,
                height: 90.h,
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: kDefaultPaddingValue,
                        vertical: kDefaultPaddingValue,
                      ),
                      child: Text(
                        'Danh sách Yêu cầu cần xử lý',
                        style: Theme.of(context).textTheme.headline6?.copyWith(
                            color: Colors.pinkAccent.shade200,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: kDefaultPaddingValue,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: kDefaultPaddingValue * 2),
                          Container(
                            height: 80.h,
                            padding: const EdgeInsets.symmetric(
                              vertical: 0,
                            ),
                            child: ListView.separated(
                              itemCount: snapshot.data!.length,
                              scrollDirection: Axis.vertical,
                              physics: const BouncingScrollPhysics(),
                              shrinkWrap: true,
                              separatorBuilder: (context, index) =>
                                  const SizedBox(height: kDefaultPaddingValue),
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () {
                                    Get.to(
                                      () => LoaderOverlay(
                                        child: ConfirmEvidenceScreen(
                                          romId: snapshot.data![index].id!,
                                          imageUrl:
                                              snapshot.data![index].imageUrl,
                                          operationType: snapshot
                                              .data![index].operationType,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    width: 100.w,
                                    height: 36.h,
                                    margin: const EdgeInsets.symmetric(
                                      horizontal: kDefaultPaddingValue,
                                    ),
                                    padding: kDefaultPadding / 2,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      boxShadow: const [
                                        BoxShadow(
                                            color:
                                                Color.fromARGB(80, 82, 82, 82),
                                            spreadRadius: 2,
                                            blurRadius: 8,
                                            offset: Offset(0, 8))
                                      ],
                                      borderRadius: BorderRadius.circular(
                                          kDefaultPaddingValue / 2),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          width: 80.w,
                                          height: 23.h,
                                          color: Colors.grey,
                                          child: CachedNetworkImage(
                                            imageUrl:
                                                snapshot.data![index].imageUrl,
                                            imageBuilder:
                                                (context, imageProvider) =>
                                                    Container(
                                              decoration: BoxDecoration(
                                                image: DecorationImage(
                                                  image: imageProvider,
                                                  fit: BoxFit.contain,
                                                ),
                                              ),
                                            ),
                                            placeholder: (context, url) =>
                                                Container(
                                              alignment: Alignment.center,
                                              child:
                                                  const CircularProgressIndicator(), // you can add pre loader iamge as well to show loading.
                                            ), //show progress  while loading image
                                            errorWidget: (context, url,
                                                    error) =>
                                                Image.asset(
                                                    "assets/images/alt_image.png"),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: kDefaultPaddingValue,
                                        ),
                                        StyledText(
                                          tags: {
                                            'bold': StyledTextTag(
                                                style: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          },
                                          maxLines: 3,
                                          overflow: TextOverflow.ellipsis,
                                          text: getType(snapshot
                                              .data![index].operationType),
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline6
                                              ?.copyWith(
                                                color: Colors.black87,
                                                fontWeight: FontWeight.bold,
                                              ),
                                        ),
                                        const SizedBox(
                                          height: kDefaultPaddingValue,
                                        ),
                                        Text(
                                          'Tạo lúc: ${DateFormat('hh:mm dd/MM/yyyy').format(DateTime.parse(snapshot.data![index].createdDate))}',
                                          overflow: TextOverflow.ellipsis,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge
                                              ?.copyWith(
                                                color: Colors.black54,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              );
            }
          }
        },
      ),
    );
  }
}
