import 'package:file_manager/controllers/dashboard_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/app_controller.dart';
import '../../misc/hex_color.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width * 0.7,
      height: Get.height,
      decoration: BoxDecoration(color: HexColor('#121212')),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            color: Colors.grey.shade900,
            padding: const EdgeInsets.only(left: 20, right: 20, top: 40, bottom: 40),
            child: GetX<DashboardController>(
              init: DashboardController(),
              builder: (controller) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    Text(controller.modelName.value, style: const TextStyle(color: Colors.amber, fontSize: 18)),
                    const SizedBox(height: 15),
                    Text('${controller.totalRAM.value / 1000 / 1000 ~/ 1000} GB RAM', style: TextStyle(color: Colors.grey.shade400, fontSize: 12)),
                    const SizedBox(height: 5),
                    Text('${controller.totalDisk.value / 1000 / 1000 ~/ 1000} GB ROM', style: TextStyle(color: Colors.grey.shade400, fontSize: 12))
                  ],
                );
              }
            ),
          ),
          Expanded(
              child: GetX<AppController>(
                builder: (controller) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Get.put(AppController()).currentView.value = ViewEnum.DASHBOARD;
                          Get.put(AppController()).drawerToggle.value = false;
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text('Dashboard', style: controller.currentView.value == ViewEnum.DASHBOARD ? const TextStyle(color: Colors.white) : TextStyle(color: Colors.grey)),
                          ),
                        ),
                      ),
                      Container(width: double.infinity, height: 0.5, color: Colors.grey.shade800),
                      GestureDetector(
                        onTap: () {
                          Get.put(AppController()).currentView.value = ViewEnum.FILE_EXP;
                          Get.put(AppController()).drawerToggle.value = false;
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text('File Explorer', style: controller.currentView.value == ViewEnum.FILE_EXP ? const TextStyle(color: Colors.white) : const TextStyle(color: Colors.grey)),
                          ),
                        ),
                      ),
                      Container(width: double.infinity, height: 0.5, color: Colors.grey.shade800),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Row(
                            children: [
                              const Text('Cleaner', style: TextStyle(color: Colors.grey)),
                              const Expanded(child: SizedBox()),
                              Text("Coming soon", style: TextStyle(color: Colors.grey.shade700, fontSize: 12))
                            ],
                          ),
                        ),
                      ),
                      Container(width: double.infinity, height: 0.5, color: Colors.grey.shade800),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Row(
                            children: [
                              const Text('Google Drive', style: TextStyle(color: Colors.grey)),
                              const Expanded(child: SizedBox()),
                              Text("Coming soon", style: TextStyle(color: Colors.grey.shade700, fontSize: 12))
                            ],
                          ),
                        ),
                      ),
                      Container(width: double.infinity, height: 0.5, color: Colors.grey.shade800),
                    ],
                  );
                }
              )
          )
        ],
      ),
    );
  }
}
