import 'package:unisaver_flutter/system/grade_point_average.dart';
import 'package:unisaver_flutter/system/lecture.dart';
import 'package:unisaver_flutter/system/letter_array.dart';

class Term {
  static Term? _instance;
  double oldgpa;
  int oldcred;
  GradePointAverage gpa;
  List<Lecture> lectures = [];
  Map<String, int> difficulties = {};
  List<List<int>> combinations = [];
  Map<double, List<int>> combsGroupedByGpas = {};
  List<Lecture> sortedLectures = [];

  // Private constructor
  Term._internal({
    required this.gpa,
    required this.oldgpa,
    required this.oldcred,
  });

  void setDifficulties(Map<String, int> data) {
    for (String id in data.keys) {
      var lect = lectures.where((l) => l.id == id).firstOrNull;
      if (lect != null) {
        difficulties[lect.id] = data[id]!;
      }
    }
  }

  // Static getter for singleton instance
  static Term get instance {
    _instance ??= Term._internal(
      gpa: GradePointAverage(totCred: 0, currentGPA: 0),
      oldgpa: 0,
      oldcred: 0,
    );
    return _instance!;
  }

  void initializeDifficulties() {
    difficulties = {for (var l in lectures) l.id: 0};
  }

  // Initialize method to set up the Term with initial GPA
  void initialize(GradePointAverage initialGpa) {
    gpa = initialGpa;
    oldgpa = initialGpa.currentGPA;
    oldcred = initialGpa.totCred;
    lectures.clear();
    combinations.clear();
    combsGroupedByGpas.clear();
    sortedLectures.clear();
  }

  // Reset method to clear all data
  void reset() {
    gpa = GradePointAverage(totCred: 0, currentGPA: 0);
    oldgpa = 0;
    oldcred = 0;
    lectures.clear();
    combinations.clear();
    combsGroupedByGpas.clear();
    sortedLectures.clear();
  }

  void resettoold() {
    gpa.currentGPA = oldgpa;
    gpa.totCred = oldcred;
  }

  void calculate() {
    gpa.currentGPA = oldgpa;
    gpa.totCred = oldcred;
    int credstoadd = 0;
    int tempcred = gpa.totCred;
    double tempgpa = gpa.currentGPA * tempcred;

    for (var lec in lectures) {
      tempgpa += LetterArray.calculateLecturePoint(
        lec.newLetterGrade,
        lec.credit,
      );
      if (LetterArray.checkLetterValid(lec.letterGrade)) {
        tempgpa -= LetterArray.calculateLecturePoint(
          lec.letterGrade,
          lec.credit,
        );
      } else {
        credstoadd += lec.credit;
      }
    }
    tempcred += credstoadd;
    tempgpa = tempgpa / tempcred;
    gpa.currentGPA = tempgpa;
    gpa.totCred = tempcred;
  }

  List<Lecture> getLectures() {
    return lectures;
  }

  bool manuelAddLecture(Lecture lec) {
    if (LetterArray.checkLetterValid(lec.letterGrade)) {
      var credits = lectures.map(
        (lect) =>
            LetterArray.checkLetterValid(lect.letterGrade) ? lect.credit : 0,
      );
      var totcredits = credits.fold(0.0, (a, b) => (a + b));
      if (totcredits + lec.credit > gpa.totCred) return false;
      if (totcredits + lec.credit == gpa.totCred) {
        double tempgpa = gpa.currentGPA;
        tempgpa = tempgpa * totcredits;
        double tempgpa2 = 0.0;
        for (var l in lectures) {
          if (LetterArray.checkLetterValid(l.letterGrade)) {
            tempgpa2 += LetterArray.calculateLecturePoint(
              l.letterGrade,
              l.credit,
            );
          }
        }
        if ((tempgpa2 * 100).round() != (tempgpa * 100).round()) return false;
      }
    }
    lec.setLectureNo(lectures.length + 1);
    lectures.add(lec);
    if (!LetterArray.checkLetterValid(lec.letterGrade)) {
      gpa.calcInsertNewLecture(lec.credit, lec.newLetterGrade);
    } else {
      gpa.calcInsertOldLecture(lec.credit, lec.letterGrade, lec.newLetterGrade);
    }
    return true;
  }

  void updateLecture(
    Lecture lec,
    int? newCred,
    String newOldLetter,
    String newNewLetter,
    bool isnewoldletternone,
  ) {
    lectures[lec.no - 1].credit = newCred ?? lec.credit;
    lectures[lec.no - 1].letterGrade =
        (LetterArray.checkLetterValid(newOldLetter) || isnewoldletternone)
        ? newOldLetter
        : lec.letterGrade;
    lectures[lec.no - 1].newLetterGrade =
        LetterArray.checkLetterValid(newNewLetter)
        ? newNewLetter
        : lec.newLetterGrade;
    calculate();
  }

  void deleteLecture(Lecture lec) {
    // Önce dersin index'ini bul
    final index = lectures.indexOf(lec);
    if (index == -1) return; // Ders bulunamadıysa çık

    // Dersi sil
    lectures.removeAt(index);

    // Silinen dersin numarasından itibaren numaraları güncelle
    for (int i = index; i < lectures.length; i++) {
      lectures[i].setLectureNo(i + 1);
    }
  }

  void addLecturesByList(List<Lecture> lecs) {
    lectures.addAll(lecs);
  }
}
