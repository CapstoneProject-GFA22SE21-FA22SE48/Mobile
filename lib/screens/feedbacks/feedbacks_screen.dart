import 'dart:developer';
import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';
import 'package:getwidget/components/dropdown/gf_dropdown.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:vnrdn_tai/controllers/auth_controller.dart';
import 'package:vnrdn_tai/controllers/global_controller.dart';
import 'package:sizer/sizer.dart';
import 'package:vnrdn_tai/controllers/maps_controller.dart';
import 'package:vnrdn_tai/models/GPSSign.dart';
import 'package:vnrdn_tai/screens/container_screen.dart';
import 'package:vnrdn_tai/services/FeedbackService.dart';
import 'package:vnrdn_tai/services/GPSSignService.dart';
import 'package:vnrdn_tai/services/UserService.dart';
import 'package:vnrdn_tai/shared/constants.dart';
import 'package:vnrdn_tai/utils/dialog_util.dart';

class FeedbacksScreen extends StatefulWidget {
  FeedbacksScreen({
    super.key,
    this.type = '',
    this.sign,
  });

  String type;
  GPSSign? sign;

  @override
  State<StatefulWidget> createState() => _FeedbackClassState();
}

class _FeedbackClassState extends State<FeedbacksScreen> {
  final imagePicker = ImagePicker();
  List<DropdownMenuItem<String>> _listDropdown = [];
  late List<DropdownMenuItem> _listDropdownAdmin = [];
  dynamic adminId;
  dynamic reason;
  PlatformFile? pickedFile;
  UploadTask? uploadTask;

  String getTitle(String type) {
    switch (type) {
      case "gpsSign":
        return "Vị trí biển báo";
      case "sign":
        return "Thông tin biển báo";
      default:
        return "Luật";
    }
  }

  Future selectImage() async {
    final picked = await FilePicker.platform.pickFiles();
    if (picked == null) return;

    setState(() {
      pickedFile = picked.files.first;
    });
  }

  Future captureImage() async {
    final captured = await imagePicker.getImage(source: ImageSource.camera);
    if (captured == null) return;

    setState(() {
      pickedFile = PlatformFile(
          name: captured.path.split('/').last,
          path: captured.path,
          size: 1024 * 1024 * 30);
    });
  }

  Future uploadImage(BuildContext context) async {
    context.loaderOverlay.show();
    GlobalController gc = Get.put(GlobalController());
    final ext = pickedFile!.name.split('.').last;
    final path =
        'user-feedbacks/sign-position/${gc.userId.value}_${DateTime.now().toUtc()}.$ext';
    final file = File(pickedFile!.path!);

    final ref = FirebaseStorage.instance.ref().child(path);
    uploadTask = ref.putFile(file);

    final snapshot = await uploadTask!.whenComplete(() {});

    await snapshot.ref.getDownloadURL().then((url) {
      MapsController mapsController = Get.put(MapsController());

      mapsController.location.getLocation().then((location) {
        GPSSignService()
            .AddGpsSign(
                widget.sign != null ? widget.sign!.signId : null,
                widget.sign != null
                    ? widget.sign!.latitude
                    : location.latitude!,
                widget.sign != null
                    ? widget.sign!.longitude
                    : location.longitude!,
                reason == 'noSignHere' ? true : false)
            .then((newSign) {
          FeedbackService()
              .createGpsSignsModificationRequest(
            reason,
            url.split('&token').first,
            widget.sign,
            newSign,
          )
              .then((value) {
            context.loaderOverlay.hide();
            if (value != null) {
              DialogUtil.showAwesomeDialog(
                  context,
                  DialogType.success,
                  "Phản hồi thành công",
                  "Cảm ơn về phản hồi của bạn!\nChúng tôi sẽ kiểm tra và chỉnh sửa sớm nhất có thể.",
                  () => Get.to(() => const ContainerScreen()),
                  null);
            } else {
              DialogUtil.showAwesomeDialog(
                  context,
                  DialogType.error,
                  "Phản hồi thất bại",
                  "Có lỗi xảy ra.\nChúng tôi đang khắc phục sớm nhất có thể.",
                  () {},
                  null);
            }
          });
        });
      });
    });
  }

  @override
  void initState() {
    super.initState();
    if (widget.sign != null) {
      _listDropdown = <DropdownMenuItem<String>>[
        const DropdownMenuItem<String>(
          value: "noSignHere",
          child: Text.rich(
            TextSpan(children: [
              TextSpan(
                  text: "Tôi không thấy biển báo ở đây") //nhưng bản đồ hiển thị
            ]),
          ),
        ),
        const DropdownMenuItem<String>(
          value: "wrongSign",
          child: Text("Biển báo không giống như trên bản đồ",
              overflow: TextOverflow.ellipsis),
        ),
      ];
      UserService().getAdmins().then((list) {
        if (list.isNotEmpty) {
          list.forEach((element) {
            _listDropdownAdmin.add(DropdownMenuItem<String>(
              value: element.id,
              child: Text(element.displayName ?? element.username),
            ));
          });
        }
        setState(() {});
        context.loaderOverlay.hide();
      });
    } else {
      _listDropdown = <DropdownMenuItem<String>>[
        const DropdownMenuItem<String>(
          value: "hasSignHere",
          child: Text("Biển báo ở đây nhưng bản đồ không hiển thị",
              overflow: TextOverflow.ellipsis),
        ),
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    AuthController ac = Get.find<AuthController>();
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 0,
        title: const Text('Phản hồi thông tin'),
      ),
      body: KeyboardVisibilityBuilder(
        builder: (context, isKeyboardVisible) {
          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Container(
              height: 90.h,
              width: 100.w,
              padding: const EdgeInsets.symmetric(
                horizontal: kDefaultPaddingValue,
                vertical: kDefaultPaddingValue,
              ),
              color: Colors.white70,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    '',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: FONTSIZES.textHuge,
                    ),
                  ),
                  ac.role.value == 1 ?
                  (const Text(
                    'Gửi yêu cầu tới:',
                    style: TextStyle(
                      fontSize: FONTSIZES.textPrimary,
                      color: Colors.blueAccent,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: kDefaultPaddingValue / 2),
                  DropdownButtonHideUnderline(
                    child: GFDropdown(
                      hint: const Text('Chọn quản trị viên'),
                      padding: const EdgeInsets.all(kDefaultPaddingValue / 2),
                      borderRadius: BorderRadius.circular(5),
                      border: const BorderSide(color: Colors.grey, width: 1),
                      dropdownButtonColor: Colors.white,
                      value: adminId,
                      onChanged: (newValue) {
                        setState(() {
                          adminId = newValue ?? 3;
                        });
                      },
                      items: _listDropdownAdmin,
                      isExpanded: true,
                    ),
                  ),
                  const SizedBox(height: kDefaultPaddingValue),) : Container(),
                  const Text(
                    'Nguyên nhân:',
                    style: TextStyle(
                      fontSize: FONTSIZES.textPrimary,
                      color: Colors.blueAccent,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: kDefaultPaddingValue),
                  DropdownButtonHideUnderline(
                    child: GFDropdown(
                      hint: const Text('Hãy chọn nguyên nhân'),
                      padding: const EdgeInsets.all(kDefaultPaddingValue / 2),
                      borderRadius: BorderRadius.circular(5),
                      border: const BorderSide(color: Colors.grey, width: 1),
                      dropdownButtonColor: Colors.white,
                      value: reason,
                      onChanged: (newValue) {
                        setState(() {
                          reason = newValue ?? '';
                        });
                      },
                      items: _listDropdown,
                      isExpanded: true,
                    ),
                  ),
                  const SizedBox(height: kDefaultPaddingValue),
                  Row(
                    children: [
                      const Text(
                        'Hình ảnh chứng minh:',
                        style: TextStyle(
                          fontSize: FONTSIZES.textPrimary,
                          color: Colors.blueAccent,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      ElevatedButton(
                        onPressed: captureImage,
                        child: const Icon(Icons.camera_alt_rounded),
                      ),
                      SizedBox(width: 1.w),
                      ElevatedButton(
                        onPressed: selectImage,
                        child: const Icon(Icons.upload_rounded),
                      ),
                    ],
                  ),
                  Container(
                    height: 50.h,
                    width: 100.w,
                    margin:
                        const EdgeInsets.only(top: kDefaultPaddingValue / 2),
                    child: pickedFile != null
                        ? Container(
                            height: 15.h,
                            width: 80.w,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                color: Colors.grey,
                                style: BorderStyle.solid,
                                width: 3,
                              ),
                              borderRadius: BorderRadius.circular(
                                kDefaultPaddingValue / 2,
                              ),
                            ),
                            child: Center(
                              child: pickedFile != null
                                  ? Image.file(
                                      File(pickedFile!.path!),
                                      fit: BoxFit.contain,
                                    )
                                  : const Text(
                                      "Xem trước tại đây",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.black54,
                                      ),
                                    ),
                            ),
                          )
                        : Container(
                            height: 10.h,
                            width: 100.w,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                color: Colors.grey,
                                style: BorderStyle.solid,
                                width: 3,
                              ),
                              borderRadius: BorderRadius.circular(
                                kDefaultPaddingValue / 2,
                              ),
                            ),
                          ),
                  ),
                  const SizedBox(
                    height: kDefaultPaddingValue,
                  ),
                  ElevatedButton(
                    onPressed:
                        pickedFile != null ? () => uploadImage(context) : null,
                    child: Padding(
                      padding: EdgeInsets.all((kDefaultPaddingValue / 8).h),
                      child: const Text('Gửi phản hồi'),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
