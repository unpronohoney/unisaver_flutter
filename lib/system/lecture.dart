import 'package:uuid/uuid.dart';

class Lecture {
  static final _uuid = Uuid();

  final String id;
  int credit;
  String letterGrade;
  String name;
  String newLetterGrade;
  int no;
  Lecture({
    String? id,
    required this.credit,
    required this.name,
    required this.letterGrade,
    this.newLetterGrade = "",
    this.no = -1,
  }) : id = id ?? _uuid.v4();

  void setCredit(int cred) {
    credit = cred;
  }

  void setNewLetter(String letter) {
    newLetterGrade = letter;
  }

  void setLectureNo(int no) {
    this.no = no;
  }

  void setLetterGrade(String letter) {
    letterGrade = letter;
  }

  Map<String, dynamic> toMapForManuel() => {
    'no': no,
    'name': name,
    'credit': credit,
    'oldLetter': letterGrade,
    'newLetter': newLetterGrade,
  };

  factory Lecture.fromMapForManuel(Map<String, dynamic> map) {
    return Lecture(
      no: map['no'],
      name: map['name'],
      credit: map['credit'],
      letterGrade: map['oldLetter'],
      newLetterGrade: map['newLetter'],
    );
  }

  Map<String, dynamic> toMapForCombination() => {
    'id': id,
    'no': no,
    'name': name,
    'credit': credit,
    'oldLetter': letterGrade,
  };

  factory Lecture.fromMapForCombination(Map<String, dynamic> map) {
    return Lecture(
      id: map['id'],
      no: map['no'],
      name: map['name'],
      credit: map['credit'],
      letterGrade: map['oldLetter'],
    );
  }
}
