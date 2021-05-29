import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:tflite/tflite.dart';

import 'main.dart';

class HomePage extends StatefulWidget {
  // const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  CameraController cameraController;
  bool isWorking = false;
  String result="";
  CameraImage imgCamera;

  loadModel() async {
    await Tflite.loadModel(
      model: "assets/mobilenet_v1_1.0_224.tflite",
      labels: "assets/mobilenet_v1_1.0_224.txt",
    );
  }

  initCamera(){
    cameraController = CameraController(cameras[0], ResolutionPreset.medium);
    cameraController.initialize().then((value) {
      if(!mounted){
        return;
      }
      setState(() {
        cameraController.startImageStream((imagesFromStream) => {
          if(!isWorking){
            isWorking = true,
            imgCamera = imagesFromStream,
            runModelOnStreamFrames(),
          }
        });
      });
    });
  }

  runModelOnStreamFrames() async{
    if(imgCamera != null){
      var recognitions = await Tflite.runModelOnFrame(
        bytesList: imgCamera.planes.map( (plane){
          return plane.bytes;
        }).toList(),
        imageHeight: imgCamera.height,
        imageWidth: imgCamera.width,
        imageMean: 127.5,
        imageStd: 127.5,
        rotation: 90,
        numResults: 2,
        threshold: 0.1,
        asynch: true,
      );

      result = "";
      recognitions.forEach((response) {
        result += response["label"] + " " + (response["confidence"] as double).toStringAsFixed(2) + "\n\n";
      });

      setState(() {
        result;
      });

      isWorking = false;

    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadModel();
  }

  @override
  void dispose() async {
    // TODO: implement dispose
    super.dispose();

    await Tflite.close();
    cameraController.dispose();

  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SafeArea(
        child: Scaffold(
          body: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/jarvis.jpg")
              )
            ),
            child: Column(
              children: [
                Stack(
                  children: [
                    Center(
                      child: Container(
                        color: Colors.black,
                        height: 320,
                        width: 360,
                        child: Image.asset("assets/camera.jpg"),
                      ),
                    ),
                    Center(
                        child: TextButton(
                          onPressed: (){
                            initCamera();
                          },
                          child: Container(
                            margin: EdgeInsets.only(top: 35),
                            height: 270,
                            width: 360,
                            child: imgCamera == null ? Container(
                              height: 270,
                              width: 360,
                              child: Icon(Icons.camera, color: Colors.blueAccent, size: 40,),
                            )
                                : AspectRatio(
                              aspectRatio: cameraController.value.aspectRatio,
                              child: CameraPreview(cameraController),
                            ),
                          ),
                        )
                    ),
                  ],
                ),
                Center(
                  child: Container(
                    margin: EdgeInsets.only(top: 55.0),
                    child: SingleChildScrollView(
                      child: Text(
                        result,
                        style: TextStyle(
                          backgroundColor: Colors.black54,
                          fontSize: 30.0,
                          color: Colors.white70,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
