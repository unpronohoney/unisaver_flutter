import 'dart:developer';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:unisaver_flutter/system/lecture.dart';
import 'package:unisaver_flutter/system/term.dart';

Future<void> saveSemesterToLocalForManuel() async {
  final box = await Hive.openBox('semesters');
  final data = {
    'oldGpa': Term.instance.oldgpa,
    'oldCredits': Term.instance.oldcred,
    'courses': Term.instance.lectures.map((c) => c.toMapForManuel()).toList(),
  };

  log('datamız: $data');

  await box.put('manuel', data);
}

Future<bool> readSemesterForManuel() async {
  final box = await Hive.openBox('semesters');
  bool ret = false;
  log('message');
  if (box.containsKey('manuel')) {
    final term = box.get('manuel');
    log('term: $term');
    if (term is Map &&
        term.containsKey('oldGpa') &&
        term.containsKey('oldCredits')) {
      Term.instance.oldgpa = term['oldGpa'];
      Term.instance.oldcred = term['oldCredits'];
      Term.instance.resettoold();
      ret = true;
      if (term.containsKey('courses') && term['courses'] is List) {
        final courses = term['courses'];
        Term.instance.lectures.clear();
        for (var course in courses) {
          Term.instance.lectures.add(
            Lecture.fromMapForManuel(Map<String, dynamic>.from(course)),
          );
        }
        Term.instance.calculate();
      }
      log(
        'gpa: ${Term.instance.gpa.currentGPA} - credits: ${Term.instance.gpa.totCred}',
      );
    }
  }
  log('ret: $ret');
  return ret;
}

Future<void> saveSemesterToLocalForCombination() async {
  final box = await Hive.openBox('semesters');
  final data = {
    'oldGpa': Term.instance.oldgpa,
    'oldCredits': Term.instance.oldcred,
    'courses': Term.instance.lectures
        .map((c) => c.toMapForCombination())
        .toList(),
    'difficulties': Term.instance.difficulties,
  };
  log('datamız: $data');
  await box.put('combination', data);
}

Future<bool> readSemesterForCombination() async {
  final box = await Hive.openBox('semesters');
  bool ret = false;
  if (box.containsKey('combination')) {
    final term = box.get('combination');
    if (term is Map &&
        term.containsKey('oldGpa') &&
        term.containsKey('oldCredits')) {
      Term.instance.oldgpa = term['oldGpa'];
      Term.instance.oldcred = term['oldCredits'];
      Term.instance.resettoold();
      ret = true;
      if (term.containsKey('courses') && term['courses'] is List) {
        final courses = term['courses'];
        Term.instance.lectures.clear();
        for (var course in courses) {
          Term.instance.lectures.add(
            Lecture.fromMapForCombination(Map<String, dynamic>.from(course)),
          );
        }
        if (term.containsKey('difficulties') && term['difficulties'] is Map) {
          Term.instance.difficulties = Map<String, int>.from(
            term['difficulties'],
          );
        }
      }
    }
  }
  return ret;
}
