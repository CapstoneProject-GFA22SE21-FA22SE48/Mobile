import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';
import 'package:getwidget/components/dropdown/gf_dropdown.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:vnrdn_tai/controllers/global_controller.dart';
import 'package:sizer/sizer.dart';
import 'package:vnrdn_tai/controllers/maps_controller.dart';
import 'package:vnrdn_tai/models/GPSSign.dart';
import 'package:vnrdn_tai/models/SignModificationRequest.dart';
import 'package:vnrdn_tai/models/dtos/AdminDTO.dart';
import 'package:vnrdn_tai/models/dtos/signCategoryDTO.dart';
import 'package:vnrdn_tai/screens/analysis/analysis_screen.dart';
import 'package:vnrdn_tai/screens/container_screen.dart';
import 'package:vnrdn_tai/services/SignModificationRequestService.dart';
import 'package:vnrdn_tai/services/SignService.dart';
import 'package:vnrdn_tai/services/UserService.dart';
import 'package:vnrdn_tai/shared/constants.dart';
import 'package:vnrdn_tai/shared/snippets.dart';
import 'package:vnrdn_tai/utils/dialog_util.dart';

class CreateGpssignScreen extends StatefulWidget {
  dynamic adminId;
  String imagePath;
  String signNumber;
  CreateGpssignScreen(
      {super.key, this.adminId, this.imagePath = "", this.signNumber = ""});

  @override
  State<StatefulWidget> createState() => _CreateGpssignState();
}

class _CreateGpssignState extends State<CreateGpssignScreen> {
  final imagePicker = ImagePicker();
  final searchSignController = TextEditingController();
  PlatformFile? pickedFile;
  UploadTask? uploadTask;
  late List<AdminDTO> listAdmin = [];
  dynamic adminId;
  dynamic selectedSign;
  late List<String> _listDropdownSignsName = [];
  late List<DropdownMenuItem> _listDropdownSigns = [];
  late List<DropdownMenuItem> _listDropdownAdmin = [];
  late Future<List<SignCategoryDTO>> signCategories =
      SignService().GetSignCategoriesDTOList();

  void setSignDropdownList(List<SignCategoryDTO> categories) {
    for (var category in categories) {
      for (var sign in category.searchSignDTOs) {
        _listDropdownSignsName.add(sign.name);
        _listDropdownSigns.add(
          DropdownMenuItem(
            value: sign.name,
            child: Row(children: [
              CachedNetworkImage(
                imageUrl: sign.imageUrl!.split('&token').first,
                imageBuilder: (context, imageProvider) => Container(
                  width: 10.w,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                ),
                placeholder: (context, url) => Container(
                  alignment: Alignment.center,
                  child:
                      const CircularProgressIndicator(), // you can add pre loader iamge as well to show loading.
                ), //show progress  while loading image
                errorWidget: (context, url, error) =>
                    Image.asset("assets/images/alt_img.png"),
              ),
              Padding(
                padding: const EdgeInsets.only(left: kDefaultPaddingValue),
                child: Text(sign.name.length > 33
                    ? '${sign.name.substring(0, 33)}...'
                    : sign.name),
              )
            ]),
          ),
        );
      }
    }
    String? foundSign;
    if (widget.signNumber != "") {
      foundSign = _listDropdownSignsName
          .firstWhereOrNull((element) => element.contains(widget.signNumber));
    }
    if (mounted) {
      setState(() {
        if (foundSign != null) {
          selectedSign = foundSign;
        }
      });
    }
  }

  Color getColorByCategory(String name) {
    name = name.toLowerCase();
    if (name.contains('cấm')) {
      return kDangerButtonColor;
    } else if (name.contains('cảnh báo')) {
      return kWarningButtonColor;
    } else if (name.contains('chỉ dẫn')) {
      return kPrimaryButtonColor;
    } else if (name.contains('hiệu lệnh')) {
      return kBlueAccentBackground;
    } else {
      return kDisabledButtonColor;
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
          name: captured.path.split('/').last, path: captured.path, size: 1024);
    });
  }

  Future setImage(String path) async {
    // final captured = await imagePicker.getImage(source: ImageSource.camera);
    // if (captured == null) return;
    setState(() {
      pickedFile =
          PlatformFile(name: path.split('/').last, path: path, size: 1024);
    });
  }

  Future submitCreate(BuildContext context) async {
    print(context.loaderOverlay);
    context.loaderOverlay.show();

    print('Size before: ${pickedFile!.size}');
    print('Size actual: ${File(pickedFile!.path!).lengthSync()}');

    GlobalController gc = Get.put(GlobalController());
    // final oldFile = widget.imageUrl.split('user-feedbacks/sign-position/').last;
    final ext = pickedFile!.name.split('.').last;
    final path =
        'user-feedbacks/sign-position/confirmed_${gc.userId.value}_${DateTime.now().toUtc()}.$ext';
    final file = await compressFile(File(pickedFile!.path!));


    final ref = FirebaseStorage.instance.ref().child(path);
    uploadTask = ref.putFile(file);

    final snapshot = await uploadTask!.whenComplete(() {});

    await snapshot.ref.getDownloadURL().then((url) {
      SignService().GetSignByName(selectedSign).then((sign) {
        if (sign != null) {
          MapsController mapsController = Get.put(MapsController());
          mapsController.location.getLocation().then((location) {
            SignModificationRequestService()
                .createScribeRequestGpsSign(
              url.split('&token').first,
              adminId,
              GPSSign(sign.id, sign.id, '', '', location.latitude!,
                  location.longitude!),
            )
                .then((request) {
              context.loaderOverlay.hide();
              if (request != null) {
                DialogUtil.showAwesomeDialog(
                    context,
                    DialogType.success,
                    "Tạo thành công",
                    "Yêu cầu tạo biển $selectedSign thành công",
                    () => Get.off(() => const ContainerScreen()),
                    null);

                createNotification(request).then((sent) => print(sent));
              } else {
                DialogUtil.showAwesomeDialog(
                    context,
                    DialogType.error,
                    "Tạo thất bại",
                    "Có lỗi xảy ra.\nVui lòng thử lại sau",
                    () {},
                    null);
              }
            });
          });
        }
      });
    });
  }

  Future<bool> createNotification(SignModificationRequest rom) async {
    GlobalController gc = Get.put(GlobalController());
    DatabaseReference ref = FirebaseDatabase.instance.ref('notifications');

    String action = 'đề xuất thêm mới';
    String name = rom.imageUrl.split("%2F").last.split(".").first;
    await ref.push().set({
      "senderId": gc.userId.value,
      "senderUsername": gc.username.value,
      "receiverId": rom.adminId,
      "subjectId": rom.modifyingGpssignId ?? '',
      "receiverUsername":
          _listDropdownAdmin.firstWhere((e) => e.value == rom.adminId).value,
      "createdDate": "${DateFormat('EEE MMM dd yyyy HH:mm:ss').format(DateTime.now())} GMT+0700 (Indochina Time)",
      "subjectType": "GPSSign",
      "relatedDescription": "GPS của biển số...",
      "action": action,
      "isRead": false
    });
    return true;
  }

  @override
  void initState() {
    context.loaderOverlay.show();
    if (widget.adminId != null) {
      adminId = widget.adminId;
    }
    signCategories.then((list) => setSignDropdownList(list));
    UserService().getAdmins().then((list) {
      if (list.isNotEmpty) {
        listAdmin = list;
        list.forEach((element) {
          _listDropdownAdmin.add(DropdownMenuItem<String>(
            value: element.id,
            child: Text(element.displayName ?? element.username),
          ));
        });
      }

      //Return from AnalysisScreen
      if (widget.imagePath != "") {
        setImage(widget.imagePath);
      }
      context.loaderOverlay.hide();
      if (mounted) {
        setState(() {});
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.offAll(() => ContainerScreen());
        return await true;
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: AppBar(
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
          elevation: 0,
          title: const Text('Tạo biển báo tại đây'),
        ),
        body: KeyboardVisibilityBuilder(
          builder: (kContext, isKeyboardVisible) {
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
                        if (mounted) {
                          setState(() {
                            adminId = newValue;
                          });
                        }
                      },
                      items: _listDropdownAdmin,
                      isExpanded: true,
                    ),
                  ),
                  const SizedBox(height: kDefaultPaddingValue),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Biển báo:',
                        style: TextStyle(
                          fontSize: FONTSIZES.textPrimary,
                          color: Colors.blueAccent,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: kDefaultPaddingValue / 2),
                      DropdownButtonHideUnderline(
                        child: DropdownButton2(
                          isExpanded: true,
                          buttonOverlayColor:
                              MaterialStateProperty.all(Colors.white),
                          buttonPadding: const EdgeInsets.symmetric(
                              horizontal: kDefaultPaddingValue / 2),
                          buttonDecoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(color: Colors.grey, width: 1),
                          ),
                          hint: const Text(
                            'Chọn biển báo',
                            style: TextStyle(
                              fontSize: FONTSIZES.textPrimary,
                              color: kDisabledTextColor,
                            ),
                          ),

                          items: _listDropdownSigns.isNotEmpty
                              ? _listDropdownSigns.toList()
                              : [
                                  DropdownMenuItem(
                                    alignment: Alignment.centerLeft,
                                    child: Transform.scale(
                                      scale: 0.6,
                                      child: loadingScreen(),
                                    ),
                                  )
                                ],
                          value: selectedSign,
                          onChanged: (value) {
                            if (mounted) {
                              setState(() {
                                selectedSign = value as String;
                              });
                            }
                          },
                          scrollbarAlwaysShow: true,
                          scrollbarRadius:
                              const Radius.circular(kDefaultPaddingValue),
                          buttonHeight: selectedSign == null ? 5.h : 8.h,
                          buttonWidth: 100.w,
                          itemHeight: 8.h,
                          buttonElevation: 10,
                          dropdownElevation: 2,
                          dropdownMaxHeight: 50.h,
                          dropdownDecoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  bottomRight:
                                      Radius.circular(kDefaultPaddingValue),
                                  bottomLeft:
                                      Radius.circular(kDefaultPaddingValue))),

                          searchController: searchSignController,
                          searchInnerWidget: Padding(
                            padding: const EdgeInsets.only(
                              top: 8,
                              bottom: 4,
                              right: 8,
                              left: 8,
                            ),
                            child: TextFormField(
                              controller: searchSignController,
                              decoration: InputDecoration(
                                isDense: true,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: kDefaultPaddingValue / 2,
                                  vertical: kDefaultPaddingValue,
                                ),
                                hintText: 'Tìm biển báo...',
                                hintStyle: const TextStyle(fontSize: 18),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                      kDefaultPaddingValue / 2),
                                ),
                              ),
                            ),
                          ),
                          searchMatchFn: (item, searchValue) {
                            return (item.value
                                .toString()
                                .contains(searchValue));
                          },
                          //This to clear the search value when you close the menu
                          onMenuStateChange: (isOpen) {
                            if (!isOpen) {
                              searchSignController.clear();
                            }
                          },
                        ),
                      )
                    ],
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
                        onPressed: () => Get.off(() =>
                            AnalysisScreen(isAddGps: true, adminId: adminId)),
                        child: const RotatedBox(
                            quarterTurns: 1, child: Icon(Icons.flip_rounded)),
                      ),
                      SizedBox(width: 1.w),
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
                    height: pickedFile != null ? 50.h : 30.h,
                    width: 100.w,
                    margin:
                        const EdgeInsets.only(top: kDefaultPaddingValue / 2),
                    child: pickedFile != null
                        ? Container(
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
                    onPressed: pickedFile != null &&
                            adminId != null &&
                            selectedSign != null
                        ? () => submitCreate(context)
                        : null,
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
      ),
    );
  }
}
