import 'dart:async';
import 'dart:io';

import 'package:file_manager/controllers/file_explorer_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class FileEntity extends GetxController {

  late String name;
  late String path;
  late String parentPath;
  late bool isDirectory;
  late FileSystemEntity rawFsEntity;
  RxInt size = RxInt(0);
  RxInt childrenCount = RxInt(0);
  RxInt dirCount = RxInt(0);
  RxInt fileCount = RxInt(0);
  late FileTypeEnum fileType;

  FileEntity({required FileSystemEntity fileSystemEntity}) {

    rawFsEntity = fileSystemEntity;

    name = fileSystemEntity.path.split('/').last;
    path = fileSystemEntity.path;

    List<String> x = path.split('/')..removeLast();
    parentPath = '';
    for(String temp in x) {
      parentPath += '$temp/';
    }

    isDirectory = fileSystemEntity is Directory;

   /* if(fileSystemEntity is Directory) {
      (fileSystemEntity).list(recursive: true).listen((event) {
        event.stat().then((fsStat) {
          size.value += fsStat.size;
        });
      });
    }
    else {
      fileSystemEntity.stat().then((fileStat) {
        size.value = fileStat.size;
      });
    } */

    if(isDirectory) {

      Directory.fromUri(Uri.parse(path)).list().listen((event) {
        childrenCount.value++;
        if(event is Directory) {
          dirCount.value++;
        }
        else {
          fileCount.value++;
        }
      });

      Directory.fromUri(Uri.parse(path)).list().toList().then((fsEntityList) {
        childrenCount.value = fsEntityList.length;
      });

    }
    else {
      File(path).stat().then((fStat) {
        size.value = fStat.size;
      });
    }

    if(!isDirectory) {
      String extension = name.split('.').last.toLowerCase();

      if(name.isImageFileName) {
        fileType = FileTypeEnum.IMAGE;
      }
      else if(name.isDocumentFileName) {
        fileType = FileTypeEnum.DOCUMENT;
      }
      else if(name.isAPKFileName) {
        fileType = FileTypeEnum.APK;
      }
      else if(name.isAudioFileName) {
        fileType = FileTypeEnum.AUDIO;
      }
      else if(name.isVideoFileName) {
        fileType = FileTypeEnum.VIDEO;
      }
      else {
        if(extension == 'pdf' || extension == 'docx' || extension == 'doc' || extension == 'xls' || extension == 'xlsx' || extension == 'txt' || extension == 'ppt' || extension == 'pptx') {
          fileType = FileTypeEnum.DOCUMENT;
        }
        else if(extension == 'mp4' || extension == 'avi' || extension == 'mov' || extension == 'mkv' || extension == 'flv') {
          fileType = FileTypeEnum.VIDEO;
        }
        else if(extension == 'mp3' || extension == 'm4a' || extension == 'wav') {
          fileType = FileTypeEnum.AUDIO;
        }
        else {
          fileType = FileTypeEnum.UNKNOWN;
        }
      }

    }

  }


  Future<void> rename(String newName) async {
    if(isDirectory) {
      await rawFsEntity.rename(parentPath + newName);
      Get.put(FileExplorerController()).getDirectoryEntities(path: parentPath);
    }
    else {
      return SynchronousFuture(null);
    }
  }

  Future<void> delete() async {
      await rawFsEntity.delete(recursive: true);
      Get.put(FileExplorerController()).getDirectoryEntities(path: Get.put(FileExplorerController()).currentDirectory.value);
  }


}



enum FileTypeEnum {
  IMAGE, VIDEO, DOCUMENT, AUDIO, APK, UNKNOWN
}