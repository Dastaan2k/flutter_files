import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/file_entity.dart';

class FileExplorerController extends GetxController {

  RxString currentDirectory = '/storage/emulated/0'.obs;
  RxInt currentDirFileCount = 0.obs;
  RxInt currentDirDirectoryCount = 0.obs;

  FileEntity? selectedEntity;

  Rxn<FileEntity> copiedEntity = Rxn<FileEntity>();
  RxList<File> fileList = RxList<File>();
  List<Directory> dirList = [];
  RxInt filesCopied = 0.obs;

  RxList<FileEntity> entityList = <FileEntity>[].obs;

  getDirectoryEntities({String path = '/storage/emulated/0'}) async {
    currentDirectory.value = path;
    entityList.value = [];
    List<FileEntity> temp = [];
    Directory.fromUri(Uri.parse(path)).list().listen((fileSystemEntity) {
      temp.add(FileEntity(fileSystemEntity: fileSystemEntity));
    }).onDone(() {
      entityList.value = List.from(temp);
    });
  }

  getPreviousDirectory() {

    List<String> x =  currentDirectory.value.split('/')..removeLast();
    String newPath = '';
    for(String temp in x) {
      newPath += '$temp/';
    }

    String tempx = '';
    for(int i=0;i< newPath.length - 1;i++) {
      tempx += newPath[i];
    }

    currentDirectory.value = tempx;

    entityList.value = [];

    List<FileEntity> temp = [];
    Directory.fromUri(Uri.parse(newPath)).list().listen((fileSystemEntity) {
      temp.add(FileEntity(fileSystemEntity: fileSystemEntity));
    }).onDone(() {
      entityList.value = List.from(temp);
    });

  }


  Future<void> pasteEntity(BuildContext context) async {

    await Future.delayed(const Duration(milliseconds: 300), () async {
      if(copiedEntity.value!.rawFsEntity is File) {
        await (copiedEntity.value!.rawFsEntity as File).copy('${currentDirectory.value}/${copiedEntity.value!.name}');
        getDirectoryEntities(path: currentDirectory.value);
        Navigator.pop(context);
        return;
      }
      else {
        fileList.value = [];
        filesCopied.value = 0;
        String parentPath = copiedEntity.value!.parentPath;
        (copiedEntity.value!.rawFsEntity as Directory).list(recursive: true).listen((event) async {
          if(event is Directory) {
            dirList.add(event);
          }
          else if(event is File) {
            fileList.add(event);
            fileList.value = List<File>.from(fileList);
          }
        }).onDone(() async {
          for(Directory dir in dirList) {
            await Directory('${currentDirectory.value}/${dir.path.replaceAll(parentPath, '')}').create(recursive: true);
          }
          for(File file in fileList) {
            await file.copy('${currentDirectory.value}/${file.path.replaceAll(parentPath, '')}');
            filesCopied++;
          }
          getDirectoryEntities(path: currentDirectory.value);
          Navigator.pop(context);
        });
      }
    });

  }

}