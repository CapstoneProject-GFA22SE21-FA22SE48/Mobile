import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:getwidget/colors/gf_color.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:getwidget/components/rating/gf_rating.dart';
import 'package:getwidget/size/gf_size.dart';
import 'package:getwidget/types/gf_button_type.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:sizer/sizer.dart';
import 'package:vnrdn_tai/services/CommentService.dart';
import 'package:vnrdn_tai/shared/constants.dart';
import 'package:vnrdn_tai/utils/dialog_util.dart';
import 'package:vnrdn_tai/utils/form_validator.dart';
import 'package:vnrdn_tai/widgets/templated_buttons.dart';

class RatingTab extends StatefulWidget {
  RatingTab({super.key, required this.callback, required this.parentContext});

  Function(bool) callback;
  BuildContext parentContext;

  @override
  State<RatingTab> createState() => _RatingTabState();
}

class _RatingTabState extends State<RatingTab> {
  final contentController = TextEditingController();
  bool hasValue = false;
  double rate = 5.0;

  handleSendRating(BuildContext context) {
    FocusManager.instance.primaryFocus?.unfocus();
    widget.parentContext.loaderOverlay.show();
    CommentService()
        .createComment(contentController.text, rate.toInt())
        .then((value) {
      if (value.isNotEmpty) {
        widget.callback(true);
        Navigator.pop(context);
      } else {
        widget.parentContext.loaderOverlay.hide();
        DialogUtil.showAwesomeDialog(
            context,
            DialogType.error,
            "Đánh giá thất bại",
            "Có lỗi xảy ra.\nVui lòng thử lại sau.",
            () {},
            null);
      }
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40.h,
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: kDefaultPaddingValue),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: kDefaultPaddingValue * 2),
            child: TextFormField(
              validator: (value) => FormValidator.validPassword(value),
              controller: contentController,
              textInputAction: TextInputAction.done,
              cursorColor: kPrimaryButtonColor,
              onChanged: (value) {
                if (value.isNotEmpty) {
                  setState(() {
                    hasValue = true;
                  });
                } else {
                  setState(() {
                    hasValue = false;
                  });
                }
              },
              keyboardType: TextInputType.multiline,
              maxLines: 5,
              decoration: const InputDecoration(
                alignLabelWithHint: true,
                labelText: "Nội dung",
                hintText: "Nội dung đánh giá",
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black54, width: 3.0),
                ),
              ),
            ),
          ),
          const Spacer(),
          GFRating(
            onChanged: (value) {
              setState(() {
                rate = value;
              });
            },
            value: rate,
            allowHalfRating: false,
            filledIcon: const Icon(
              Icons.star_rounded,
              size: GFSize.MEDIUM,
              color: GFColors.WARNING,
            ),
            defaultIcon: const Icon(
              Icons.star_outline_rounded,
              size: GFSize.MEDIUM,
              color: GFColors.WARNING,
            ),
            halfFilledIcon: const Icon(
              Icons.star_half_rounded,
              size: GFSize.MEDIUM,
              color: GFColors.WARNING,
            ),
            itemCount: 5,
            borderColor: GFColors.WARNING,
            color: GFColors.WARNING,
          ),
          const Spacer(),
          Container(
            margin: const EdgeInsets.only(bottom: kDefaultPaddingValue),
            child: ElevatedButton(
              onPressed: hasValue ? () => handleSendRating(context) : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                textStyle: const TextStyle(
                  color: Colors.blueAccent,
                  fontSize: FONTSIZES.textLarge,
                  fontWeight: FontWeight.bold,
                ),
                foregroundColor: Colors.blueAccent,
                elevation: 2,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                padding: const EdgeInsets.symmetric(
                    vertical: kDefaultPaddingValue + 2),
                shape: RoundedRectangleBorder(
                  side: hasValue
                      ? BorderSide(color: Colors.blueAccent.shade200, width: 3)
                      : BorderSide.none,
                  borderRadius: BorderRadius.circular(kDefaultPaddingValue),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text('Gửi đánh giá'),
                  Padding(
                    padding: EdgeInsets.only(left: kDefaultPaddingValue),
                    child: Icon(Icons.send_rounded),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
