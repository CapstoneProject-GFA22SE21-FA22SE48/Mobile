import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vnrdn_tai/controllers/analysis_controller.dart';
import 'package:vnrdn_tai/controllers/global_controller.dart';
import 'package:vnrdn_tai/shared/constants.dart';
import 'package:vnrdn_tai/shared/snippets.dart';
import 'package:sizer/sizer.dart';
import 'package:vnrdn_tai/widgets/animation/ripple.dart';

class AnalysisScreen extends StatelessWidget {
  AnalysisScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    AnalysisController ac = Get.put(AnalysisController());
    return GetBuilder<AnalysisController>(
        init: ac,
        builder: (controller) {
          return Scaffold(
            body: !controller.isLoaded
                ? loadingScreen()
                : Stack(
                    fit: StackFit.expand,
                    children: [
                      AspectRatio(
                          aspectRatio:
                              controller.cameraController.value.aspectRatio,
                          child: CameraPreview(
                            controller.cameraController,
                          )),
                      ColorFiltered(
                        colorFilter: ColorFilter.mode(
                            Colors.black.withOpacity(0.7), BlendMode.srcOut),
                        child: Stack(
                          children: [
                            Container(
                              decoration: const BoxDecoration(
                                  color: Colors.black,
                                  backgroundBlendMode: BlendMode.dstOut),
                            ),
                            Align(
                              alignment: Alignment.topCenter,
                              child: Container(
                                margin: EdgeInsets.only(top: size.height * 0.2),
                                height: size.height * 0.16 * 2,
                                width: size.width * 0.9 * 2,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        bottom: 5.h,
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
                                Padding(
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
                                                  fontWeight: FontWeight.bold))
                                      : Text(
                                          ' Bấm nút phía trên để bắt đầu quét',
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline5
                                              ?.copyWith(
                                                  color: Colors
                                                      .blueAccent.shade200,
                                                  fontWeight: FontWeight.bold),
                                        ),
                                ),
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
