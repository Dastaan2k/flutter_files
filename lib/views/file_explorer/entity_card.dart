import 'package:file_manager/controllers/app_controller.dart';
import 'package:file_manager/controllers/file_explorer_controller.dart';
import 'package:file_manager/models/file_entity.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:open_file/open_file.dart';

class EntityCard extends StatelessWidget {

  final FileEntity entity;

  const EntityCard({required this.entity, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.only(bottom: 30),
      child: GestureDetector(
        onTap: () {
          if(entity.isDirectory) {
            Get.put(FileExplorerController()).getDirectoryEntities(path: entity.path);
          }
          else {
            OpenFile.open(entity.path);
          }
        },
        onLongPress: () {
          Get.put(FileExplorerController()).selectedEntity = entity;
          Get.put(AppController()).fileOptionsBottomBarToggle.value = true;
        },
        child: Row(
          children: [
            entity.isDirectory ? const Icon(Icons.folder, color: Colors.amber, size: 40) : Icon(getFileIcon(entity.fileType), color: Colors.white, size: 40),
            const SizedBox(width: 30),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(width: Get.width * 0.6, child: Text(entity.name, style: const TextStyle(color: Colors.white, fontSize: 16), overflow: TextOverflow.ellipsis, maxLines: 1)),
                  const SizedBox(height: 5),
                  GetX<FileEntity>(
                    builder: (controller) {
                      return Text(entity.isDirectory ? '${controller.childrenCount.value} Items' : (controller.size / 1024 / 1024).toStringAsFixed(2) == '0.00' ? '${(controller.size / 1024).toStringAsFixed(2)} KB' : '${(controller.size / 1024 / 1024).toStringAsFixed(2)} MB', style: TextStyle(color: Colors.grey.shade400, fontSize: 10));
                    }, init: entity, tag: 'Entity ${entity.path}'
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  getFileIcon(FileTypeEnum fileTypeEnum) {

    if(fileTypeEnum == FileTypeEnum.DOCUMENT) {
      return Icons.insert_drive_file;
    }
    else if(fileTypeEnum == FileTypeEnum.AUDIO) {
      return Icons.audiotrack_rounded;
    }
    else if(fileTypeEnum == FileTypeEnum.VIDEO) {
      return Icons.video_camera_back_rounded;
    }
    else if(fileTypeEnum == FileTypeEnum.IMAGE) {
      return Icons.image;
    }
    else if(fileTypeEnum == FileTypeEnum.APK) {
      return Icons.android_rounded;
    }
    else {
      return Icons.whatshot_rounded;
    }


  }


}
