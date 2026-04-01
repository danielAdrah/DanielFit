import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Helper {
  showSnackBar(String title, String desc, Color bgColor, IconData icon) {
    return Get.snackbar(
      title,
      desc,
      colorText: Colors.white,
      backgroundColor: bgColor,
      snackPosition: SnackPosition.TOP,
      icon: Icon(icon, color: Colors.white),
    );
  }
}
