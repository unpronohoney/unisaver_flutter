import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:unisaver_flutter/system/lecture.dart';
import 'package:unisaver_flutter/system/lecture_cubit.dart';
import 'package:unisaver_flutter/system/transcript_reader.dart';
import 'package:unisaver_flutter/utils/loc.dart';
import 'package:unisaver_flutter/widgets/dialogs/bottom_sheet_constants.dart';
import 'package:unisaver_flutter/widgets/drop_down_spinner.dart';
import 'package:unisaver_flutter/widgets/textfields/modern_text_field.dart';
import 'package:unisaver_flutter/widgets/buttons/purple_button.dart';
import 'package:unisaver_flutter/widgets/texts/common_text.dart';

void showEditDialog(
  BuildContext context,
  Lecture? lecture,
  int type,
  List<String> letters,
  TranscriptReader? reader,
  int idx,
  VoidCallback setNotifier,
) {
  final creditCtrl = TextEditingController();
  final gradeCtrl = ValueNotifier<String?>(null);
  final newGradeCtrl = ValueNotifier<String?>(null);
  final nameCtrl = TextEditingController();

  if (lecture != null) {
    creditCtrl.text = lecture.credit.toString();
    gradeCtrl.value = lecture.letterGrade;
    newGradeCtrl.value = type != 3
        ? lecture.newLetterGrade
        : lecture.letterGrade;
  }

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Container(
          padding: const EdgeInsets.all(20),
          constraints: BoxConstraints(maxHeight: 70.h),
          decoration: bottomSheetDecoration(context),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                bottomSheetHandler(context),
                const SizedBox(height: 16),
                bottomSheetTitle(context, t(context).edit_lecture),
                if (lecture != null) const SizedBox(height: 24),
                if (lecture != null)
                  bottomSheetDescription(context, lecture.name),

                const SizedBox(height: 24),

                if (type == 4)
                  ModernTextField(
                    controller: nameCtrl,
                    label: t(context).manuel_5,
                  ),

                if (type == 4) const SizedBox(height: 24),

                ModernTextField(
                  controller: creditCtrl,
                  label: t(context).credit,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                ),

                if (type == 1 || type == 2) const SizedBox(height: 16),

                if (type == 1 || type == 2)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CommonText(text: '${t(context).old_letter}:'),
                      DropDownSpinner(
                        notifier: gradeCtrl,
                        items: [t(context).yok, ...letters],
                        maxWidth: 200,
                      ),
                    ],
                  ),

                if (type == 1 || type == 3 || type == 4)
                  const SizedBox(height: 16),

                if (type == 1 || type == 3 || type == 4)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CommonText(
                        text: type == 1
                            ? '${t(context).new_letter}:'
                            : '${t(context).letter_grade}:',
                      ),
                      DropDownSpinner(
                        notifier: newGradeCtrl,
                        items: letters,
                        maxWidth: 200,
                      ),
                    ],
                  ),

                const SizedBox(height: 32),
                Center(
                  child: PurpleButton(
                    onPressed: () {
                      if (creditCtrl.text.isNotEmpty &&
                          double.tryParse(
                                creditCtrl.text.replaceAll(',', '.'),
                              ) !=
                              null) {
                        //credit control not null
                        double credit = double.parse(
                          creditCtrl.text.replaceAll(',', '.'),
                        );
                        if (credit < 1) return; //credit is not lower than 1

                        if (lecture != null) {
                          //lecture is not null so this is update
                          if (type == 1) {
                            context.read<LectureCubit>().updateLecture(
                              lecture,
                              credit,
                              gradeCtrl.value!,
                              newGradeCtrl.value!,
                              (gradeCtrl.value!.compareTo(t(context).yok) == 0),
                            );
                            setNotifier();
                          } else if (type == 2) {
                            context
                                .read<LectureCubit>()
                                .updateLectureForCombination(
                                  lecture,
                                  credit,
                                  gradeCtrl.value!,
                                  (gradeCtrl.value!.compareTo(t(context).yok) ==
                                      0),
                                );
                            setNotifier();
                          } else if (type == 3) {
                            reader!.updateLesson(
                              idx,
                              credit,
                              newGradeCtrl.value!,
                            );
                          }
                        } else {
                          if (type == 4 &&
                              nameCtrl.text.isNotEmpty &&
                              newGradeCtrl.value != null) {
                            reader!.addLesson(
                              nameCtrl.text,
                              credit,
                              newGradeCtrl.value!,
                            );
                          } else {
                            return;
                          }
                        }
                        Navigator.pop(context);
                      }
                    },
                    text: t(context).save,
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      );
    },
  );
}
