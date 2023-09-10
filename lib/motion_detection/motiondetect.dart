import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tflite/flutter_tflite.dart';
import 'package:speechandtextvoicereconiton/main.dart';

class MotionDetaction extends StatefulWidget {
  const MotionDetaction({Key? key}) : super(key: key);

  @override
  State<MotionDetaction> createState() => _MotionDetactionState();
}

class _MotionDetactionState extends State<MotionDetaction> {

  @override
  void initState() {
    super.initState();
    loadCamera();
    loadmodel();
  }

  CameraImage? cameraImage;
  CameraController? cameraController;
  String output = "";
  
  loadCamera(){
    cameraController = CameraController(cameras![0], ResolutionPreset.medium);
    cameraController!.initialize().then((value) {

      if(!mounted){
        return ;
      }
      else{
        setState(() {
          cameraController!.startImageStream((imageStream) {
          cameraImage = imageStream;
          runModel();
          });
        });
      }

    });
  }

  runModel()async{
    if(cameraImage != null){
      var predection = await Tflite.runModelOnFrame(bytesList: cameraImage!.planes.map((plane) {
        return plane.bytes;
      }).toList(),
      imageHeight: cameraImage!.height,
        imageWidth: cameraImage!.width,
        imageMean: 127.5,
        imageStd: 127.5,
        rotation: 90,
        numResults: 2,
        threshold: 0.1,
        asynch: true
      );
      predection!.forEach((element) {

        setState(() {
          output = element['label'];

        });
      });
    }
  }
  loadmodel()async{
    await Tflite.loadModel(model: "assets/model_unquant.tflite",
    labels: "assets/labels.txt"
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Live emotion detection"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Container(
              height: MediaQuery.of(context).size.height*0.7,
              width: MediaQuery.of(context).size.width,
              child: !cameraController!.value.isInitialized?
              Container() :

                  AspectRatio(aspectRatio: cameraController!.value.aspectRatio,
                  child: CameraPreview(cameraController!),
                  ),
            ),
          ),
          
          Text(output ,style: TextStyle(fontWeight: FontWeight.bold,
          fontSize: 20
          ),)
        ],
      ),
    );
  }
}
