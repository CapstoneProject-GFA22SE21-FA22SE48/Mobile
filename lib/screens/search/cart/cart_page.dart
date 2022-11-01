import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:vnrdn_tai/controllers/auth_controller.dart';
import 'package:vnrdn_tai/controllers/cart_controller.dart';
import 'package:vnrdn_tai/controllers/global_controller.dart';
import 'package:vnrdn_tai/shared/constants.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    CartController cc = Get.find<CartController>();
    GlobalController gc = Get.find<GlobalController>();
    AuthController ac = Get.put(AuthController());
    var data = cc.laws;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: const Text("Chi tiết biên bản"),
      ),
      body: Obx(
        () => SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(top: kDefaultPaddingValue),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Text('Biên bản xử phạt vi phạm giao thông',
                      style: Theme.of(context).textTheme.headline4?.copyWith(
                          color: Colors.black,
                          fontWeight: FontWeight.normal,
                          fontSize: FONTSIZES.textLarge)),
                  Padding(
                    padding: const EdgeInsets.all(kDefaultPaddingValue),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Tài khoản vi phạm: ',
                            style: Theme.of(context)
                                .textTheme
                                .headline4
                                ?.copyWith(
                                    color: Colors.black,
                                    fontWeight: FontWeight.normal,
                                    fontSize: FONTSIZES.textLarge)),
                        Text(
                            gc.userId.value.isNotEmpty
                                ? gc.username.value.isNotEmpty
                                    ? gc.username.value
                                    : ac.email.value
                                : "Không có dữ liệu",
                            style: Theme.of(context)
                                .textTheme
                                .headline4
                                ?.copyWith(
                                    color: Colors.black,
                                    fontWeight: FontWeight.normal,
                                    fontSize: FONTSIZES.textLarge)),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(kDefaultPaddingValue),
                    child: Text('Đã mắc phải các lỗi sau: ',
                        style: Theme.of(context).textTheme.headline4?.copyWith(
                            color: Colors.black,
                            fontWeight: FontWeight.normal,
                            fontSize: FONTSIZES.textLarge)),
                  ),
                  ListView.separated(
                    itemCount: data.length,
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 0),
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: kDefaultPaddingValue),
                        child: Wrap(alignment: WrapAlignment.center, children: [
                          Text(
                            "${data[index].paragraphDesc}"
                                .replaceAll("\\\n", ""),
                          ),
                          const Divider()
                        ]),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
