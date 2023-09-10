import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:speechandtextvoicereconiton/maskdetection/home.dart';

import 'motion_detection/motiondetect.dart';

List<CameraDescription>? cameras;
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: MotionDetaction()
    );
  }
}
