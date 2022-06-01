import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/app_controller.dart';
import '../../controllers/file_explorer_controller.dart';
import '../../misc/hex_color.dart';

class FileOptionsBottomBar extends StatefulWidget {
  const FileOptionsBottomBar({Key? key}) : super(key: key);

  @override
  State<FileOptionsBottomBar> createState() => _FileOptionsBottomBarState();
}

class _FileOptionsBottomBarState extends State<FileOptionsBottomBar> {

  final TextEditingController _controller = TextEditingController();
  bool isEdit = false;

  @override
  void initState() {
    _controller.text = Get.put(FileExplorerController()).selectedEntity!.name;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width,
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
      decoration: BoxDecoration(color: HexColor('#121212')),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: TextField(controller: _controller, enabled: isEdit, decoration: const InputDecoration(disabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.transparent))), style: const TextStyle(color: Colors.white, fontSize: 18))),
              const SizedBox(width: 40),
              //Text(Get.put(FileExplorerController()).selectedEntity == null ? '' : Get.put(FileExplorerController()).selectedEntity!.name, style: TextStyle(color: Colors.white, fontSize: 18)),
              InkWell(
                  onTap: () {
                    if(isEdit) {
                      Get.put(FileExplorerController()).selectedEntity!.rename(_controller.text);
                      Get.put(AppController()).fileOptionsBottomBarToggle.value = false;
                    }
                    setState(() {isEdit = !isEdit;});
                  },
                  child: Icon(isEdit ? Icons.check : Icons.edit,color: Colors.white, size: 18)
              )
            ],
          ),
          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  Get.put(FileExplorerController()).selectedEntity!.delete();
                  Get.put(AppController()).fileOptionsBottomBarToggle.value = false;
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.delete_forever_rounded, color: Colors.white, size: 20),
                    SizedBox(height: 5),
                    Text('Delete', style: TextStyle(color: Colors.white, fontSize: 10))
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  Get.put(FileExplorerController()).copiedEntity.value = Get.put(FileExplorerController()).selectedEntity!;
                  Get.put(AppController()).fileOptionsBottomBarToggle.value = false;
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.copy, color: Colors.white, size: 20),
                    SizedBox(height: 5),
                    Text('Copy', style: TextStyle(color: Colors.white, fontSize: 10))
                  ],
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(Icons.add, color: Colors.white, size: 20),
                  SizedBox(height: 5),
                  Text('Delete', style: TextStyle(color: Colors.white, fontSize: 10))
                ],
              ),
              GestureDetector(
                  onTap: () => Get.put(AppController()).fileOptionsBottomBarToggle.value = false,
                  child: const Icon(Icons.clear, color: Colors.white, size: 20)
              ),
            ],
          ),
        ],
      ),
    );
  }
}
