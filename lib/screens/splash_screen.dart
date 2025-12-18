import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:unisaver_flutter/screens/main_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _StateSplashScreen();
}

class _StateSplashScreen extends State<SplashScreen> {
  startTimer() {
    Duration duration = Duration(seconds: 3);
    return Timer(duration, goMain);
  }

  void goMain() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const MainScreen()),
    );
  }

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Arka plan rengin
      body: Center(
        child: Lottie.asset(
          'assets/unisaver_splash.json', // Dosya yolun
          // İsteğe bağlı: Ekrana sığdırma ayarı
        ),
      ),
    );
  }
}
