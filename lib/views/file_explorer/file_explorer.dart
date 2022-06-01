import 'dart:io';
import 'dart:math';

import 'package:file_manager/controllers/app_controller.dart';
import 'package:file_manager/views/file_explorer/entity_card.dart';
import 'package:file_manager/controllers/file_explorer_controller.dart';
import 'package:file_manager/widgets/appbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../misc/hex_color.dart';
import '../../models/file_entity.dart';
import 'copy_dialog.dart';

class FileExplorer extends StatelessWidget {
  const FileExplorer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    Get.put(FileExplorerController()).getDirectoryEntities();

    return Material(
      color: HexColor('#121212'),
      child: SafeArea(
        child: SizedBox(
          width: Get.width, height: Get.height,
          child: Column(
            children: [
              const CustomAppbar(),
              Expanded(
                child: Stack(
                  children: [
                    SizedBox(
                      width: Get.width, height: Get.height,
                      child: const Align(
                        alignment: Alignment.topCenter,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 10),
                          child: FileExplorerBack(),
                        ),
                      )
                    ),
                    const Align(
                      alignment: Alignment.bottomCenter,
                      child: FileExplorerFront()
                    )
                  ],
                ),
              ),
            ],
          )
        ),
      ),
    );
  }
}





class FileExplorerBack extends StatelessWidget {
  const FileExplorerBack({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Get.width,
      child: Row(
        children: [
          const CurrentDirectoryWidget(),
          const Expanded(child: SizedBox()),
          GetX<FileExplorerController>(
            builder: (controller) {
              return controller.copiedEntity.value != null ? GestureDetector(
                  onTap: () {
                    showDialog(context: context, barrierColor: Colors.grey.shade800.withOpacity(0.4), builder: (context) {
                      return const Center(child: CopyDialog());
                    });
                    Get.put(FileExplorerController()).pasteEntity(context).then((value) {
                      Get.put(FileExplorerController()).copiedEntity.value = null;
                    });
                  },
                  child: const Icon(Icons.paste_rounded, color: Colors.white, size: 22)
              ) : const SizedBox();
            }
          ),
          const SizedBox(width: 30),
          GestureDetector(
            onTap: () {
              Get.put(AppController()).createEntityBottomBarToggle.value = true;
            },
              child: const Icon(Icons.create_new_folder_rounded, color: Colors.white, size: 22)
          ),
        ],
      ),
    );
  }
}




class CurrentDirectoryWidget extends StatefulWidget {
  const CurrentDirectoryWidget({Key? key}) : super(key: key);

  @override
  State<CurrentDirectoryWidget> createState() => _CurrentDirectoryWidgetState();
}

class _CurrentDirectoryWidgetState extends State<CurrentDirectoryWidget> {

  int fileCount = 0;
  int dirCount = 0;

  @override
  initState(){

    Directory(Get.put(FileExplorerController()).currentDirectory.value).list().listen((event) {
      if(event is File) {
        fileCount++;
      }
      else {
        dirCount++;
      }
    }).onDone(() {
      setState((){});
    });

    Get.put(FileExplorerController()).currentDirectory.listen((p0) {
      fileCount=0 ; dirCount=0;
      Directory(Get.put(FileExplorerController()).currentDirectory.value).list().listen((event) {
        if(event is File) {
          fileCount++;
        }
        else {
          dirCount++;
        }
      }).onDone(() {
        setState((){});
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(FileEntity(fileSystemEntity: Directory.fromUri(Uri.parse(Get.put(FileExplorerController()).currentDirectory.value))).name == '0' ? 'Root' : FileEntity(fileSystemEntity: Directory.fromUri(Uri.parse(Get.put(FileExplorerController()).currentDirectory.value))).name, style: const TextStyle(color: Colors.amber, fontSize: 22)),
              const SizedBox(height: 10),
              Text('$fileCount Files     |    $dirCount Directories', style: TextStyle(color: Colors.grey.shade300))
            ],
          );
  }
}



class FileExplorerFront extends StatelessWidget {
  const FileExplorerFront({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width, height: Get.height * 0.775,
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 30),
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.45),blurRadius: 5, spreadRadius: 1.5)],
        borderRadius: const BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GetX<FileExplorerController>(
            builder: (controller) {
              return Text(controller.currentDirectory.value == '' ? 'Root' : controller.currentDirectory.value, style: TextStyle(color: Colors.grey.shade400, fontSize: 12));
            },
          ),
          const SizedBox(height: 30),
          Expanded(
            child: GetX<FileExplorerController>(
              builder: (controller) {
                return ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: controller.entityList.length,
                  itemBuilder: (_, index) {
                    return EntityCard(entity: controller.entityList[index]);
                  },
                );
              },
            )
          )
        ],
      ),
    );
  }
}



