import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:musci_app/screens/homePage.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Timer(
      const Duration(seconds: 6),
      () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const HomePage(),
          ),
        );
      },
    );

    return MaterialApp(
      home: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: SweepGradient(
              colors: [Color(0xffcc2b5e), Color(0xff2e073b)],
              stops: [0.5, 1],
              center: Alignment.bottomLeft,
            ),
          ),
          child:  Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.asset('assets/animations/Animation - 1709111053811.json'),
            ],
          ),
        ),
      ),
    );
  }
}
