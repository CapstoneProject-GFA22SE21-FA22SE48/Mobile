import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:camera/camera.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:sizer/sizer.dart';
import 'package:vnrdn_tai/controllers/analysis_controller.dart';
import 'package:vnrdn_tai/controllers/auth_controller.dart';
import 'package:vnrdn_tai/controllers/global_controller.dart';
import 'package:vnrdn_tai/models/dtos/SignFeedbackDTO.dart';
import 'package:vnrdn_tai/screens/container_screen.dart';
import 'package:vnrdn_tai/services/FeedbackService.dart';
import 'package:vnrdn_tai/shared/constants.dart';
import 'package:vnrdn_tai/utils/dialog_util.dart';
import 'package:vnrdn_tai/widgets/templated_buttons.dart';

class SignContentFeedbackScreen extends StatelessWidget {
  const SignContentFeedbackScreen({super.key});

  Future uploadRom(AnalysisController ac, BuildContext context) async {
    GlobalController gc = Get.find<GlobalController>();
    var pickedFile = ac.image;
    final path = 'user-feedbacks/sign-content-feedbacks/${pickedFile!.name}';
    final file = File(pickedFile.path);
    final ref = FirebaseStorage.instance.ref().child(path);
    var uploadTask = ref.putFile(file);
    context.loaderOverlay.show();
    final snapshot = await uploadTask.whenComplete(() {});
    await snapshot.ref.getDownloadURL().then((url) async {
      url = url.split('&token').first;
      SignFeedbackDTO rom = SignFeedbackDTO(
          gc.userId.value, null, null, gc.userId.value, null, 3, url, 1);
      var res = await FeedbackService().createSignsModificationRequest(rom);
      if (res == true) {
        ac.clearFeedbackImage();
        // ignore: use_build_context_synchronously
        DialogUtil.showAwesomeDialog(
            context,
            DialogType.success,
            "Phản hồi thành công",
            "Cảm ơn về phản hồi của bạn!\nChúng tôi sẽ kiểm tra và chỉnh sửa sớm nhất có thể.",
            () => Get.to(() => const ContainerScreen()),
            null);
        context.loaderOverlay.hide();
      } else {
        // ignore: use_build_context_synchronously
        DialogUtil.showAwesomeDialog(
            context,
            DialogType.error,
            "Phản hồi thất bại",
            "Có lỗi xảy ra.\nChúng tôi đang khắc phục sớm nhất có thể.",
            () {},
            null);
        context.loaderOverlay.hide();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    AuthController auc = Get.put(AuthController());
    AnalysisController ac = Get.put(AnalysisController());
    return GetBuilder<AnalysisController>(
        init: ac,
        builder: (controller) {
          return Scaffold(
              appBar: AppBar(
                title: const Text("Báo cáo sự cố"),
                elevation: 0,
                actions: [
                  IconButton(
                      icon: const Icon(
                        Icons.send,
                        color: Colors.blue,
                      ),
                      onPressed: () {
                        ac.image != null
                            ? uploadRom(ac, context)
                            : Get.snackbar(
                                'Lưu ý', 'Vui lòng cung cấp hình ảnh trước',
                                colorText: Colors.blueGrey,
                                isDismissible: true);

                        // Get.to(() => CartPage(), preventDuplicates: false);
                      }),
                ],
              ),
              body: SafeArea(
                  child: Stack(
                children: [
                  Column(
                    children: [
                      SizedBox(
                        width: 100.w,
                        height: 80.h,
                        child: controller.imagePath == ""
                            ? CameraPreview(controller.cameraController)
                            : Image.file(
                                File(controller.imagePath!),
                                fit: BoxFit.fill,
                                height: double.infinity,
                                width: double.infinity,
                                alignment: Alignment.center,
                              ),
                      )
                    ],
                  ),
                  Positioned(
                    left: 3.w,
                    top: 1.h,
                    child: Opacity(
                      opacity: 0.3,
                      child: Container(
                        width: 42.w,
                        height: 28.h,
                        padding: EdgeInsets.all(kDefaultPaddingValue),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.circular(kDefaultPaddingValue)),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                // Padding(
                                //   padding: const EdgeInsets.only(
                                //       top: kDefaultPaddingValue),
                                //   child: Text('Người dùng: ',
                                //       style: Theme.of(context)
                                //           .textTheme
                                //           .headline4
                                //           ?.copyWith(
                                //               color: Colors.black,
                                //               fontWeight: FontWeight.normal,
                                //               fontSize: FONTSIZES.textPrimary)),
                                // ),
                                // Text(auc.displayName.value,
                                //     style: Theme.of(context)
                                //         .textTheme
                                //         .headline5
                                //         ?.copyWith(
                                //             color: Colors.black,
                                //             fontWeight: FontWeight.normal,
                                //             fontSize: FONTSIZES.textPrimary)),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: kDefaultPaddingValue),
                                  child: Text('Sự cố xảy ra lúc:',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline5
                                          ?.copyWith(
                                              color: Colors.black,
                                              fontWeight: FontWeight.normal,
                                              fontSize: FONTSIZES.textPrimary)),
                                ),
                                Text(
                                    DateFormat('hh:mm dd/MM/yyyy')
                                        .format(DateTime.now()),
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline5
                                        ?.copyWith(
                                            color: Colors.black,
                                            fontWeight: FontWeight.normal,
                                            fontSize: FONTSIZES.textPrimary)),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: kDefaultPaddingValue),
                                  child: Text('Chi tiết báo cáo:',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline5
                                          ?.copyWith(
                                              color: Colors.black,
                                              fontWeight: FontWeight.normal,
                                              fontSize: FONTSIZES.textPrimary)),
                                ),
                                Text('Không nhận diện\n được biển báo',
                                    maxLines: 2,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline5
                                        ?.copyWith(
                                            color: Colors.black,
                                            fontWeight: FontWeight.normal,
                                            fontSize: FONTSIZES.textPrimary)),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: kDefaultPaddingValue),
                                  child: Text('Loại báo cáo:',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline5
                                          ?.copyWith(
                                              color: Colors.black,
                                              fontWeight: FontWeight.normal,
                                              fontSize: FONTSIZES.textPrimary)),
                                ),
                                Text('Lỗi ứng dụng',
                                    maxLines: 2,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline5
                                        ?.copyWith(
                                            color: Colors.black,
                                            fontWeight: FontWeight.normal,
                                            fontSize: FONTSIZES.textPrimary)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  controller.imagePath == ""
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(
                                  kDefaultPaddingValue * 2),
                              child: Text(
                                  'Xin vui lòng lưu lại hình ảnh làm bằng chứng trước khi gửi phản hồi!',
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline6
                                      ?.copyWith(
                                          color: Colors.white60,
                                          fontWeight: FontWeight.normal)),
                            ),
                            SizedBox(height: 12.h),
                          ],
                        )
                      : Container(),
                  controller.imagePath == ""
                      ? Positioned(
                          left: 38.w,
                          top: 79.h,
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: kDefaultPaddingValue, left: 18),
                            child: ElevatedButton(
                                onPressed: () async {
                                  await controller
                                      .takeSignContentFeebackImage();
                                },
                                style: ElevatedButton.styleFrom(
                                    shape: const CircleBorder(),
                                    fixedSize: const Size(50, 50)),
                                child: const Icon(Icons.camera_alt, size: 28)),
                          ),
                        )
                      : Container(),
                  controller.imagePath != ""
                      ? Positioned(
                          right: 1.w,
                          top: 0.h,
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: kDefaultPaddingValue, left: 18),
                            child: ElevatedButton(
                                onPressed: () {
                                  controller.clearFeedbackImage();
                                },
                                style: ElevatedButton.styleFrom(
                                    shape: const CircleBorder(),
                                    fixedSize: const Size(30, 30)),
                                child: const Icon(Icons.clear, size: 28)),
                          ),
                        )
                      : Container(),
                ],
              )));
        });
  }
}
