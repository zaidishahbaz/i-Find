import 'package:first_app/HomePage.dart';
import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';

class SplashPage extends StatefulWidget {
  // const SplashPage({Key key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      seconds: 5,
      navigateAfterSeconds: HomePage(),
      imageBackground: Image.asset("assets/back.jpg").image,
      loaderColor: Colors.amberAccent,
      loadingText: Text("shahbazzaidi15@gmail.com", style: TextStyle(color: Colors.white70),),
    );
  }
}
