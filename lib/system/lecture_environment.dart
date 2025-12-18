import 'dart:math';

import 'package:flutter/material.dart';
import 'package:unisaver_flutter/system/lecture.dart';
import 'package:unisaver_flutter/system/letter_array.dart';
import 'package:unisaver_flutter/utils/loc.dart';

class LectureEnvironment {
  Lecture lect;
  String letterGrade = "";
  double influence = 0;
  LectureEnvironment({required this.lect});

  int randomize(
    String minLetter,
    String maxLetter,
    BuildContext context,
    double gpa,
    int totCred,
  ) {
    List<String> grades = LetterArray.letters;
    int minIndex = grades.indexOf(minLetter);
    int maxIndex = grades.indexOf(maxLetter);
    Random r = Random();
    int selected = maxIndex + r.nextInt(minIndex - maxIndex + 1);
    letterGrade = grades[selected];

    bool isNew = lect.letterGrade.compareTo(t(context).yok) == 0;

    double totalPoints = gpa * totCred;
    double newPoints = LetterArray.calculateLecturePoint(
      letterGrade,
      lect.credit,
    );
    double oldPoints = isNew
        ? 0
        : LetterArray.calculateLecturePoint(lect.letterGrade, lect.credit);
    totalPoints = totalPoints - oldPoints + newPoints;
    if (isNew) {
      totCred += lect.credit;
    }

    double newGpa = totalPoints / totCred;
    influence = newGpa - gpa;
    return isNew ? lect.credit : 0;
  }
}
