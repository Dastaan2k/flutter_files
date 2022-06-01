import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/file_explorer_controller.dart';
import '../../misc/hex_color.dart';

class CopyDialog extends StatelessWidget {
  const CopyDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width * 0.7,
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
      decoration: BoxDecoration(
        color: HexColor('#121212'),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Copying', style: TextStyle(color: Colors.white)),
          const SizedBox(height: 30),
          GetX<FileExplorerController>(
            builder: (controller) {
              return LinearProgressIndicator(
                color: Colors.amber,
                value: controller.fileList.isEmpty ? 0 : controller.filesCopied.value/controller.fileList.length * 100
              );
            },
          )
        ],
      ),
    );
  }
}
