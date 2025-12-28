import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:unisaver_flutter/constants/colors.dart';
import 'package:unisaver_flutter/screens/splash_screen.dart';
import 'package:unisaver_flutter/utils/loc.dart';
import 'package:unisaver_flutter/widgets/buttons/purple_button.dart';

class NoInternetScreen extends StatelessWidget {
  const NoInternetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.wifi_off_rounded,
                size: 64,
                color: AppColors.darkBlue,
              ),
              const SizedBox(height: 24),
              Text(
                t(context).required_net,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.whiteish,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                t(context).net_desc,
                style: TextStyle(fontSize: 14, color: AppColors.blue),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              PurpleButton(
                text: t(context).retry,
                onPressed: () async {
                  final result = await Connectivity().checkConnectivity();
                  if (!result.contains(ConnectivityResult.none) &&
                      context.mounted) {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (_) => const SplashScreen()),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
