import 'dart:async';
import 'dart:math';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:vnrdn_tai/controllers/analysis_controller.dart';
import 'package:vnrdn_tai/controllers/auth_controller.dart';
import 'package:vnrdn_tai/controllers/global_controller.dart';
import 'package:vnrdn_tai/screens/auth/login_screen.dart';
import 'package:vnrdn_tai/screens/feedbacks/sign_content_feedback_screen.dart';
import 'package:vnrdn_tai/screens/scribe/create-gpssign/create_gpssign_screen.dart';
import 'package:vnrdn_tai/shared/constants.dart';
import 'package:vnrdn_tai/controllers/search_controller.dart';
import 'package:vnrdn_tai/screens/container_screen.dart';
import 'package:vnrdn_tai/shared/snippets.dart';
import 'package:sizer/sizer.dart';
import 'package:vnrdn_tai/utils/dialog_util.dart';
import 'package:vnrdn_tai/widgets/animation/ripple.dart';

class AnalysisScreen extends StatelessWidget {
  bool isAddGps;
  AnalysisScreen({super.key, this.isAddGps = false});

  Widget getBoundingBoxes(List<dynamic> coords, double height, double width) {
    AnalysisController ac = Get.find<AnalysisController>();
    double conf = double.parse(coords[5]);

    double xmin = double.parse(coords[1]) * width - width / 2;
    double ymin = double.parse(coords[2]) * height;
    double xmax = double.parse(coords[3]) * width - width / 2;
    double ymax = double.parse(coords[4]) * height;
    // var name = 'here';
    String name =
        ac.mapData![int.parse(coords[0].replaceAll(".0", ""))].toString();
    // var ratioH = height / 240;
    // var ratioW = width / 320;
    // print(coords[0]);

    // double xmin = coords[1];
    // double ymin = coords[2];
    // double xmax = coords[3];
    // double ymax = coords[4];
    // var name = coords[0];
    if (xmax - xmin < 5.w || ymax - ymin < 5.h || conf < 0.7) {
      return Container();
    }
    return Positioned(
        left: xmin + width / 2,
        top: ymin - width / 20,
        //left: xmin + (xmin * ratioW) / 2,
        //top: ymin + (ymin * ratioH) / 3.5,
        child: InkWell(
            onTap: () {
              ac.stopImageStream();
              if (isAddGps) {
                Get.off(() => CreateGpssignScreen(
                    imagePath: ac.imagePathScan ?? "", signNumber: name));
              } else {
                SearchController sc = Get.put(SearchController());
                sc.updateQuery(name);
                sc.updateIsFromAnalysis(true);
                Get.offAll(() => const ContainerScreen());
              }
            },
            child: Container(
              alignment: Alignment.bottomLeft,
              width: xmax - xmin,
              height: ymax - ymin,
              // width: (xmax - xmin) * ratioW * 2,
              // height: (ymax - ymin) * ratioH,
              decoration: BoxDecoration(
                border: Border.all(
                  width: 5,
                  color: Colors.primaries[(int.tryParse(name[0])! +
                      int.tryParse(name[1])! +
                      int.tryParse(name[2])!)],
                ),
              ),
              child: (xmax - xmin < 10.w || ymax - ymin < 10.h)
                  ? Container()
                  : Text(
                      'Biển $name',
                      style: TextStyle(
                          backgroundColor: Colors.yellow[100],
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 10),
                    ),
            )));
  }

  @override
  Widget build(BuildContext context) {
    AnalysisController ac = Get.put(AnalysisController());
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    Timer _timer = Timer(Duration(seconds: 10), () => ac.found);
    return GetBuilder<AnalysisController>(
        init: ac,
        builder: (controller) {
          return Scaffold(
            extendBodyBehindAppBar: true,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              leading: IconButton(
                onPressed: (() {
                  ac.stopImageStream();
                  if (isAddGps) {
                    Get.off(() => CreateGpssignScreen());
                  } else {
                    Get.offAll(() => const ContainerScreen());
                  }
                }),
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ),
              ),
              centerTitle: true,
              title: const Text(
                "Nhận diện biển báo",
                style: TextStyle(color: Colors.white),
              ),
              elevation: 0,
            ),
            body: !controller.isLoaded
                ? loadingScreen()
                : Stack(
                    fit: StackFit.expand,
                    children: [
                      // controller.imagePath == ""
                      // ?

                      AspectRatio(
                        aspectRatio:
                            controller.cameraController.value.aspectRatio,
                        child: CameraPreview(
                          controller.cameraController,
                        ),
                      ),
                      // : Image.file(
                      //     io.File(controller.imagePath!),
                      //     fit: BoxFit.fill,
                      //     height: double.infinity,
                      //     width: double.infinity,
                      //     alignment: Alignment.center,
                      //   )
                      ac.minZoom == ac.maxZoom
                          ? Container()
                          : Positioned(
                              top: 10.h,
                              child: SizedBox(
                                width: 100.w,
                                child: Row(children: [
                                  SizedBox(
                                    width: 80.w,
                                    child: Slider(
                                      value: ac.zoomLevel,
                                      max: ac.maxZoom,
                                      min: ac.minZoom,
                                      activeColor: Colors.blueAccent,
                                      inactiveColor:
                                          Color.fromARGB(167, 255, 255, 255),
                                      onChanged: (value) async {
                                        ac.updateZoomLevel(value);
                                      },
                                    ),
                                  ),
                                  Text('${ac.zoomLevel}x',
                                      textAlign: TextAlign.center,
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline5
                                          ?.copyWith(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontSize:
                                                  FONTSIZES.textMediumLarge))
                                ]),
                              ),
                            ),
                      controller.boxes == []
                          ? Container()
                          : SizedBox(
                              width: 100.h,
                              height: 100.w,
                              child: Stack(children: <Widget>[
                                for (var box in controller.boxes)
                                  getBoundingBoxes(box, height - 80, width)
                                // getBoundingBoxes(box, height, width)
                              ]),
                            ),
                      Positioned(
                        bottom: 0.h,
                        width: MediaQuery.of(context).size.width,
                        child: Container(
                          height: 35.h,
                          width: 15.h,
                          child: SizedBox(
                            width: 100.w,
                            height: 20.h,
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 12.h,
                                ),
                                !isAddGps
                                    ? FutureBuilder(
                                        key: UniqueKey(),
                                        initialData: _timer,
                                        builder: (context, snapshot) =>
                                            stillNotFound(context),
                                      )
                                    : Container(),
                                Center(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: kDefaultPaddingValue),
                                    child: controller.isLoaded &&
                                            controller.isDetecting
                                        ? RippleAnimation(
                                            minRadius: 100,
                                            ripplesCount: 15,
                                            repeat: controller.isDetecting,
                                            color: Colors.white,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 20, left: 18.0),
                                              child: ElevatedButton(
                                                  onPressed: () async {
                                                    await controller
                                                        .stopImageStream();
                                                  },
                                                  style: ElevatedButton.styleFrom(
                                                      shape:
                                                          const CircleBorder(),
                                                      fixedSize:
                                                          const Size(60, 60)),
                                                  child: const Icon(Icons.stop,
                                                      size: 32,
                                                      color: Colors.red)),
                                            ))
                                        : Padding(
                                            padding: const EdgeInsets.only(
                                                top: 20, left: 18),
                                            child: ElevatedButton(
                                                onPressed: () async {
                                                  await controller
                                                      .startImageStream();
                                                },
                                                style: ElevatedButton.styleFrom(
                                                    shape: const CircleBorder(),
                                                    fixedSize:
                                                        const Size(60, 60)),
                                                child: const Icon(
                                                    Icons.play_arrow,
                                                    size: 32)),
                                          ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
            bottomNavigationBar: Container(
              width: 100.w,
              height: 15.h,
              alignment: Alignment.topCenter,
              child: controller.isDetecting && controller.boxes.isEmpty
                  ? Padding(
                      padding:
                          const EdgeInsets.only(top: kDefaultPaddingValue * 2),
                      child: controller.remainTime <= 15
                          ? Text(
                              'Hệ thống sẽ tự ngắt sau ${controller.remainTime} giây nữa...',
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .textTheme
                                  .headline5
                                  ?.copyWith(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ))
                          : Text('Đang tìm kiếm biển báo...',
                              style: Theme.of(context)
                                  .textTheme
                                  .headline5
                                  ?.copyWith(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold)),
                    )
                  : controller.boxes.isNotEmpty
                      ? ListView(
                          scrollDirection: Axis.horizontal,
                          children: List.generate(controller.boxes.length,
                              (int index) {
                            // var name = "102";
                            var name = ac.mapData![int.parse(controller
                                    .boxes[index][0]
                                    .replaceAll(".0", ""))]
                                .toString();
                            return InkWell(
                              onTap: () {
                                ac.stopImageStream();
                                if (isAddGps) {
                                  Get.off(() => CreateGpssignScreen(
                                      imagePath: ac.imagePathScan ?? "",
                                      signNumber: name));
                                } else {
                                  SearchController sc =
                                      Get.put(SearchController());
                                  sc.updateQuery(name);
                                  sc.updateIsFromAnalysis(true);
                                  Get.offAll(() => const ContainerScreen());
                                }
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    top: 8.0,
                                    right: kDefaultPaddingValue / 2,
                                    left: kDefaultPaddingValue),
                                child: Container(
                                    width: 18.w,
                                    // height: 10.h,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.primaries[
                                                (int.tryParse(name[0])! +
                                                    int.tryParse(name[1])! +
                                                    int.tryParse(name[2])!)],
                                            width: 5)),
                                    child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Image.asset(
                                              'assets/gps/x025/$name.png'),
                                          Text(
                                            ' Biển $name',
                                            textAlign: TextAlign.center,
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline6
                                                ?.copyWith(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize:
                                                        FONTSIZES.textSmall),
                                          ),
                                        ])),
                              ),
                            );
                          }),
                        )
                      : Padding(
                          padding: const EdgeInsets.only(
                              top: kDefaultPaddingValue * 2),
                          child: Text(
                            ' Bấm nút phía trên để bắt đầu quét',
                            style: Theme.of(context)
                                .textTheme
                                .headline6
                                ?.copyWith(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                          ),
                        ),
            ),
          );
        });
  }

  void handleFeedbackContent(BuildContext context) async {
    GlobalController gc = Get.put(GlobalController());
    if (gc.userId.value.isNotEmpty) {
      Get.to(() => const LoaderOverlay(
            child: SignContentFeedbackScreen(),
          ));
    } else {
      DialogUtil.showAwesomeDialog(
          context,
          DialogType.warning,
          "Cảnh báo",
          "Bạn cần đăng nhập để tiếp tục.\nĐến trang đăng nhập?",
          () => Get.off(() => const LoginScreen()),
          () {});
    }
  }

  Widget stillNotFound(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: kDefaultPaddingValue * 2.5),
          child: Text(
            'Không tìm thấy biển báo?',
            style: Theme.of(context).textTheme.headline5?.copyWith(
                fontSize: FONTSIZES.textPrimary,
                color: Colors.blueAccent.shade200,
                fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: kDefaultPaddingValue),
          child: ElevatedButton(
            onPressed: () => handleFeedbackContent(context),
            style: ElevatedButton.styleFrom(),
            child: Text(
              'Báo cáo ngay',
              style: Theme.of(context).textTheme.headline6?.copyWith(
                  fontSize: FONTSIZES.textMedium,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
          ),
        )
      ],
    );
  }
}
