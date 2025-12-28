import 'package:flutter/material.dart';
import 'package:unisaver_flutter/constants/colors.dart';
import 'package:unisaver_flutter/system/lecture.dart';
import 'package:unisaver_flutter/system/term.dart';
import 'package:unisaver_flutter/utils/loc.dart';

class DifficultyMatrix extends StatefulWidget {
  final VoidCallback draggedAction;
  const DifficultyMatrix({super.key, required this.draggedAction});

  @override
  State<DifficultyMatrix> createState() => _DifficultyMatrixState();
}

class _DifficultyMatrixState extends State<DifficultyMatrix> {
  final colors = {
    -2: Color(0xff1B5E20),
    -1: Color.fromARGB(255, 60, 167, 66),
    0: Color.fromARGB(255, 222, 188, 93),
    1: Color(0xFF9E1D1D),
    2: Color(0xff7B1FA2),
  };

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          difficultyRow(2, t(context).hardest),
          difficultyRow(1, t(context).hard),
          difficultyRow(0, t(context).medium),
          difficultyRow(-1, t(context).easy),
          difficultyRow(-2, t(context).easiest),
        ],
      ),
    );
  }

  Widget difficultyRow(int level, String label) {
    final bool islight = Theme.of(context).brightness == Brightness.light;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color: Theme.of(context).colorScheme.secondaryFixed,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 6),

        DragTarget<Lecture>(
          onAcceptWithDetails: (details) {
            final lec = details.data;
            setState(() {
              Term.instance.difficulties[lec.id] = level;
            });
            widget.draggedAction();
          },
          builder: (context, candidateData, rejectedData) {
            return Container(
              clipBehavior: Clip.hardEdge,
              height: 88,
              decoration: BoxDecoration(
                color: islight
                    ? colors[level]!.withValues(alpha: 0.1)
                    : colors[level]!.withValues(alpha: 0.18),
                borderRadius: BorderRadius.circular(22),
                border: Border.all(
                  color: islight
                      ? colors[level]!.withValues(alpha: 0.8)
                      : colors[level]!.withValues(alpha: 0.6),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.25),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: Term.instance.lectures
                    .where((l) => Term.instance.difficulties[l.id] == level)
                    .map((l) => draggableLessonBox(l, level))
                    .toList(),
              ),
            );
          },
        ),

        const SizedBox(height: 16),
      ],
    );
  }

  Widget draggableLessonBox(Lecture lesson, int lvl) {
    return Draggable<Lecture>(
      data: lesson,
      feedback: Material(
        color: Colors.transparent,
        child: Container(
          width: 100,
          height: 88,
          decoration: BoxDecoration(
            color: colors[lvl]!,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.3),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
        ),
      ),
      childWhenDragging: Opacity(opacity: 0.3, child: lessonBox(lesson, lvl)),
      child: lessonBox(lesson, lvl),
    );
  }

  Widget lessonBox(Lecture lect, int lvl) {
    return TooltipTheme(
      data: TooltipThemeData(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.25),
          borderRadius: BorderRadius.circular(12),
        ),
        textStyle: TextStyle(
          color: Theme.of(context).colorScheme.tertiaryFixed,
          fontSize: 13,
        ),
      ),
      child: Container(
        width: 100,
        height: 88,
        margin: const EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.whiteish.withValues(alpha: 0.95),
              AppColors.grayishBlue.withValues(alpha: 0.9),
            ],
          ),
          borderRadius: BorderRadius.circular(20),
          border: BoxBorder.all(
            color: colors[lvl]!.withValues(alpha: 0.65),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.22),
              blurRadius: 10,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: double.infinity,
              child: Text(
                '${lect.no}. ${lect.name}',
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 12,
                  color: AppColors.blue,
                ),
                maxLines: 2,
                softWrap: false,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Text(
              t(context).lecture_card(lect.credit, lect.letterGrade),
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 12,
                color: AppColors.blue,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
