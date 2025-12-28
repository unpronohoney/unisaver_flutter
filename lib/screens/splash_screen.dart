import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:unisaver_flutter/database/local_database_helper.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _StateSplashScreen();
}

class _StateSplashScreen extends State<SplashScreen> {
  startTimer() {
    Duration duration = Duration(seconds: 3);
    return Timer(duration, _navigate);
  }

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  _navigate() {
    bool isFirst = LocalStorageService.isFirstRun;
    if (!mounted) return;
    if (isFirst) {
      Navigator.pushNamed(context, '/user_type');
    } else {
      Navigator.pushNamed(context, '/home');
    }
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
