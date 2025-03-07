import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/components/avatar/gf_avatar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:sizer/sizer.dart';
import 'package:vnrdn_tai/controllers/auth_controller.dart';
import 'package:vnrdn_tai/controllers/global_controller.dart';
import 'package:vnrdn_tai/screens/settings/setting_screen.dart';
import 'package:vnrdn_tai/services/UserService.dart';
import 'package:vnrdn_tai/shared/constants.dart';
import 'package:vnrdn_tai/utils/dialog_util.dart';
import 'package:vnrdn_tai/utils/firebase_options.dart';
import 'package:vnrdn_tai/utils/form_validator.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<StatefulWidget> createState() => _ProfileState();
}

class _ProfileState extends State<ProfileScreen> {
  final profileFormKey = GlobalKey<FormState>();
  final displayNameController = TextEditingController();
  final emailController = TextEditingController();
  String lastImageUrl = '';
  String newImageUrl = '';

  GlobalController gc = Get.find<GlobalController>();
  AuthController ac = Get.find<AuthController>();

  final imagePicker = ImagePicker();
  PlatformFile? pickedFile;
  UploadTask? uploadTask;

  @override
  void dispose() {
    displayNameController.dispose();
    emailController.dispose();
    super.dispose();
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
      uploadTempImage();
    });
  }

  Future<String> uploadTempImage() async {
    if (pickedFile != null) {
      GlobalController gc = Get.find<GlobalController>();
      final ext = pickedFile!.name.split('.').last;
      final path =
          'images/avatar/temp/${gc.userId.value}_${DateTime.now().toUtc()}.$ext';
      final file = File(pickedFile!.path!);

      final ref = FirebaseStorage.instance.ref().child(path);
      uploadTask = ref.putFile(file);

      final snapshot = await uploadTask!.whenComplete(() {});

      await snapshot.ref.getDownloadURL().then((url) {
        url = url.split('&token').first;
        ac.updateAvatar(url);
        newImageUrl = url;
        setState(() {});
        return url;
      });
      return '';
    }
    return 'doNotPick';
  }

  Future<String> uploadImage() async {
    if (pickedFile != null && newImageUrl.isNotEmpty) {
      GlobalController gc = Get.find<GlobalController>();
      final ext = pickedFile!.name.split('.').last;
      final path =
          'images/avatar/${gc.userId.value}_${DateTime.now().toUtc()}.$ext';
      final file = File(pickedFile!.path!);

      final ref = FirebaseStorage.instance.ref().child(path);
      uploadTask = ref.putFile(file);

      final snapshot = await uploadTask!.whenComplete(() {});

      await snapshot.ref.getDownloadURL().then((url) {
        return url.split('&token').first;
      });
      return '';
    }
    return 'doNotPick';
  }

  void handleUpdateProfile() async {
    context.loaderOverlay.show();
    String imageUrl =
        ac.avatar.value.isNotEmpty ? ac.avatar.value : defaultAvatarUrl;
    await UserService()
        .updateProfile(
            imageUrl, emailController.text, displayNameController.text)
        .then((value) {
      context.loaderOverlay.hide();
      if (value.isNotEmpty) {
        if (value.toLowerCase().contains('thay đổi')) {
          // deleteOldImage();
          DialogUtil.showAwesomeDialog(
              context,
              DialogType.success,
              "Thành công",
              "Thông tin của bạn đã được thay đổi thành công!",
              () => Get.off(() => const SettingsScreen()),
              null);
        } else {
          DialogUtil.showAwesomeDialog(
              context,
              DialogType.error,
              "Thất bại",
              value.isNotEmpty
                  ? value
                  : 'Có lỗi xảy ra.\nVui lòng thử lại sau.',
              () {},
              null);
        }
      } else {
        DialogUtil.showAwesomeDialog(
            context,
            DialogType.error,
            "Thất bại",
            value.isNotEmpty ? value : 'Thông tin người dùng không đúng.',
            () {},
            null);
      }
    });
  }

  handleCancel() async {
    if (pickedFile != null) {
      ac.updateAvatar(lastImageUrl);

      // final storageRef = FirebaseStorage.instance.ref();
      // lastImageUrl = lastImageUrl.split('images').last;
      // final desertRef =
      //     storageRef.child('images${lastImageUrl.split('?').first}');
      // await desertRef.delete();
    }

    Get.off(const SettingsScreen());
  }

  deleteOldImage() async {
    if (!lastImageUrl.contains('default')) {
      final storageRef = FirebaseStorage.instance.ref();
      lastImageUrl = lastImageUrl.split('images').last;
      final desertRef =
          storageRef.child('images${lastImageUrl.split('?').first}');
      await desertRef.delete();
    }
  }

  @override
  void initState() {
    super.initState();
    lastImageUrl = ac.avatar.value;
  }

  @override
  Widget build(BuildContext context) {
    displayNameController.text = ac.displayName.value;
    emailController.text = ac.email.value;

    return WillPopScope(
      onWillPop: () async {
        return await true;
      },
      child: Scaffold(
        key: UniqueKey(),
        backgroundColor: kPrimaryBackgroundColor,
        appBar: AppBar(
          title: const Text("Cập nhật thông tin"),
          elevation: 1,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: handleCancel,
          ),
        ),
        body: KeyboardVisibilityBuilder(
          builder: (p0, isKeyboardVisible) => Form(
            key: profileFormKey,
            child: Column(children: [
              const SizedBox(
                height: 20.0,
              ),
              Padding(
                padding: const EdgeInsets.all(kDefaultPaddingValue),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        captureImage();
                      },
                      child: GFAvatar(
                        radius: isKeyboardVisible ? 15.w : 30.w,
                        backgroundImage: ac.avatar.value.isNotEmpty
                            ? NetworkImage(ac.avatar.value)
                            : const NetworkImage(defaultAvatarUrl),
                      ),
                    ),
                    TextFormField(
                      controller: displayNameController,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      cursorColor: kPrimaryButtonColor,
                      decoration: InputDecoration(
                        labelText: "Tên hiển thị",
                        hintText: ac.displayName.value,
                        prefixIcon: const Padding(
                          padding: EdgeInsets.all(kDefaultPaddingValue / 2),
                          child: Icon(Icons.ac_unit_rounded),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: kDefaultPaddingValue),
                      child: TextFormField(
                        validator: (value) => FormValidator.validEmail(value),
                        controller: emailController,
                        textInputAction: TextInputAction.done,
                        cursorColor: kPrimaryButtonColor,
                        decoration: InputDecoration(
                          labelText: "Email",
                          hintText: ac.email.value,
                          prefixIcon: const Padding(
                            padding: EdgeInsets.all(kDefaultPaddingValue / 2),
                            child: Icon(Icons.mail_outline_rounded),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: kDefaultPaddingValue),
                    Hero(
                      tag: "update_btn",
                      child: ElevatedButton(
                        onPressed: () {
                          if (profileFormKey.currentState!.validate()) {
                            handleUpdateProfile();
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: kDefaultPaddingValue),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Cập nhật ngay".toUpperCase()),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
