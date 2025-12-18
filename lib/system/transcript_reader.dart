import 'package:flutter/material.dart';
import 'package:unisaver_flutter/system/lecture.dart';

class TranscriptReader extends ChangeNotifier {
  double _gpa = 0.0;
  double _scale = 0;
  int _cred = 0;
  double _computedGpa = 0.0;
  double _roundedPreviousGpa = 0.0;
  double _roundedComputedGpa = 0.0;
  int _computedCred = 0;
  String _studentName = '';
  final Map<String, double> notes = {};
  final List<Lecture> lessons = [];
  final List<String> lessonNames = [];
  final List<int> credits = [];
  final List<int> aktsValues = [];
  final List<String> lessonLetters = [];
  final List<String> lessonDescriptions = [];
  final List<String> lessonCodes = [];
  final List<String> trustCodes = [];
  final List<Lecture> deleteds = [];
  final Map<String, bool> initUsedNotes = {};
  bool isCred = false;
  int diffLevel = 0;

  String _capitalize(String str) {
    if (str.isEmpty) return '';

    final parts = str.split(' ');
    final List<String> out = [];

    for (final w in parts) {
      if (w.isEmpty) continue;

      final first = w.substring(0, 1).toUpperCase();
      final rest = w.length > 1 ? w.substring(1).toLowerCase() : '';

      out.add('$first$rest');
    }

    return out.join(' ');
  }

  void removeLesson(int row) {
    if (row < 0 || row >= lessons.length) return;
    deleteds.add(lessons[row]);
    lessons.removeAt(row);
    for (int i = row; i < lessons.length; i++) {
      lessons[i].no = i + 1;
    }
    compute();
  }

  void updateLesson(int row, int credit, String letter) {
    lessons[row].credit = credit;
    if (notes.keys.contains(letter)) {
      lessons[row].letterGrade = letter;
    }
    compute();
  }

  void undoLastDeleted() {
    if (deleteds.isNotEmpty) {
      deleteds.last.no = lessons.length + 1;
      lessons.add(deleteds.last);
      deleteds.removeLast();
      compute();
    }
  }

  void addLesson(String name, int credit, String note) {
    lessons.add(
      Lecture(
        credit: credit,
        name: name,
        letterGrade: note,
        no: lessons.length,
      ),
    );
    compute();
  }

  void compute() {
    double actualGpa = 0.0;
    int totCred = 0;
    for (var i = 0; i < lessons.length; i++) {
      final letter = lessons[i].letterGrade;
      final value = notes[letter] ?? 0.0;
      actualGpa += value * lessons[i].credit;
      totCred += lessons[i].credit;
    }
    if (totCred == 0) {
      _computedCred = 0;
      _computedGpa = 0.0;
      _roundedPreviousGpa = 0.0;
      _roundedComputedGpa = 0.0;
    } else {
      actualGpa /= totCred;
      if (_roundedComputedGpa == _roundedPreviousGpa) {
        _roundedPreviousGpa = actualGpa;
      } else {
        _roundedPreviousGpa = _roundedComputedGpa;
      }
      _computedGpa = actualGpa;
      _roundedComputedGpa = (_computedGpa * 100).round() / 100;
      _computedCred = totCred;
    }
    notifyListeners();
  }

  void reset() {
    lessons.clear();
    lessonCodes.clear();
    lessonDescriptions.clear();
    lessonLetters.clear();
    lessonNames.clear();
    aktsValues.clear();
    notes.clear();
    credits.clear();
    trustCodes.clear();
    deleteds.clear();
    initUsedNotes.clear();
    _gpa = 0;
    _cred = 0;
    _computedCred = 0;
    _computedGpa = 0;
    _roundedComputedGpa = 0;
    _roundedPreviousGpa = 0;
    diffLevel = 0;
  }

  void backUp() {
    lessons.clear();

    for (int i = 0; i < lessonNames.length; i++) {
      if (isCred) {
        lessons.add(
          Lecture(
            credit: credits[i],
            name: lessonNames[i],
            letterGrade: lessonLetters[i],
          ),
        );
      } else if (!isCred) {
        lessons.add(
          Lecture(
            credit: aktsValues[i],
            name: lessonNames[i],
            letterGrade: lessonLetters[i],
          ),
        );
      }
    }

    final seen = <String>{};
    final newLessons = <Lecture>[];
    final newCodes = <String>[];

    for (int i = lessonCodes.length - 1; i >= 0; i--) {
      final code = lessonCodes[i];
      if (trustCodes.contains(code)) {
        newLessons.add(lessons[i]);
      } else {
        if (!seen.contains(code)) {
          seen.add(code);
          newLessons.add(lessons[i]);
          newCodes.add(code);
        }
      }
    }
    lessons.clear();
    lessons.addAll(newLessons.reversed);

    List<List<Lecture>> lessonsByNames = [];
    for (Lecture l in lessons) {
      bool added = false;
      for (List<Lecture> llist in lessonsByNames) {
        if (llist[0].name == l.name) {
          llist.add(l);
          added = true;
        }
      }
      if (!added) {
        lessonsByNames.add([]);
        lessonsByNames.last.add(l);
      }
    }
    List<Lecture> newlessons = [];
    for (List<Lecture> llist in lessonsByNames) {
      newlessons.add(llist.last);
    }
    lessons.clear();
    lessons.addAll(newlessons);
    lessons.removeWhere((l) => l.credit == 0);
    int counter = 1;
    for (Lecture l in lessons) {
      l.no = counter;
      counter++;
    }

    compute();
  }

  void extractAll(String text) {
    final namePattern = RegExp(
      r"Doğum Tarihi\s*[\r\n]+(?:\s*.*[\r\n]+){2}\s*([A-ZÇĞİÖŞÜ ]+)",
    );

    final mName = namePattern.firstMatch(text);
    if (mName != null) {
      _studentName = _capitalize(mName.group(1) ?? '');
    }
    final surname = RegExp(r"Soyadı\s*\r?\n\s*(.+)");
    final mSurname = surname.firstMatch(text);

    if (mSurname != null) {
      String srnm = _capitalize(mSurname.group(1)!.trim());
      _studentName = '$_studentName $srnm t'.trim();
    }

    if (_studentName.isNotEmpty) {
      if (_studentName.isNotEmpty) {
        _studentName = _studentName.substring(0, _studentName.length - 1);
      }
    }

    final credPattern = RegExp(r"Başarılan Kredi\s*[\r\n]+\s*(\d+)");

    final mCred = credPattern.firstMatch(text);

    if (mCred != null) {
      _cred = int.tryParse(mCred.group(1) ?? '') ?? 0;
    }

    final scalePattern = RegExp(
      r"\((\d+(?:[.,]\d+)?)\s*Scale\)\s*\n\s*(\d+[.,]\d+)",
    );

    final mScale = scalePattern.firstMatch(text);

    if (mScale != null) {
      _scale = double.tryParse(mScale.group(1) ?? '') ?? 0.0;
      final agnoStr = (mScale.group(2) ?? '').replaceAll(',', '.');
      _gpa = double.tryParse(agnoStr) ?? 0.0;
    }
    lessonNames.clear();
    credits.clear();
    aktsValues.clear();
    notes.clear();
    lessonLetters.clear();
    lessonDescriptions.clear();
    _computedGpa = 0.0;
    _computedCred = 0;
    lessonCodes.clear();
    trustCodes.clear();
    deleteds.clear();
    _extractTableData(text);
    backUp();
  }

  void _extractTableData(String text) {
    final notesPatt = RegExp(
      r'^\s*([A-ZÇĞİÖŞÜ]{1,3}[+-]?(?:\s*\([^)]+\))?)\s*\n\s*([\d]+(?:[.,]\d+)?)\s*$',
      multiLine: true,
    );
    final pointspart = text.split('Puanlar').last.trim();
    final matches = notesPatt.allMatches(pointspart);
    for (final m in matches) {
      final letter = m.group(1)!.trim();
      final rawVal = m.group(2)!;
      final val = double.tryParse(rawVal.replaceAll(',', '.')) ?? 0.0;
      notes[letter] = val;
    }

    final lessonpatt = RegExp(
      r"^\s*([a-zçğiöşüA-ZÇĞİÖŞÜ0-9 ]+)\s*\r?\n"
      r"\s*([^\r\n]+)\s*\r?\n"
      r"(?:\s*\([^\r\n]+\)\s*\r?\n)?"
      r"\s*[A-Z]\s*\r?\n"
      r"\s*[^\r\n]+\s*\r?\n"
      r"\s*\d+\s*\r?\n"
      r"\s*\d+\s*\r?\n"
      r"\s*(\d+)\s*\r?\n"
      r"\s*(\d+)\s*\r?\n"
      r"\s*\d+(?:[.,]\d+)?\s*\r?\n"
      r"\s*([A-Zİ+\-]{1,3})\s*\r?\n"
      r"\s*([^\r\n]+)\s*$",
      multiLine: true,
    );

    final lessonmatches = lessonpatt.allMatches(text);
    //int c = 0;
    for (final m in lessonmatches) {
      final lessonCode = m.group(1)!;
      final lessonName = m.group(2)!;
      final credit = int.parse(m.group(3)!);
      final akts = int.parse(m.group(4)!);
      final letter = m.group(5)!;
      final desc = m.group(6)!;

      if (notes.containsKey(letter) && !desc.contains('YRN')) {
        //final pointVal = notes[letter]!;
        lessonCodes.add(lessonCode);
        lessonNames.add(lessonName);
        credits.add(credit);
        aktsValues.add(akts);
        lessonLetters.add(letter);
        lessonDescriptions.add(desc);
        //c++;
        //log(
        //  '$c Ders: $lessonName, cr: $credit, akts: $akts, harf: $letter → $pointVal, açıklama: $desc',
        //);
      }
    }
    int totakts = aktsValues.fold(0, (a, b) => a + b);
    int totcredits = credits.fold(0, (a, b) => a + b);
    int creddiff = _cred > totcredits ? _cred - totcredits : totcredits - _cred;
    int aktsdiff = _cred > totakts ? _cred - totakts : totakts - _cred;
    isCred = creddiff <= aktsdiff;

    final equivBlockRegex = RegExp(
      r"Eşdeğer\s*\(Equivalent\)[\s\S]*?(?=\(.*?Term\))",
      caseSensitive: false,
    );

    final tripleRegex = RegExp(
      r"\n\s*[^\n]+\s*\n\s*-\s*\n\s*([a-zçğiöşüA-ZÇĞİÖŞÜ0-9 ]+)",
      multiLine: true,
    );

    final blockMatch = equivBlockRegex.allMatches(text);
    for (var m in blockMatch) {
      final codes = tripleRegex
          .allMatches(m.group(0)!)
          .map((ma) => ma.group(1)!)
          .toList();
      trustCodes.addAll(codes);
    }
    for (String str in notes.keys) {
      initUsedNotes[str] = lessonLetters.contains(str);
    }
    double gpa = (_gpa * 100).round() / 100;
    if (_roundedComputedGpa != gpa && _cred != _computedCred) {
      diffLevel = 3;
    } else if (_roundedComputedGpa != gpa) {
      diffLevel = 1;
    } else if (_cred != _computedCred) {
      diffLevel = 2;
    } else {
      diffLevel = 0;
    }
  }

  double get gpa => (_gpa * 100).round() / 100;
  double get scale => _scale;
  int get cred => _cred;
  double get computedGpa => _roundedComputedGpa;
  double get getDiffirence =>
      ((_roundedComputedGpa - _roundedPreviousGpa) * 100).round() / 100;
  int get computedCred => _computedCred;
  String get studentName => _studentName;
}
