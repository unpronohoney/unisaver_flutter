import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:unisaver_flutter/screens/no_internet_screen.dart';

class InternetGate extends StatefulWidget {
  final Widget child;
  const InternetGate({super.key, required this.child});

  @override
  State<InternetGate> createState() => _InternetGateState();
}

class _InternetGateState extends State<InternetGate> {
  bool hasInternet = false;

  @override
  void initState() {
    super.initState();
    _checkConnection();

    Connectivity().onConnectivityChanged.listen((
      List<ConnectivityResult> results,
    ) {
      final connected = !results.contains(ConnectivityResult.none);

      if (connected != hasInternet) {
        setState(() => hasInternet = connected);
      }
    });
  }

  Future<void> _checkConnection() async {
    final results = await Connectivity().checkConnectivity();
    setState(() {
      hasInternet = !results.contains(ConnectivityResult.none);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!hasInternet) {
      return const NoInternetScreen();
    }
    return widget.child;
  }
}
