import 'package:file_manager/controllers/app_controller.dart';
import 'package:file_manager/models/file_entity.dart';
import 'package:file_manager/controllers/dashboard_controller.dart';
import 'package:file_manager/views/file_explorer/entity_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../misc/hex_color.dart';

class CategoryFileListBottomSheet extends StatelessWidget {

  final FileTypeEnum category;

  const CategoryFileListBottomSheet({Key? key, required this.category}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width, height: Get.height * 0.8,
      decoration: BoxDecoration(
        color: HexColor('#121212'), borderRadius: const BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15))
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(getIcon(category), color: Colors.white, size: 24),
                const SizedBox(width: 30),
                Text(getTitle(category), style: const TextStyle(color: Colors.white, fontSize: 24)),
                const Expanded(child: SizedBox()),
                GestureDetector(
                  onTap: () {
                    Get.put(AppController()).selectedCategory.value = null;
                  },
                    child: const Icon(Icons.close, color: Colors.white, size: 24)
                )
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: GetX<DashboardController>(
                builder: (controller) {

                  FileTypeEnum selectedCategory = Get.put(AppController()).selectedCategory.value!;

                  return selectedCategory == FileTypeEnum.DOCUMENT ? ListView.builder(itemBuilder: (_, index) {
                    return EntityCard(entity: controller.documentsList.value[index]);
                  }, itemCount: controller.documentsList.value.length, physics: const BouncingScrollPhysics())
                   : selectedCategory == FileTypeEnum.AUDIO ? ListView.builder(itemBuilder: (_, index) {
                    return EntityCard(entity: controller.audiosList.value[index]);
                  }, itemCount: controller.audiosList.value.length, physics: const BouncingScrollPhysics())
                      : selectedCategory == FileTypeEnum.APK ? ListView.builder(itemBuilder: (_, index) {
                    return EntityCard(entity: controller.apksList.value[index]);
                  }, itemCount: controller.apksList.value.length, physics: const BouncingScrollPhysics())
                      : selectedCategory == FileTypeEnum.VIDEO ? ListView.builder(itemBuilder: (_, index) {
                    return EntityCard(entity: controller.videosList.value[index]);
                  }, itemCount: controller.videosList.value.length, physics: const BouncingScrollPhysics())
                      : selectedCategory == FileTypeEnum.IMAGE ? ListView.builder(itemBuilder: (_, index) {
                    return EntityCard(entity: controller.imagesList.value[index]);
                  }, itemCount: controller.imagesList.value.length, physics: const BouncingScrollPhysics()) : const SizedBox();
                },
              )
            )
          ],
        ),
      ),
    );
  }

  getTitle(FileTypeEnum fileTypeEnum) {
    switch(fileTypeEnum) {
      case FileTypeEnum.IMAGE:
        return 'Images';
      case FileTypeEnum.DOCUMENT:
        return 'Documents';
      case FileTypeEnum.AUDIO:
        return 'Audios';
      case FileTypeEnum.VIDEO:
        return 'Videos';
      case FileTypeEnum.APK:
        return 'APKs';
      case FileTypeEnum.UNKNOWN:
        return 'Unknown';
    }
  }

  getIcon(FileTypeEnum fileTypeEnum) {
    switch(fileTypeEnum) {

      case FileTypeEnum.IMAGE:
        return Icons.image;
      case FileTypeEnum.VIDEO:
        return Icons.videocam;
      case FileTypeEnum.DOCUMENT:
        return Icons.description;
      case FileTypeEnum.AUDIO:
        return Icons.audiotrack_rounded;
      case FileTypeEnum.APK:
        return Icons.android_rounded;
      case FileTypeEnum.UNKNOWN:
        return Icons.add_circle;
    }
  }

}
