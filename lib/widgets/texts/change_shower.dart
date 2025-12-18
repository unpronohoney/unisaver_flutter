import 'package:flutter/material.dart';
import 'package:unisaver_flutter/constants/colors.dart';

class ChangeShower extends StatelessWidget {
  final double diff;
  const ChangeShower({super.key, required this.diff});
  @override
  Widget build(BuildContext context) {
    return Text(
      diff > 0 ? ' +$diff' : ' $diff',
      style: TextStyle(
        color: diff > 0 ? AppColors.koyuYesil : AppColors.red,
        fontSize: 16,
        fontFamily: 'Monospace',
      ),
    );
  }
}
