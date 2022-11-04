import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:getwidget/components/dropdown/gf_dropdown.dart';
import 'package:sizer/sizer.dart';
import 'package:vnrdn_tai/models/SignModificationRequest.dart';
import 'package:vnrdn_tai/services/FeedbackService.dart';
import 'package:vnrdn_tai/shared/constants.dart';

class FeedbacksScreen extends StatefulWidget {
  FeedbacksScreen({
    super.key,
    required this.type,
  });

  String type;

  @override
  State<StatefulWidget> createState() => _FeedbackClassState();
}

class _FeedbackClassState extends State<FeedbacksScreen> {
  final _listDropdown = <DropdownMenuItem<String>>[
    const DropdownMenuItem<String>(
      value: "noSignHere",
      child: Text("Tôi không thấy biển báo ở đây nhưng bản đồ hiển thị"),
    ),
    const DropdownMenuItem<String>(
      value: "hasSignHere",
      child: Text("Có biển báo ở đây nhưng bản đồ không hiển thị"),
    ),
    const DropdownMenuItem<String>(
      value: "wrongSign",
      child: Text("Biển báo không giống như trên bản đồ"),
    ),
  ];
  String reason = '';
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
    final result = await FilePicker.platform.pickFiles();
    if (result == null) return;

    setState(() {
      pickedFile = result.files.first;
    });
  }

  Future uploadImage() async {
    final path = 'user-feedbacks/${pickedFile!.name}';
    final file = File(pickedFile!.path!);

    final ref = FirebaseStorage.instance.ref().child(path);
    uploadTask = ref.putFile(file);

    final snapshot = await uploadTask!.whenComplete(() {});

    await snapshot.ref.getDownloadURL().then((url) {
      // GPSSignService()
      //     .createGpsSignsModificationRequest(
      //         reason, schoolLocation, Uri.parse(url))
      //     .then((value) {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        elevation: 0,
        title: Text('Phản hồi thông tin'),
      ),
      body: KeyboardVisibilityBuilder(
        builder: (context, isKeyboardVisible) {
          return Container(
            height: 80.h,
            width: 100.w,
            padding: const EdgeInsets.symmetric(
              horizontal: kDefaultPaddingValue,
              vertical: kDefaultPaddingValue,
            ),
            color: Colors.white70,
            child: Column(
              children: [
                const Text(
                  '',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: FONTSIZES.textHuge,
                  ),
                ),
                const Text('Nguyên nhân:'),
                const SizedBox(height: kDefaultPaddingValue),
                GFDropdown(
                  padding: const EdgeInsets.all(kDefaultPaddingValue),
                  borderRadius: BorderRadius.circular(kDefaultPaddingValue / 2),
                  border: const BorderSide(color: Colors.black12, width: 1),
                  dropdownButtonColor: Colors.white,
                  value: reason,
                  onChanged: (value) {
                    setState(() {
                      reason = value ?? '';
                    });
                  },
                  items: _listDropdown,
                ),
                const SizedBox(height: kDefaultPaddingValue),
                Row(
                  children: [
                    const Text('Hình ảnh chứng minh:'),
                    ElevatedButton(
                      onPressed: selectImage,
                      child: Text('Tải lên'),
                    ),
                  ],
                ),
                SizedBox(
                  height: 50.h,
                  width: 100.w,
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
                            )),
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
              ],
            ),
          );
        },
      ),
    );
  }
}
