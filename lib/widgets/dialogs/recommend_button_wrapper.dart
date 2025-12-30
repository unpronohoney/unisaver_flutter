import 'package:flutter/material.dart';
import 'package:unisaver_flutter/constants/colors.dart';
import 'package:unisaver_flutter/constants/suggestion_container.dart';

class RecommendedButtonWrapper extends StatelessWidget {
  final Widget child;
  final bool showCursor;
  final String message;

  const RecommendedButtonWrapper({
    super.key,
    required this.child,
    required this.showCursor,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,

      children: [
        child,

        if (showCursor)
          Positioned(top: -64, left: 32, child: _CursorBubble(message: message)),
      ],
    );
  }
}

class _CursorBubble extends StatelessWidget {
  final String message;

  const _CursorBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,

        child:
          Container(
            width: 160,
              decoration: BoxDecoration(boxShadow: [BoxShadow(offset: Offset(4, 4), color: AppColors.niceBlack, blurRadius: 16)], borderRadius: BorderRadius.circular(15)),
              child:
          CustomPaint(painter: BubblePainter(), child: Container(
            padding: EdgeInsets.all(15),
            margin: EdgeInsets.only(bottom: 10),
            child: Text(message, style: TextStyle(color: AppColors.niceBlack, fontSize: 14, fontFamily: 'Roboto'),)
      ),)
          ),



    );
  }
}
