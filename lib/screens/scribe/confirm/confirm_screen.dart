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
import 'package:vnrdn_tai/controllers/global_controller.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:sizer/sizer.dart';
import 'package:vnrdn_tai/controllers/maps_controller.dart';
import 'package:vnrdn_tai/models/GPSSign.dart';
import 'package:vnrdn_tai/models/SignModificationRequest.dart';
import 'package:vnrdn_tai/screens/minimap/minimap_screen.dart';
import 'package:vnrdn_tai/screens/scribe/list_rom/list_rom_screen.dart';
import 'package:vnrdn_tai/services/FeedbackService.dart';
import 'package:vnrdn_tai/services/GPSSignService.dart';
import 'package:vnrdn_tai/services/SignModificationRequestService.dart';
import 'package:vnrdn_tai/services/UserService.dart';
import 'package:vnrdn_tai/shared/constants.dart';
import 'package:vnrdn_tai/utils/dialog_util.dart';
import 'package:vnrdn_tai/utils/location_util.dart';
import 'package:vnrdn_tai/widgets/templated_buttons.dart';

class ConfirmEvidenceScreen extends StatefulWidget {
  ConfirmEvidenceScreen({
    super.key,
    required this.romId,
    required this.imageUrl,
    required this.operationType,
  });

  String romId;
  String imageUrl;
  int operationType;

  @override
  State<StatefulWidget> createState() => _ConfirmEvidenceState();
}

class _ConfirmEvidenceState extends State<ConfirmEvidenceScreen> {
  final imagePicker = ImagePicker();
  PlatformFile? pickedFile;
  UploadTask? uploadTask;
  dynamic adminId;
  dynamic status;

  late List<DropdownMenuItem> _listDropdownAdmin = [];

  final List<DropdownMenuItem<int>> _listDropdown = <DropdownMenuItem<int>>[
    const DropdownMenuItem<int>(
      value: 2,
      child: Text(
        "Đã xử lý",
      ),
    ),
    const DropdownMenuItem<int>(
      value: 4,
      child: Text(
        "Đã từ chối",
      ),
    ),
  ];

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
    final result = await FilePicker.platform.pickFiles();
    if (result == null) return;

    setState(() {
      pickedFile = result.files.first;
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

  Future uploadImage() async {
    GlobalController gc = Get.put(GlobalController());
    // final oldFile = widget.imageUrl.split('user-feedbacks/sign-position/').last;
    final ext = pickedFile!.name.split('.').last;
    final path =
        'user-feedbacks/sign-position/confirmed_${gc.userId.value}_${DateTime.now().toUtc()}.$ext';
    final file = File(pickedFile!.path!);

    final ref = FirebaseStorage.instance.ref().child(path);
    uploadTask = ref.putFile(file);

    final snapshot = await uploadTask!.whenComplete(() {});

    await snapshot.ref.getDownloadURL().then((url) {
      SignModificationRequestService()
          .confirmEvidence(
              widget.romId, status, url.split('&token').first, adminId)
          .then((value) {
        if (value != null) {
          DialogUtil.showAwesomeDialog(
              context,
              DialogType.success,
              "Thành công",
              "Xác nhận thành công!\nQuay về danh sách phản hồi",
              () => Get.off(() => ListRomScreen()),
              () {});
        } else {
          DialogUtil.showAwesomeDialog(context, DialogType.error, "Thất bại",
              "Xác nhận thất bại.\n Vui lòng kiểm tra lại", () {}, null);
        }
      });
    });
  }

  @override
  void initState() {
    UserService().getAdmins().then((list) {
      print(list);
      if (list.isNotEmpty) {
        list.forEach((element) {
          _listDropdownAdmin.add(DropdownMenuItem<String>(
            value: element.id,
            child: Text(element.displayName ?? element.username),
          ));
        });
      }
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 0,
        title: const Text('Xác nhận phản hồi'),
      ),
      body: KeyboardVisibilityBuilder(
        builder: (context, isKeyboardVisible) {
          return SingleChildScrollView(
            padding: kDefaultPadding,
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
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
                const SizedBox(height: kDefaultPaddingValue),
                const Text(
                  'Trạng thái:',
                  style: TextStyle(
                    fontSize: FONTSIZES.textPrimary,
                    color: Colors.blueAccent,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: kDefaultPaddingValue / 2),
                DropdownButtonHideUnderline(
                  child: GFDropdown(
                    hint: const Text('Chọn trạng thái xử lý'),
                    padding: const EdgeInsets.all(kDefaultPaddingValue / 2),
                    borderRadius: BorderRadius.circular(5),
                    border: const BorderSide(color: Colors.grey, width: 1),
                    dropdownButtonColor: Colors.white,
                    value: status,
                    onChanged: (newValue) {
                      setState(() {
                        status = newValue ?? 3;
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
                      'Hình ảnh xác nhận:',
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
                  margin: const EdgeInsets.only(top: kDefaultPaddingValue / 2),
                  child: pickedFile != null
                      ? Expanded(
                          child: Container(
                            height: 15.h,
                            width: 80.w,
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
                              child: Image.file(
                                File(pickedFile!.path!),
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        )
                      : Container(
                          height: 10.h,
                          width: 100.h,
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
                  onPressed: pickedFile != null ? uploadImage : () {},
                  child: Padding(
                    padding: EdgeInsets.all((kDefaultPaddingValue / 8).h),
                    child: const Text('Gửi Xác nhận'),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
