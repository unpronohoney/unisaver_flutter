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
    required this.credit,
    required this.name,
    required this.letterGrade,
    this.newLetterGrade = "",
    this.no = -1,
  }) : id = _uuid.v4();

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
}
