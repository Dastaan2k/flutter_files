import 'dart:math';

import 'package:file_manager/controllers/app_controller.dart';
import 'package:file_manager/misc/hex_color.dart';
import 'package:file_manager/models/file_entity.dart';
import 'package:file_manager/controllers/dashboard_controller.dart';
import 'package:file_manager/widgets/appbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    print('Dashboard build : ${Random.secure().nextDouble().toString()}');

    return Material(
      color: HexColor('#121212'),
      child: SizedBox(
        width: Get.width, height: Get.height,
        child: ListView(
          physics: const BouncingScrollPhysics(),
          children: const [
            CustomAppbar(),
            Center(child: DeviceNameWidget()),
            SizedBox(height: 30),
            Center(child: MemoryWidget()),
            SizedBox(height: 10),
            RAMInfoWidget(),
            SizedBox(height: 10),
            MemoryDistributionCard(),
            SizedBox(height: 20),
            CategoryWidget(),
            SizedBox(height: 40),
            //RecentFilesWidget()
          ],
        ),
      ),
    );
  }
}



class DeviceNameWidget extends StatelessWidget {
  const DeviceNameWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
      child: GetX<DashboardController>(
        builder: (controller) {
          return Text(controller.modelName.value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w500, color: Colors.white));
        }
      ),
    );
  }
}



class MemoryWidget extends StatelessWidget {
  const MemoryWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.45,
      height: MediaQuery.of(context).size.width * 0.45,
      child: GetX<DashboardController>(
        builder: (controller) {
          return CustomPaint(
            painter: GraphPainter1(value: controller.usedDisk.value == 0 ? 0 : (controller.usedDisk.value/controller.totalDisk.value)),
            child: Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 60.0),
                  child: Column(
                    children: [
                      controller.totalDisk.value == 0 ? const Text('--%', style: TextStyle(color: Colors.white, fontSize: 26)) : Text('${(((controller.usedDisk / 1000 / 1000 / 1000)/(controller.totalDisk / 1000 / 1000 / 1000)) * 100).round()}%', style: const TextStyle(color: Colors.white, fontSize: 26)),
                      const SizedBox(height: 10),
                      Text('${(controller.usedDisk / 1000 / 1000 / 1000).toStringAsFixed(1)} / ${(controller.totalDisk / 1000 / 1000 / 1000).toStringAsFixed(1)} GB', style: TextStyle(color: Colors.grey.shade400, fontSize: 14))
                    ],
                  ),
                )
            )
          );
        }
      ),
    );
  }
}


class GraphPainter1 extends CustomPainter {

  double value;

  GraphPainter1({required this.value});

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawArc(Rect.fromLTRB(0, 0, size.width, size.height), 3*pi/4, 3*pi/2, false, Paint()..color=Colors.grey.shade700..strokeWidth=2..style=PaintingStyle.stroke..strokeCap=StrokeCap.round);
    canvas.drawArc(Rect.fromLTRB(0, 0, size.width, size.height), 3*pi/4, (3*pi/2) * value, false, Paint()..color=Colors.amberAccent..strokeWidth=10..style=PaintingStyle.stroke..strokeCap=StrokeCap.round);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }

}



class RAMInfoWidget extends StatelessWidget {
  const RAMInfoWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GetX<DashboardController>(
          builder: (controller) {
            return Text('${(controller.usedRAM / 1000 / 1000 / 1000).toStringAsFixed(2)} / ${(controller.totalRAM / 1000 / 1000 / 1000).toStringAsFixed(2)} GB', style: const TextStyle(color: Colors.white));
          }
        ),
        const SizedBox(height: 5),
        Text('RAM', style: TextStyle(color: Colors.grey.shade400))
      ],
    );
  }
}




class MemoryDistributionCard extends StatelessWidget {
  const MemoryDistributionCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20, top: 50, bottom: 20),
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.grey.shade900,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), spreadRadius: 4)]
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GetX<DashboardController>(
              builder: (controller) {
                return Row(
                  children: [
                    const Icon(Icons.description, size: 20),
                    const SizedBox(width: 20),
                    Text('${(controller.documentListSize.value / 1000 / 1000 / 1000).toStringAsFixed(2)} GB', style: TextStyle(color: Colors.grey.shade400, fontSize: 12)),
                    const Expanded(child: SizedBox()),
                    AnimatedContainer(duration: const Duration(milliseconds: 200), height: 7.5, width: controller.totalSize.value == 0 ? 0 : (width * 0.5) * (controller.documentListSize.value/controller.totalSize.value), decoration: BoxDecoration(color: Colors.amber, borderRadius: BorderRadius.circular(10))),
                  ],
                );
              }
            ),
            const SizedBox(height: 20),
            GetX<DashboardController>(
                builder: (controller) {
                  return Row(
                    children: [
                      const Icon(Icons.image, size: 20),
                      const SizedBox(width: 20),
                      Text('${(controller.imageListSize.value / 1000 / 1000 / 1000).toStringAsFixed(2)} GB', style: TextStyle(color: Colors.grey.shade400, fontSize: 12)),
                      const Expanded(child: SizedBox()),
                      AnimatedContainer(duration: const Duration(milliseconds: 200), height: 7.5, width: controller.totalSize.value == 0 ? 0 : (width * 0.5) * (controller.imageListSize.value/controller.totalSize.value), decoration: BoxDecoration(color: Colors.amber, borderRadius: BorderRadius.circular(10))),
                    ],
                  );
                }
            ),
            const SizedBox(height: 20),
            GetX<DashboardController>(
                builder: (controller) {
                  return Row(
                    children: [
                      const Icon(Icons.videocam, size: 20),
                      const SizedBox(width: 20),
                      Text('${(controller.videoListSize.value / 1000 / 1000 / 1000).toStringAsFixed(2)} GB', style: TextStyle(color: Colors.grey.shade400, fontSize: 12)),
                      const Expanded(child: SizedBox()),
                      AnimatedContainer(duration: const Duration(milliseconds: 200), height: 7.5, width: controller.totalSize.value == 0 ? 0 : (width * 0.5) * (controller.videoListSize.value/controller.totalSize.value), decoration: BoxDecoration(color: Colors.amber, borderRadius: BorderRadius.circular(10))),
                    ],
                  );
                }
            ),
            const SizedBox(height: 20),
            GetX<DashboardController>(
                builder: (controller) {
                  return Row(
                    children: [
                      const Icon(Icons.audiotrack_rounded, size: 20),
                      const SizedBox(width: 20),
                      Text('${(controller.audioListSize.value / 1000 / 1000 / 1000).toStringAsFixed(2)} GB', style: TextStyle(color: Colors.grey.shade400, fontSize: 12)),
                      const Expanded(child: SizedBox()),
                      AnimatedContainer(duration: const Duration(milliseconds: 200), height: 7.5, width: controller.totalSize.value == 0 ? 0 : (width * 0.5) * (controller.audioListSize.value/controller.totalSize.value), decoration: BoxDecoration(color: Colors.amber, borderRadius: BorderRadius.circular(10))),
                    ],
                  );
                }
            ),
          ],
        ),
      ),
    );
  }
}



class RecentFilesWidget extends StatelessWidget {
  const RecentFilesWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text('Recently opened', style: TextStyle(color: Colors.white, fontSize: 24)),
          SizedBox(height: 20),
          RecentFileCard(),
          RecentFileCard(),
          RecentFileCard(),
        ],
      ),
    );
  }
}


class RecentFileCard extends StatelessWidget {
  const RecentFileCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: Container(
        width: Get.width,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 17.5),
        decoration: BoxDecoration(
            color: Colors.grey.shade900,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), spreadRadius: 4)]
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Whatsapp', style: TextStyle(color: Colors.white)),
            const SizedBox(height: 5),
            Text('30 GB, ', style: TextStyle(color: Colors.grey.shade400, fontSize: 12))
          ],
        ),
      ),
    );
  }
}




class CategoryWidget extends StatelessWidget {
  const CategoryWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: const [
        CategoryButton(category: FileTypeEnum.DOCUMENT),
        CategoryButton(category: FileTypeEnum.VIDEO),
        CategoryButton(category: FileTypeEnum.AUDIO),
        CategoryButton(category: FileTypeEnum.IMAGE)
      ],
    );
  }
}






class CategoryButton extends StatelessWidget {

  final FileTypeEnum category;

  const CategoryButton({Key? key, required this.category}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.put(AppController()).selectedCategory.value = category;
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.amber,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Icon(getIcon(category), color: Colors.white, size: 28),
          ),
          const SizedBox(height: 10),
          Text(getTitle(category), style: const TextStyle(color: Colors.white, fontSize: 12)),
          const SizedBox(height: 5),
          GetX<DashboardController>(
            builder: (controller) {
              return Text(
                  category == FileTypeEnum.VIDEO ? '${controller.videosList.value.length} files'
                  : category == FileTypeEnum.IMAGE ? '${controller.imagesList.value.length} files'
                  : category == FileTypeEnum.DOCUMENT ? '${controller.documentsList.value.length} files'
                  : category == FileTypeEnum.APK ? '${controller.apksList.value.length} files'
                  : category == FileTypeEnum.AUDIO ? '${controller.audiosList.value.length} files' : '-- files', style: TextStyle(color: Colors.grey.shade400, fontSize: 10));
            }
          )
        ],
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