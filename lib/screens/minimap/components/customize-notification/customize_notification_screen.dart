import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:sizer/sizer.dart';
import 'package:vnrdn_tai/controllers/maps_controller.dart';
import 'package:vnrdn_tai/models/dtos/searchSignDTO.dart';
import 'package:vnrdn_tai/models/dtos/signCategoryDTO.dart';
import 'package:vnrdn_tai/screens/container_screen.dart';
import 'package:vnrdn_tai/services/SignService.dart';
import 'package:vnrdn_tai/shared/constants.dart';
import 'package:vnrdn_tai/utils/dialog_util.dart';
import 'package:vnrdn_tai/utils/io_utils.dart';

// ignore: must_be_immutable
class CustomizeNotificationScreen extends StatefulWidget {
  const CustomizeNotificationScreen({super.key});

  @override
  State<StatefulWidget> createState() => _CustomNotiState();
}

class _CustomNotiState extends State<CustomizeNotificationScreen> {
  MapsController mc = Get.find<MapsController>();
  final searchSignController = TextEditingController();
  dynamic adminId;
  List<dynamic> selectedSigns = [];
  List<SignCategoryDTO> listSignCate = [];
  dynamic status;

  late List<DropdownMenuItem> _listDropdownSigns = [];
  late Future<List<SignCategoryDTO>> signCategories =
      SignService().GetSignCategoriesDTOList();

  void setSignDropdownList(List<SignCategoryDTO> categories) {
    listSignCate = categories;
    for (var category in categories) {
      for (var sign in category.searchSignDTOs) {
        _listDropdownSigns.add(
          DropdownMenuItem<dynamic>(
            enabled: false,
            value: sign.name,
            child: StatefulBuilder(builder: (context, menuSetState) {
              final _isSelected = selectedSigns.contains(sign.name);
              return InkWell(
                onTap: () {
                  _isSelected
                      ? selectedSigns.remove(sign.name)
                      : selectedSigns.add(sign.name);
                  setState(() {});
                  menuSetState(() {});
                },
                child: Row(children: [
                  _isSelected
                      ? const Icon(Icons.check_box_outlined)
                      : const Icon(Icons.check_box_outline_blank),
                  const SizedBox(width: kDefaultPaddingValue),
                  CachedNetworkImage(
                    imageUrl: sign.imageUrl as String,
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
                    child: Text(
                      sign.name.split(' "').last.length > 28
                          ? '${sign.name.split(' "').last.substring(0, 28).split('"').first}...'
                          : sign.name.split(' "').last.split('"').first,
                      overflow: TextOverflow.ellipsis,
                    ),
                  )
                ]),
              );
            }),
          ),
        );
      }
    }
    context.loaderOverlay.hide();
    if (mounted) {
      setState(() {});
    }
  }

  Color getColorByCategory(String category) {
    category = category.toLowerCase();
    if (category.contains('cấm')) {
      return kDangerButtonColor;
    } else if (category.contains('cảnh báo')) {
      return kWarningButtonColor;
    } else if (category.contains('chỉ dẫn')) {
      return kPrimaryButtonColor;
    } else if (category.contains('hiệu lệnh')) {
      return kBlueAccentBackground;
    } else {
      return kDisabledButtonColor;
    }
  }

  confirmChange(BuildContext context) async {
    // context.loaderOverlay.show();
    MapsController mc = Get.find<MapsController>();

    IOUtils.saveNotiList(selectedSigns, mc).then((value) {
      DialogUtil.showAwesomeDialog(context, DialogType.success, "Thành công",
          "Thay đổi danh sách thông báo thành công", () {
        Get.offAll(() => const ContainerScreen());
      }, null);

      // context.loaderOverlay.hide();
    });
  }

  @override
  void initState() {
    print(mc.listNotiSigns);
    context.loaderOverlay.show();
    if (mc.listNotiSigns.isNotEmpty) {
      print(mc.listNotiSigns);
      selectedSigns = mc.listNotiSigns;
    }
    signCategories.then((list) => setSignDropdownList(list));
    super.initState();
  }

  @override
  void dispose() {
    _listDropdownSigns = [];
    selectedSigns = [];
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _listDropdownSigns = [];
        selectedSigns = [];
        return await true;
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: AppBar(
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
          elevation: 0,
          title: const Text('Cá nhân hoá thông báo'),
        ),
        body: KeyboardVisibilityBuilder(
          builder: (kContext, isKeyboardVisible) {
            return SingleChildScrollView(
              padding: kDefaultPadding,
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: kDefaultPaddingValue),
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
                          items: _listDropdownSigns,
                          //  _listDropdownSigns.map((item) {
                          //   return DropdownMenuItem<dynamic>(
                          //     value: item.value,
                          //     //disable default onTap to avoid closing menu when selecting an item
                          //     enabled: false,
                          //     child: StatefulBuilder(
                          //       builder: (context, menuSetState) {
                          //         final _isSelected =
                          //             selectedSigns.contains(item);
                          //         return InkWell(
                          //           onTap: () {
                          //             _isSelected
                          //                 ? selectedSigns.remove(item)
                          //                 : selectedSigns.add(item);
                          //             //This rebuilds the StatefulWidget to update the button's text
                          //             setState(() {});
                          //             //This rebuilds the dropdownMenu Widget to update the check mark
                          //             menuSetState(() {});
                          //           },
                          //           child: SizedBox(
                          //             height: double.infinity,
                          //             child: Row(
                          //               children: [
                          //                 _isSelected
                          //                     ? const Icon(
                          //                         Icons.check_box_outlined)
                          //                     : const Icon(Icons
                          //                         .check_box_outline_blank),
                          //                 const SizedBox(width: 16),
                          //                 item.child,
                          //               ],
                          //             ),
                          //           ),
                          //         );
                          //       },
                          //     ),
                          //   );
                          // }).toList(),
                          // value:
                          //     'Đã chọn ${selectedSigns.length} biển để thông báo',
                          onChanged: (value) {},
                          // selectedItemBuilder: (ctx) {
                          //   return _listDropdownSigns.map(
                          //     (item) {
                          //       return Container(
                          //         alignment: AlignmentDirectional.center,
                          //         padding: const EdgeInsets.symmetric(
                          //             horizontal: kDefaultPaddingValue),
                          //         child: Text(
                          //           'Đã chọn ${selectedSigns.length} biển để thông báo',
                          //           style: const TextStyle(
                          //             fontSize: FONTSIZES.textPrimary,
                          //             overflow: TextOverflow.ellipsis,
                          //           ),
                          //           maxLines: 1,
                          //         ),
                          //       );
                          //     },
                          //   ).toList();
                          // },
                          scrollbarAlwaysShow: true,
                          scrollbarRadius:
                              const Radius.circular(kDefaultPaddingValue),
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
                  const SizedBox(
                    height: kDefaultPaddingValue,
                  ),
                  Container(
                    color: Colors.white,
                    height: 50.h,
                    width: 100.w,
                    child: ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemCount: selectedSigns.length,
                      itemBuilder: ((context, index) {
                        SearchSignDTO? tmp = null;
                        listSignCate.forEach((e) {
                          e.searchSignDTOs.forEach((sign) {
                            if (sign.name == selectedSigns[index]) {
                              tmp = sign;
                              print(tmp);
                            }
                          });
                        });
                        String? sName =
                            tmp?.imageUrl?.split("%2F").last.split('?').first;
                        return tmp == null
                            ? Container()
                            : Padding(
                                padding: const EdgeInsets.all(
                                    kDefaultPaddingValue / 4),
                                child: Row(children: [
                                  Image.asset('assets/gps/x0125/$sName'),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: kDefaultPaddingValue),
                                    child: Text(
                                      tmp!.name.split(' "').last.length > 28
                                          ? '${tmp!.name.split(' "').last.substring(0, 28).split('"').first}...'
                                          : tmp!.name
                                              .split(' "')
                                              .last
                                              .split('"')
                                              .first,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  )
                                ]),
                              );
                      }),
                    ),
                  ),
                  const SizedBox(
                    height: kDefaultPaddingValue,
                  ),
                  ElevatedButton(
                    onPressed: () => confirmChange(context),
                    child: Padding(
                      padding: EdgeInsets.all((kDefaultPaddingValue / 8).h),
                      child: const Text('Xác nhận'),
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
