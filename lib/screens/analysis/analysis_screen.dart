import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vnrdn_tai/controllers/analysis_controller.dart';
import 'package:vnrdn_tai/controllers/global_controller.dart';
import 'package:vnrdn_tai/shared/constants.dart';
import 'package:vnrdn_tai/screens/search/sign/search_sign_screen.dart';
import 'package:vnrdn_tai/controllers/search_controller.dart';
import 'package:vnrdn_tai/screens/container_screen.dart';
import 'package:vnrdn_tai/shared/constants.dart';
import 'package:vnrdn_tai/shared/snippets.dart';
import 'package:sizer/sizer.dart';
import 'package:vnrdn_tai/widgets/animation/ripple.dart';

class AnalysisScreen extends StatelessWidget {
  AnalysisScreen({super.key});

  Widget getBoundingBoxes(List<dynamic> coords, double height, double width) {
    AnalysisController ac = Get.find<AnalysisController>();
    double xmin = double.parse(coords[1]) * width - width / 2;
    double ymin = double.parse(coords[2]) * height;
    double xmax = double.parse(coords[3]) * width - width / 2;
    double ymax = double.parse(coords[4]) * height;
    var name =
        ac.mapData![int.parse(coords[0].replaceAll(".0", ""))].toString();

    // return GestureDetector(
    //   behavior: HitTestBehavior.translucent,
    //   onTap: () {
    //     print('owo');
    //   },
    //   child: AbsorbPointer(
    //     child: CustomPaint(
    //       painter: OpenPainter(
    //           xmin: xmin,
    //           ymin: ymin,
    //           xmax: xmax,
    //           ymax: ymax,
    // name: ac.mapData[int.parse(coords[0].replaceAll(".0", ""))]
    //     .toString()),
    //     ),
    //   ),
    // );
    return Positioned(
        left: xmin + width / 2,
        top: ymin,
        child: InkWell(
            onTap: () {
              SearchController sc = Get.put(SearchController());
              ac.stopImageStream();
              sc.updateQuery(name);
              sc.updateIsFromAnalysis(true);
              Get.offAll(() => ContainerScreen());
            },
            child: Container(
              alignment: Alignment.bottomLeft,
              width: xmax - xmin,
              height: ymax - ymin,
              decoration: BoxDecoration(
                border: Border.all(
                  width: 5,
                  color: Colors.yellow[100]!,
                ),
              ),
              child: Text(
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
    return GetBuilder<AnalysisController>(
        init: ac,
        builder: (controller) {
          return Scaffold(
            appBar: AppBar(),
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
                          ))
                      // : Image.file(
                      //     io.File(controller.imagePath!),
                      //     fit: BoxFit.fill,
                      //     height: double.infinity,
                      //     width: double.infinity,
                      //     alignment: Alignment.center,
                      //   )
                      ,
                      controller.boxes == []
                          ? Container()
                          : Stack(children: <Widget>[
                              for (var box in controller.boxes)
                                getBoundingBoxes(box, height - 80, width)
                            ]),
                      Positioned(
                        bottom: 0.h,
                        width: MediaQuery.of(context).size.width,
                        child: Container(
                          height: 30.h,
                          width: 15.h,
                          child: SizedBox(
                            width: 100.w,
                            height: 30.h,
                            child: Column(
                              children: [
                                controller.isDetecting
                                    ? Center(
                                        child: RippleAnimation(
                                            minRadius: 100,
                                            ripplesCount: 15,
                                            repeat: controller.isDetecting,
                                            color: Colors.white,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 20, left: 18),
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
                                            )),
                                      )
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
                                                fixedSize: const Size(60, 60)),
                                            child: const Icon(Icons.play_arrow,
                                                size: 32)),
                                      ),
                                Center(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: kDefaultPaddingValue),
                                    child: controller.isDetecting
                                        ? Text('Đang tìm kiếm biển báo...',
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline5
                                                ?.copyWith(
                                                    color: Colors
                                                        .blueAccent.shade200,
                                                    fontWeight:
                                                        FontWeight.bold))
                                        : controller.boxes.length > 0
                                            ? Text(
                                                ' Hệ thống đã nhận diện được ${controller.boxes.length} biển báo',
                                                textAlign: TextAlign.center,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headline5
                                                    ?.copyWith(
                                                        color: Colors.blueAccent
                                                            .shade200,
                                                        fontWeight:
                                                            FontWeight.bold),
                                              )
                                            : Text(
                                                ' Bấm nút phía trên để bắt đầu quét',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headline5
                                                    ?.copyWith(
                                                        color: Colors.blueAccent
                                                            .shade200,
                                                        fontWeight:
                                                            FontWeight.bold),
                                              ),
                                  ),
                                ),
                                // Padding(
                                //     padding: const EdgeInsets.only(
                                //         top: kDefaultPaddingValue),
                                //     child: Text('${controller.detected}',
                                //         style: Theme.of(context)
                                //             .textTheme
                                //             .headline5
                                //             ?.copyWith(
                                //                 color:
                                //                     Colors.blueAccent.shade200,
                                //                 fontWeight: FontWeight.bold))),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
          );
        });
  }
}
