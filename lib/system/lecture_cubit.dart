import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unisaver_flutter/system/grade_point_average.dart';
import 'package:unisaver_flutter/system/lecture.dart';
import 'package:unisaver_flutter/system/letter_array.dart';
import 'package:unisaver_flutter/system/term.dart';

class LectureCubit extends Cubit<LectureState> {
  LectureCubit() : super(LectureState(lectures: Term.instance.lectures));

  /// Yeni ders ekleme
  bool addLecture(Lecture lecture) {
    bool success = false;
    if (Term.instance.manuelAddLecture(lecture)) {
      success = true;
    }
    emit(state.copyWith(lectures: List.from(Term.instance.lectures)));
    return success;
  }

  /// Silme
  void deleteLecture(Lecture lecture) {
    Term.instance.deleteLecture(lecture);
    Term.instance.calculate();
    emit(state.copyWith(lectures: List.from(Term.instance.lectures)));
  }

  bool addLectureForCombination(Lecture lecture) {
    if (LetterArray.checkLetterValid(lecture.letterGrade)) {
      var credits = Term.instance.lectures.map(
        (lect) =>
            LetterArray.checkLetterValid(lect.letterGrade) ? lect.credit : 0,
      );
      var totcredits = credits.fold(0.0, (a, b) => (a + b));
      if (totcredits + lecture.credit > Term.instance.gpa.totCred) return false;
      if (totcredits + lecture.credit == Term.instance.gpa.totCred) {
        double tempgpa = Term.instance.gpa.currentGPA;
        tempgpa = tempgpa * totcredits;
        double tempgpa2 = 0.0;
        for (var l in Term.instance.lectures) {
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
    lecture.setLectureNo(Term.instance.lectures.length + 1);
    Term.instance.lectures.add(lecture);
    emit(state.copyWith(lectures: List.from(Term.instance.lectures)));
    return true;
  }

  void deleteLectureForCombination(Lecture lecture) {
    Term.instance.deleteLecture(lecture);
    emit(state.copyWith(lectures: List.from(Term.instance.lectures)));
  }

  void updateLectureForCombination(
    Lecture lect,
    int? newcred,
    String newoldLetter,
    bool isnewoldletternone,
  ) {
    Term.instance.lectures[lect.no - 1].credit = newcred ?? lect.credit;
    Term.instance.lectures[lect.no - 1].letterGrade =
        (LetterArray.checkLetterValid(newoldLetter) || isnewoldletternone)
        ? newoldLetter
        : lect.letterGrade;
    emit(state.copyWith(lectures: List.from(Term.instance.lectures)));
  }

  void updateLecture(
    Lecture lect,
    int? newcred,
    String newoldLetter,
    String newnewLetter,
    bool isnewoldletternone,
  ) {
    Term.instance.updateLecture(
      lect,
      newcred,
      newoldLetter,
      newnewLetter,
      isnewoldletternone,
    );
    emit(state.copyWith(lectures: List.from(Term.instance.lectures)));
  }

  void clearLectures() {
    Term.instance.lectures.clear();
    Term.instance.gpa = GradePointAverage(
      totCred: Term.instance.oldcred,
      currentGPA: Term.instance.oldgpa,
    );
    emit(state.copyWith(lectures: []));
  }
}

class LectureState {
  final List<Lecture> lectures;

  LectureState({required this.lectures});

  LectureState copyWith({List<Lecture>? lectures}) {
    return LectureState(lectures: lectures ?? this.lectures);
  }
}
