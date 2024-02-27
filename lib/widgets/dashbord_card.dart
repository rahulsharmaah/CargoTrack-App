import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Widget dashbord_card(
    {required Widget child,
    required Color strokeColor,
    required Color backgroundColor,
    required double borderRadius,
    required bool dot}) {
  return DottedBorder(
    color: strokeColor,
    strokeWidth: 5,
    padding: EdgeInsets.zero,
    strokeCap: dot == true ? StrokeCap.butt : StrokeCap.square,
    borderType: BorderType.RRect,
    radius: Radius.circular(borderRadius),
    dashPattern: const [3, 3],
    child: Container(
      height: Get.height * 0.07,
      width: Get.width * 0.14,
      alignment: Alignment.center,
      decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.all(Radius.circular(borderRadius))),
      child: child,
    ),
  );
}
