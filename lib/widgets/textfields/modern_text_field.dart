import 'package:flutter/material.dart';
import 'package:unisaver_flutter/constants/colors.dart';

class ModernTextField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final TextInputType keyboardType;
  final bool hasError;
  final VoidCallback? onErrorReset;

  final int? maxLength;
  final bool autoWidth;

  const ModernTextField({
    super.key,
    this.keyboardType = TextInputType.text,
    required this.controller,
    required this.label,
    this.maxLength,
    this.autoWidth = false,
    this.hasError = false,
    this.onErrorReset,
  });

  @override
  State<ModernTextField> createState() => _ModernTextFieldState();
}

class _ModernTextFieldState extends State<ModernTextField>
    with SingleTickerProviderStateMixin {
  late final FocusNode _focusNode;
  late final AnimationController _animationController;
  late final Animation<double> _labelAnimation;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    _labelAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    );

    // Başlangıçta text varsa label yukarıda başlasın
    if (widget.controller.text.isNotEmpty) {
      _animationController.value = 1.0;
    }

    _focusNode.addListener(_handleFocusChange);
    widget.controller.addListener(_handleTextChange);
  }

  void _handleFocusChange() {
    if (_focusNode.hasFocus) {
      if (widget.hasError && widget.onErrorReset != null) {
        widget.onErrorReset!();
      }
    }
    if (_focusNode.hasFocus || widget.controller.text.isNotEmpty) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
    setState(() {});
  }

  void _handleTextChange() {
    if (widget.controller.text.isNotEmpty) {
      _animationController.forward();
    } else if (!_focusNode.hasFocus) {
      _animationController.reverse();
    }
    setState(() {});
  }

  @override
  void dispose() {
    _focusNode.removeListener(_handleFocusChange);
    widget.controller.removeListener(_handleTextChange);
    _focusNode.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textStyle = const TextStyle(fontSize: 16);
    final labelStyle = const TextStyle(fontSize: 16);

    final textWidth = _measureTextWidth(
      widget.controller.text.isEmpty ? " " : widget.controller.text,
      textStyle,
    );

    final labelWidth = _measureTextWidth(widget.label, labelStyle);

    final calculatedWidth =
        (textWidth > labelWidth ? textWidth : labelWidth) + 48;

    final fieldWidth = calculatedWidth.clamp(120, 340).toDouble();

    return widget.autoWidth
        ? SizedBox(width: fieldWidth, child: _buildStack())
        : _buildStack();
  }

  Widget _buildStack() {
    final isFocused = _focusNode.hasFocus;
    final hasText = widget.controller.text.isNotEmpty;
    final shouldFloat = isFocused || hasText;
    final borderColor = widget.hasError
        ? AppColors.red
        : (isFocused
              ? AppColors.darkBlue
              : Theme.of(context).colorScheme.primaryFixed);

    return Stack(
      clipBehavior: Clip.none,
      children: [
        // TextField
        TextField(
          controller: widget.controller,
          focusNode: _focusNode,
          keyboardType: widget.keyboardType,
          maxLength: widget.maxLength,
          style: const TextStyle(fontSize: 16, color: AppColors.niceBlack),
          buildCounter:
              (_, {required currentLength, maxLength, required isFocused}) =>
                  null,
          decoration: InputDecoration(
            hintText: shouldFloat ? null : widget.label,
            hintStyle: const TextStyle(
              color: AppColors.grayishBlue,
              fontSize: 16,
            ),
            filled: true,
            fillColor: AppColors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 4,
            ),
            border: OutlineInputBorder(
              borderSide: BorderSide(
                color: borderColor,
                width: widget.hasError ? 3 : 1.5,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: borderColor,
                width: widget.hasError ? 3 : 1.5,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: borderColor, width: 2),
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
        // Floating label with white background container
        AnimatedBuilder(
          animation: _labelAnimation,
          builder: (context, child) {
            return Positioned(
              left: 16,
              top: -8 - (26 * (1 - _labelAnimation.value)),
              child: Opacity(
                opacity: shouldFloat ? 1.0 : 0.0,
                child: Transform.scale(
                  scale: 0.85 + (0.15 * _labelAnimation.value),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      widget.label,
                      style: TextStyle(
                        fontSize: 12 + (2 * (1 - _labelAnimation.value)),
                        color: isFocused
                            ? AppColors.blue
                            : AppColors.grayishBlue,
                        fontWeight: isFocused
                            ? FontWeight.w600
                            : FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  double _measureTextWidth(String text, TextStyle style) {
    final painter = TextPainter(
      text: TextSpan(text: text, style: style),
      maxLines: 1,
      textDirection: TextDirection.ltr,
    )..layout();

    return painter.width;
  }
}
