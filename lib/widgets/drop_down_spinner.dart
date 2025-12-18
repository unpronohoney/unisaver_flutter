import 'package:flutter/material.dart';
import 'package:unisaver_flutter/utils/loc.dart';
import '../constants/colors.dart';

class DropDownSpinner extends StatefulWidget {
  final ValueNotifier<String?> notifier;
  final List<String> items;

  final double? maxWidth;

  const DropDownSpinner({
    super.key,
    required this.notifier,
    required this.items,
    this.maxWidth,
  });

  @override
  State<DropDownSpinner> createState() => _DropDownSpinnerState();
}

class _DropDownSpinnerState extends State<DropDownSpinner> {
  bool _isFocused = false;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String?>(
      valueListenable: widget.notifier,
      builder: (context, value, child) {
        return Focus(
          onFocusChange: (hasFocus) {
            setState(() {
              _isFocused = hasFocus;
            });
          },
          child: widget.maxWidth != null
              ? SizedBox(width: widget.maxWidth, child: _buildContainer())
              : _buildContainer(),
        );
      },
    );
  }

  Widget _buildContainer() {
    final hasValue = widget.notifier.value != null;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _isFocused
              ? AppColors.darkBlue
              : Theme.of(context).colorScheme.primaryFixed,
          width: _isFocused ? 2 : 1.5,
        ),
        boxShadow: _isFocused
            ? [
                BoxShadow(
                  color: AppColors.blue.withValues(alpha: 0.12),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ]
            : [
                const BoxShadow(
                  color: Colors.black12,
                  blurRadius: 6,
                  offset: Offset(0, 3),
                ),
              ],
      ),
      child: DropdownButton<String>(
        isExpanded: true,
        isDense: true,
        underline: const SizedBox.shrink(),
        icon: Icon(
          Icons.keyboard_arrow_down_rounded,
          color: _isFocused ? AppColors.blue : AppColors.grayishBlue,
          size: 24,
        ),
        hint: Text(
          t(context).select,
          style: const TextStyle(
            fontFamily: 'Roboto',
            fontSize: 16,
            color: AppColors.grayishBlue,
          ),
        ),
        value: widget.notifier.value,
        style: TextStyle(
          fontFamily: 'Roboto',
          fontSize: 16,
          color: hasValue ? AppColors.niceBlack : AppColors.grayishBlue,
        ),
        items: widget.items
            .map(
              (e) => DropdownMenuItem(
                value: e,
                child: Text(
                  e,
                  style: const TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 16,
                    color: AppColors.niceBlack,
                  ),
                ),
              ),
            )
            .toList(),
        onChanged: (v) => widget.notifier.value = v,
        dropdownColor: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        menuMaxHeight: 300,
      ),
    );
  }
}
