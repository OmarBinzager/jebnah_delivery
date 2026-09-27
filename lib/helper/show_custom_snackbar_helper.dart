import 'package:flutter/material.dart';
import 'package:jebnah_delivery/main.dart';
import 'package:jebnah_delivery/utill/dimensions.dart';
import 'package:jebnah_delivery/utill/images.dart';
import 'package:jebnah_delivery/utill/styles.dart';

void showCustomSnackBarHelper(String message, {bool isError = true}) {
  ScaffoldMessenger.of(Get.context!).showSnackBar(
    SnackBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      content: Container(
        decoration: BoxDecoration(
          color: Color(0xff2B2727),
          borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
        ),
        padding: EdgeInsets.all(Dimensions.paddingSizeDefault),
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                color: isError ? Colors.red : Colors.green,
                borderRadius: BorderRadius.circular(3),
              ),
              padding: EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
              child: Image.asset(
                isError ? Images.crossIcon : Images.successIcon,
                height: 7,
                width: 7,
                color: Theme.of(Get.context!).cardColor,
              ),
            ),
            const SizedBox(width: Dimensions.paddingSizeSmall),

            Expanded(
              child: Text(
                message,
                style: rubikRegular.copyWith(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
