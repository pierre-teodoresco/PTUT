
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ptut_game/delayed_animation.dart';
import 'iu/menu.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {

  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  _navigateToHome() async {
    await Future.delayed(const Duration(milliseconds: 2500), () {});
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MainMenu()));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: DelayedAnimation(
              delay: 250,
              child: Image.asset('../assets/Logo.png')
          )
        ), //   <-- image
      ),
    );
  }
}