import 'dart:io';

import 'package:file_manager/controllers/app_controller.dart';
import 'package:file_manager/controllers/file_explorer_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../misc/hex_color.dart';

class CreateNewEntityBottomSheet extends StatefulWidget {
  const CreateNewEntityBottomSheet({Key? key}) : super(key: key);

  @override
  State<CreateNewEntityBottomSheet> createState() => _CreateNewEntityBottomSheetState();
}

class _CreateNewEntityBottomSheetState extends State<CreateNewEntityBottomSheet> {

  int selectedIndex = 0;
  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {

    return Container(
      width: Get.width,
      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
      decoration: BoxDecoration(color: HexColor('#121212')),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('Create new', style: TextStyle(color: Colors.white, fontSize: 20)),
              const SizedBox(width: 30),
              GestureDetector(
                onTap: () {
                  setState(() {selectedIndex = 0;});
                },
                child: Container(
                  padding: const EdgeInsets.all(7.5),
                  decoration: BoxDecoration(color: selectedIndex == 0 ? Colors.grey.shade800.withOpacity(0.8) : Colors.transparent, borderRadius: BorderRadius.circular(5)),
                  child: Icon(Icons.insert_drive_file, color: Colors.grey.shade400, size: 18),
                ),
              ),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: () {
                  setState(() {selectedIndex = 1;});
                },
                child: Container(
                  padding: const EdgeInsets.all(7.5),
                  decoration: BoxDecoration(color: selectedIndex == 1 ? Colors.grey.shade800.withOpacity(0.8) : Colors.transparent, borderRadius: BorderRadius.circular(5)),
                  child: Icon(Icons.folder, color: Colors.grey.shade400, size: 18),
                ),
              ),
              const Expanded(child: SizedBox()),
              GestureDetector(
                onTap: () {
                  Get.put(AppController()).createEntityBottomBarToggle.value = false;
                },
                  child: const Icon(Icons.close, color: Colors.white, size: 22)
              ),
              const SizedBox(width: 20),
              GestureDetector(
                onTap: () {
                  if(controller.text != '') {
                    if(selectedIndex == 0) {
                      File.fromUri(Uri.parse('${Get.put(FileExplorerController()).currentDirectory.value}/${controller.text}.txt')).create().then((value) {
                        Get.put(FileExplorerController()).getDirectoryEntities(path: Get.put(FileExplorerController()).currentDirectory.value);
                        Get.put(AppController()).createEntityBottomBarToggle.value = false;
                      });
                    }
                    else {
                      Directory.fromUri(Uri.parse('${Get.put(FileExplorerController()).currentDirectory.value}/${controller.text}')).create().then((value) {
                        Get.put(FileExplorerController()).getDirectoryEntities(path: Get.put(FileExplorerController()).currentDirectory.value);
                        Get.put(AppController()).createEntityBottomBarToggle.value = false;
                      });
                    }
                  }
                },
                  child: const Icon(Icons.check,color: Colors.white, size: 22)
              )
            ],
          ),
          const SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(child: TextField(controller: controller,decoration: const InputDecoration(disabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.transparent))), style: const TextStyle(color: Colors.white, fontSize: 16))),
              selectedIndex == 0 ? const SizedBox(width: 30) : const SizedBox(),
              selectedIndex == 0 ? const Text('.txt', style: TextStyle(color: Colors.white, fontSize: 16)) : const SizedBox()
            ],
          ),
        ],
      ),
    );
  }
}
