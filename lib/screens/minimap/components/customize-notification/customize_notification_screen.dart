import 'package:cached_network_image/cached_network_image.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:sizer/sizer.dart';
import 'package:vnrdn_tai/models/dtos/signCategoryDTO.dart';
import 'package:vnrdn_tai/services/SignService.dart';
import 'package:vnrdn_tai/shared/constants.dart';
import 'package:vnrdn_tai/shared/snippets.dart';

// ignore: must_be_immutable
class CustomizeNotificationScreen extends StatefulWidget {
  const CustomizeNotificationScreen({super.key});

  @override
  State<StatefulWidget> createState() => _CustomNotiState();
}

class _CustomNotiState extends State<CustomizeNotificationScreen> {
  final searchSignController = TextEditingController();
  dynamic adminId;
  dynamic selectedSign;
  dynamic status;

  late List<DropdownMenuItem> _listDropdownSigns = [];
  late Future<List<SignCategoryDTO>> signCategories =
      SignService().GetSignCategoriesDTOList();

  final List<DropdownMenuItem<int>> _listDropdown = <DropdownMenuItem<int>>[
    const DropdownMenuItem<int>(
      value: 3,
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

  void setSignDropdownList(List<SignCategoryDTO> categories) {
    for (var category in categories) {
      for (var sign in category.searchSignDTOs) {
        _listDropdownSigns.add(
          DropdownMenuItem(
            value: sign.name,
            child: Row(children: [
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
                    Image.asset("assets/images/alt_image.png"),
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
    context.loaderOverlay.hide();
    setState(() {});
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

  confirmChange() {}

  @override
  void initState() {
    context.loaderOverlay.show();
    signCategories.then((list) => setSignDropdownList(list));
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

                        items: _listDropdownSigns.isNotEmpty
                            ? _listDropdownSigns.toList()
                            : [
                                DropdownMenuItem(
                                    alignment: Alignment.centerLeft,
                                    child: Transform.scale(
                                      scale: 0.6,
                                      child: loadingScreen(),
                                    ))
                              ],
                        value: selectedSign,
                        onChanged: (value) {
                          setState(() {
                            selectedSign = value as String;
                          });
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
                          return (item.value.toString().contains(searchValue));
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
                ElevatedButton(
                  onPressed: confirmChange,
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
    );
  }
}
