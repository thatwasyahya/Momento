import 'dart:async';
import 'package:flutter/material.dart';
import 'welcome.dart'; // Importez la page suivante à laquelle vous souhaitez rediriger

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Utilisez un Timer pour retarder la navigation vers la page suivante
    Timer(Duration(seconds: 3), () {
      // Naviguez vers la page suivante une fois la durée écoulée
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => WelcomeScreen()), // Remplacez WelcomeScreen() par la page suivante
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.only(top: 382, bottom: 387),
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(color: Color(0xFF0DCDAA)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 390,
                height: 75,
                child: Text(
                  'Momento!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 64,
                    fontStyle: FontStyle.italic,
                    fontFamily: 'Mulish',
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
