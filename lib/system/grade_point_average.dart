import 'package:unisaver_flutter/system/lecture.dart';
import 'package:unisaver_flutter/system/letter_array.dart';

class GradePointAverage {
  int totCred;
  double currentGPA;
  GradePointAverage({required this.totCred, required this.currentGPA});

  int getTotCred() {
    return totCred;
  }

  double getCurrentGPA() {
    return currentGPA;
  }

  void calcInsertNewLecture(int cred, String letter) {
    currentGPA =
        currentGPA * totCred + LetterArray.calculateLecturePoint(letter, cred);
    totCred += cred;
    currentGPA = currentGPA / totCred;
  }

  void calcInsertOldLecture(int cred, String oldLetter, String newLetter) {
    currentGPA = currentGPA * totCred;
    currentGPA =
        currentGPA +
        LetterArray.calculateLecturePoint(newLetter, cred) -
        LetterArray.calculateLecturePoint(oldLetter, cred);
    currentGPA = currentGPA / totCred;
  }

  void calcChangeCredit(
    int oldCred,
    String oldLetter,
    String newLetter,
    int newCred,
  ) {
    currentGPA = currentGPA * totCred;
    if (LetterArray.checkLetterValid(oldLetter)) {
      //oldLetter yok - none değilse
      currentGPA +=
          (LetterArray.calculateLecturePoint(oldLetter, oldCred) -
              LetterArray.calculateLecturePoint(newLetter, oldCred)) +
          (LetterArray.calculateLecturePoint(newLetter, newCred) -
              LetterArray.calculateLecturePoint(oldLetter, newCred));
      totCred = totCred - oldCred + newCred;
    } else {
      currentGPA =
          currentGPA -
          LetterArray.calculateLecturePoint(newLetter, oldCred) +
          LetterArray.calculateLecturePoint(newLetter, newCred);
      totCred = totCred - oldCred + newCred;
    }
    currentGPA = currentGPA / totCred;
  }

  void calcChangeOldLetter(int cred, String oldLetter, String newOldLetter) {
    currentGPA = currentGPA * totCred;
    if (!LetterArray.checkLetterValid(oldLetter)) {
      currentGPA =
          currentGPA - LetterArray.calculateLecturePoint(newOldLetter, cred);
      totCred = totCred - cred;
    } else if (!LetterArray.checkLetterValid(newOldLetter)) {
      currentGPA =
          currentGPA + LetterArray.calculateLecturePoint(oldLetter, cred);
      totCred = totCred + cred;
    } else {
      currentGPA =
          currentGPA +
          (LetterArray.calculateLecturePoint(oldLetter, cred) -
              LetterArray.calculateLecturePoint(newOldLetter, cred));
    }
    currentGPA = currentGPA / totCred;
  }

  void calcDeleteLecture(Lecture lec) {
    currentGPA = currentGPA * totCred;
    if (LetterArray.checkLetterValid(lec.letterGrade)) {
      currentGPA =
          currentGPA -
          LetterArray.calculateLecturePoint(lec.newLetterGrade, lec.credit);
      totCred = totCred - lec.credit;
    } else {
      currentGPA =
          currentGPA -
          LetterArray.calculateLecturePoint(lec.newLetterGrade, lec.credit) +
          LetterArray.calculateLecturePoint(lec.newLetterGrade, lec.credit);
    }
    currentGPA = currentGPA / totCred;
  }

  void calcChangeNewLetter(int cred, String newLetter, String newNewLetter) {
    currentGPA = currentGPA * totCred;
    currentGPA =
        currentGPA +
        LetterArray.calculateLecturePoint(newNewLetter, cred) -
        LetterArray.calculateLecturePoint(newLetter, cred);
    currentGPA = currentGPA / totCred;
  }
}
