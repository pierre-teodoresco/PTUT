
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

  _navigateToHome()async {
    await Future.delayed(const Duration(milliseconds: 2500), () {});
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MainMenu()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children:  [
          const DelayedAnimation(
          delay: 250,
          child: SizedBox(
            height: 150,
            child: FlutterLogo(size:100),
          ),
        ),
        DelayedAnimation(
          delay: 500,
          child: Container(
            margin: const EdgeInsets.only(
              top: 30,
              bottom: 20,
            ),
            child: Text('GUYS AND GUYS ',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(color: Colors.grey, fontSize: 15)
            ),
          ),
        ),
      ]),
    ));
  }
}