import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:file_manager/models/file_entity.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class DashboardController extends GetxController {

  RxString modelName = RxString('');

  RxInt freeRAM = RxInt(0);
  RxInt totalRAM = RxInt(0);
  RxInt usedRAM = RxInt(0);

  RxInt freeDisk = RxInt(0);
  RxInt totalDisk = RxInt(0);
  RxInt usedDisk = RxInt(0);

  RxList<FileEntity> apksList = RxList<FileEntity>();
  RxList<FileEntity> documentsList = RxList<FileEntity>();
  RxList<FileEntity> imagesList = RxList<FileEntity>();
  RxList<FileEntity> videosList = RxList<FileEntity>();
  RxList<FileEntity> audiosList = RxList<FileEntity>();

  RxInt audioListSize = RxInt(0);
  RxInt videoListSize = RxInt(0);
  RxInt documentListSize = RxInt(0);
  RxInt apkListSize = RxInt(0);
  RxInt imageListSize = RxInt(0);

  RxInt totalSize = RxInt(0);      /// Disk size will include everything starting from android data and obb files to media files. This one will only include media files

  static const platformMethodChannel = MethodChannel('com.file_manager/channel');

  DashboardController() {
    platformMethodChannel.invokeMethod('getFreeRAM').then((value) {
      freeRAM.value = value;
    });
    platformMethodChannel.invokeMethod('getTotalRAM').then((value) {
      totalRAM.value = value;
    });
    platformMethodChannel.invokeMethod('getUsedRAM').then((value) {
      usedRAM.value = value;
    });

    platformMethodChannel.invokeMethod('getFreeDisk').then((value) {
      freeDisk.value = value;
    });
    platformMethodChannel.invokeMethod('getTotalDisk').then((value) {
      totalDisk.value = value;
    });
    platformMethodChannel.invokeMethod('getUsedDisk').then((value) {
      usedDisk.value = value;
    });
    DeviceInfoPlugin().androidInfo.then((value) {
      modelName.value = '${value.brand ?? ''} ${value.model ?? ''}';
    });


    Directory('storage/emulated/0').list(recursive: true).listen((fsEntity) {
      if(fsEntity is File) {
        FileEntity fileEntity = FileEntity(fileSystemEntity: fsEntity);

        if(fileEntity.fileType == FileTypeEnum.APK) {
          apksList.add(fileEntity);
        }
        else if(fileEntity.fileType == FileTypeEnum.AUDIO) {
          audiosList.add(fileEntity);
        }
        else if(fileEntity.fileType == FileTypeEnum.DOCUMENT) {
          documentsList.add(fileEntity);
        }
        else if(fileEntity.fileType == FileTypeEnum.VIDEO) {
          videosList.add(fileEntity);
        }
        else if(fileEntity.fileType == FileTypeEnum.IMAGE) {
          imagesList.add(fileEntity);
        }

      }
    }).onDone(() {
        Future.delayed(const Duration(milliseconds: 300), () {
          for(FileEntity apk in apksList) {
            apkListSize.value += apk.size.value;
            totalSize.value += apk.size.value;
          }
          for(FileEntity video in videosList) {
            videoListSize.value += video.size.value;
            totalSize.value += video.size.value;
          }
          for(FileEntity audio in audiosList) {
            audioListSize.value += audio.size.value;
            totalSize.value += audio.size.value;
          }
          for(FileEntity document in documentsList) {
            documentListSize.value += document.size.value;
            totalSize.value += document.size.value;
          }
          for(FileEntity image in imagesList) {
            imageListSize.value += image.size.value;
            totalSize.value += image.size.value;
          }
        });
    });

  }

}