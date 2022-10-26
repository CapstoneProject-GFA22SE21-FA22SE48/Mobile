import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vnrdn_tai/controllers/analysis_controller.dart';
import 'package:vnrdn_tai/controllers/global_controller.dart';
import 'package:vnrdn_tai/shared/constants.dart';

class AnalysisScreen extends StatelessWidget {
  AnalysisScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    AnalysisController ac = Get.put(AnalysisController());
    return GetBuilder<AnalysisController>(
        init: ac,
        builder: (controller) {
          print(controller.isLoaded);
          return Scaffold(
            key: UniqueKey(),
            backgroundColor: kPrimaryBackgroundColor,
            appBar: AppBar(
              title: const Text("Nhận diện biển báo"),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            body: !controller.isLoaded
                ? const Center(
                    child: Text(
                      "Đang tải hệ thống.\nVui lòng chờ trong giây lát.",
                      textAlign: TextAlign.center,
                    ),
                  )
                : controller.modelResults.isEmpty
                    ? Stack(
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
                                Colors.black.withOpacity(0.6),
                                BlendMode.srcOut),
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
                                    margin:
                                        EdgeInsets.only(top: size.height * 0.2),
                                    height: size.height * 0.30,
                                    width: size.width * 0.9,
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
                            bottom: 75,
                            width: MediaQuery.of(context).size.width,
                            child: Container(
                              height: 80,
                              width: 80,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                    width: 5,
                                    color: Colors.white,
                                    style: BorderStyle.solid),
                              ),
                              child: controller.isDetecting
                                  ? IconButton(
                                      onPressed: () async {
                                        await controller.stopImageStream();
                                      },
                                      icon: const Icon(
                                        Icons.stop,
                                        color: Colors.red,
                                      ),
                                      iconSize: 50,
                                    )
                                  : IconButton(
                                      onPressed: () async {
                                        await controller.startImageStream();
                                      },
                                      icon: const Icon(
                                        Icons.play_arrow,
                                        color: Colors.white,
                                      ),
                                      iconSize: 50,
                                    ),
                            ),
                          ),
                        ],
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        itemCount: controller.modelResults.length,
                        itemBuilder: (context, index) {
                          Map<String, dynamic> result =
                              controller.modelResults[index];
                          return Card(
                            child: Column(
                              children: [
                                Text(
                                  result['tag'].toString().toUpperCase(),
                                  style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 6),
                                Image.memory(result['image'] as Uint8List),
                                const SizedBox(height: 6),
                              ],
                            ),
                          );
                        },
                      ),
            floatingActionButton: FloatingActionButton(
              onPressed: () async {
                await controller.stopImageStream();
              },
              child: const Icon(Icons.restart_alt_rounded),
            ),
          );
        });
  }
}
