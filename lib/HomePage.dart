import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

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
          }
        });
      });
    });
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
                Center(
                  child: Container(
                    height: 320,
                    width: 330,
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
          ),
        ),
      ),
    );
  }
}
