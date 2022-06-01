import 'dart:io';

import 'package:file_manager/views/wrapper/wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';


void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  await Permission.manageExternalStorage.request();
  await Permission.accessMediaLocation.request();
  await Permission.mediaLibrary.request();
  await Permission.photos.request();
  await Permission.storage.request();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return GetMaterialApp(
      title: 'File Manager',
      theme: ThemeData(
        textTheme: GoogleFonts.varelaRoundTextTheme(),
        brightness: Brightness.dark,
      ),
      home: const Wrapper()
    );
  }
}
