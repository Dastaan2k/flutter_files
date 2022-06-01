import 'package:file_manager/models/file_entity.dart';
import 'package:get/get.dart';

class AppController extends GetxController {

  RxBool drawerToggle = false.obs;
  RxBool fileOptionsBottomBarToggle = false.obs;
  RxBool createEntityBottomBarToggle = false.obs;

  Rxn<FileTypeEnum> selectedCategory = Rxn<FileTypeEnum>();

  Rx<ViewEnum> currentView = ViewEnum.DASHBOARD.obs;

}


enum ViewEnum {
  DASHBOARD, FILE_EXP
}