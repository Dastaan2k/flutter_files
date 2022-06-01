import 'dart:io';

import 'package:file_manager/controllers/app_controller.dart';
import 'package:file_manager/misc/hex_color.dart';
import 'package:file_manager/views/dashboard/dashboard.dart';
import 'package:file_manager/views/file_explorer/file_explorer.dart';
import 'package:file_manager/controllers/file_explorer_controller.dart';
import 'package:file_manager/views/wrapper/category_file_list_bottom_sheet.dart';
import 'package:file_manager/views/wrapper/create_new_entity_bottom_sheet.dart';
import 'package:file_manager/views/wrapper/drawer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'file_options_bottom_sheet.dart';



class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    AppController appController = Get.put(AppController());

    FileExplorerController fileExplorerController = Get.put(FileExplorerController());

    return WillPopScope(
      onWillPop: () {
        if(appController.selectedCategory.value != null) {
          appController.selectedCategory.value = null;
        }
        if(appController.currentView.value == ViewEnum.FILE_EXP) {
         if(fileExplorerController.currentDirectory.value != '/storage/emulated/0') {
           fileExplorerController.getPreviousDirectory();
         }
        }
        return SynchronousFuture(false);
      },
      child: Scaffold(
        body: Stack(
          children: [
            Container(color: HexColor('#020202'), height: Get.height, width: Get.width),
            const Align(
              alignment: Alignment.centerLeft,
              child: CustomDrawer()
            ),
            GetX<AppController>(
                builder: (controller) {
                  return AnimatedPositioned(
                      top: controller.drawerToggle.value ? Get.height * 0.35 : 0,
                      right: controller.drawerToggle.value ? - Get.width * 0.8 : 0,
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeInOut,
                      child: ClipRRect(borderRadius: controller.drawerToggle.value ? BorderRadius.circular(20) : BorderRadius.circular(20), child: controller.currentView.value == ViewEnum.FILE_EXP ? const FileExplorer() : const DashboardView())
                  );
                }
            ),
            GetX<AppController>(
                builder: (controller) {
                  return AnimatedOpacity(
                      duration: const Duration(milliseconds: 200), opacity: controller.fileOptionsBottomBarToggle.value || controller.createEntityBottomBarToggle.value || controller.selectedCategory.value != null ? 1 : 0,
                      child: IgnorePointer(
                        ignoring: !controller.fileOptionsBottomBarToggle.value || !controller.createEntityBottomBarToggle.value || controller.selectedCategory.value == null,
                          child: Container(width: Get.width, height: Get.height, color: Colors.grey.shade800.withOpacity(0.4))
                      )
                  );
                }
            ),
            GetX<AppController>(
              builder: (controller) {
                return AnimatedPositioned(
                  bottom: controller.fileOptionsBottomBarToggle.value ? 0 : -170,
                    duration: const Duration(milliseconds: 200),
                    child: controller.fileOptionsBottomBarToggle.value ?const FileOptionsBottomBar() : const SizedBox()
                );
              },
            ),
            GetX<AppController>(
              builder: (controller) {
                return AnimatedPositioned(
                    bottom: controller.createEntityBottomBarToggle.value ? 0 : -170,
                    duration: const Duration(milliseconds: 200),
                    child: controller.createEntityBottomBarToggle.value ?const CreateNewEntityBottomSheet() : const SizedBox()
                );
              },
            ),
            GetX<AppController>(
              builder: (controller) {
                return AnimatedPositioned(
                    bottom: controller.selectedCategory.value != null ? 0 : -170,
                    duration: const Duration(milliseconds: 200),
                    child: controller.selectedCategory.value == null ? const SizedBox() : CategoryFileListBottomSheet(category: controller.selectedCategory.value!)
                );
              },
            )
          ],
        ),
      ),
    );

  }
}
