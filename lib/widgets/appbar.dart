import 'package:file_manager/controllers/app_controller.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomAppbar extends StatelessWidget {
  const CustomAppbar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Get.put(AppController()).drawerToggle.value = !(Get.put(AppController()).drawerToggle.value),
            child: GetX<AppController>(
              builder: (controller) {
                return Icon(controller.drawerToggle.value ? Icons.arrow_back_ios : Icons.sort_rounded, color: Colors.white);
              }
            )
          ),
          const Expanded(child: SizedBox()),
          /*GestureDetector(
              child: Icon(Icons.tune_rounded, color: Colors.grey.shade300)
          ) */
        ],
      ),
    );
  }
}
