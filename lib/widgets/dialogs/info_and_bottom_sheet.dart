import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:unisaver_flutter/widgets/dialogs/bottom_sheet_constants.dart';

Widget infoButton(
  BuildContext context,
  VoidCallback onTap, {
  IconData icon = Icons.help_outline_outlined,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Theme.of(
          context,
        ).colorScheme.tertiaryFixed.withValues(alpha: 0.12),
        border: Border.all(
          color: Theme.of(
            context,
          ).colorScheme.secondaryFixed.withValues(alpha: 0.4),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),
            blurRadius: 6,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Center(child: Icon(icon, color: Colors.white, size: 28)),
    ),
  );
}

void showDescriptionBottomSheet(
  BuildContext context,
  String title,
  String? description,
  Widget? content,
) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (context) {
      return Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Container(
          padding: const EdgeInsets.all(20),
          constraints: BoxConstraints(maxHeight: 50.h),
          decoration: bottomSheetDecoration(context),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              bottomSheetHandler(context),
              bottomSheetTitle(context, title),
              const SizedBox(height: 16),
              if (description != null)
                bottomSheetDescription(context, description),
              const SizedBox(height: 12),
              if (content != null)
                Expanded(child: SingleChildScrollView(child: content)),
              const SizedBox(height: 20),
            ],
          ),
        ),
      );
    },
  );
}
