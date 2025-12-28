import 'dart:math';

import 'package:unisaver_flutter/system/lecture.dart';

class CombinationConstraints {
  static List<List<int>> findAllCombinations(
    List<Lecture> sortedLectures,
    Map<String, int> diffs,
    List<String> letters,
  ) {
    List<List<int>> combinations = [];
    final minIndex = letters.length - 1;
    final maxIndex = 0;
    List<int> previous = [];
    int safety = 0;
    //dev.log("${diffs.length}", name: "comb_calc");
    final List<int> lectureDiffs = [];
    for (Lecture l in sortedLectures) {
      lectureDiffs.add(diffs[l.id]!);
    }
    //dev.log("${sortedLectures.length}", name: "comb_calc");
    int size = sortedLectures.length;
    while (safety < 1_000_000) {
      safety++;
      combinations.add([]);
      bool lap = false;
      for (int idx = 0; idx < size; idx++) {
        if (combinations.length > 1) {
          //dev.log("combinations>1", name: "comb_calc");
          if (idx == 0 && previous[idx] == minIndex) {
            bool control = false;
            for (int idx2 = 1; idx2 < size; idx2++) {
              int letter = previous[idx2];
              if (letter != minIndex) {
                control = true;
                if (lectureDiffs[idx2] < lectureDiffs[0]) {
                  letter++;
                } else {
                  letter = maxIndex;
                }
                for (idx2++; idx2 < size; idx2++) {
                  int letter2 = previous[idx2];
                  if (lectureDiffs[idx2] < lectureDiffs[idx] &&
                      letter2 > letter) {
                    letter = letter2;
                  }
                }
                combinations.last.add(letter);
                lap = true;
                break;
              }
            }
            if (!control) {
              combinations.removeLast();
              return combinations;
            }
          } else if (idx == 0) {
            int letter = previous[idx] + 1;
            for (int idx2 = idx + 1; idx2 < size; idx2++) {
              int letter2 = previous[idx2];
              if (lectureDiffs[idx2] < lectureDiffs[idx] && letter2 > letter) {
                letter = letter2;
              }
            }
            combinations.last.add(letter);
          } else if (lap) {
            int lett = previous[idx];
            if (lett == minIndex) {
              int letter = minIndex;
              for (int idx2 = idx + 1; idx2 < size; idx2++) {
                letter = previous[idx2];
                if (letter != minIndex) {
                  if (lectureDiffs[idx2] < lectureDiffs[idx]) {
                    letter++;
                  } else {
                    letter = maxIndex;
                  }
                  for (idx2++; idx2 < size; idx2++) {
                    int letter2 = previous[idx2];
                    if (lectureDiffs[idx2] < lectureDiffs[idx] &&
                        letter2 > letter) {
                      letter = letter2;
                    }
                  }
                  combinations.last.add(letter);
                  break;
                }
              }
            } else {
              lap = false;
              lett++;
              for (int idx2 = idx + 1; idx2 < size; idx2++) {
                int letter2 = previous[idx2];
                if (lectureDiffs[idx2] < lectureDiffs[idx] && letter2 > lett) {
                  lett = letter2;
                }
              }
              combinations.last.add(lett);
            }
          } else {
            combinations.last.add(previous[idx]);
          }
        } else {
          combinations.last.add(maxIndex);
        }
      }
      previous = List<int>.from(combinations.last);
    }
    return combinations;
  }

  static Map<double, List<int>> listByGpas(
    double gpa,
    int totcred,
    List<List<int>> combinations,
    List<Lecture> sortedLectures,
    String noneLetter,
    Map<String, double> letterArray,
  ) {
    double calculated;
    int calcCred;
    Map<double, List<int>> combinationsByGpas = {};
    final letters = letterArray.keys.toList();
    for (int c = 0; c < combinations.length; c++) {
      final combination = combinations[c];
      calculated = gpa * totcred;
      calcCred = totcred;
      for (int i = 0; i < combination.length; i++) {
        final lect = sortedLectures[i];
        calculated += letterArray[letters[combination[i]]]! * lect.credit;
        if (lect.letterGrade != noneLetter) {
          calculated -= letterArray[lect.letterGrade]! * lect.credit;
        } else {
          calcCred += lect.credit;
        }
      }
      calculated = calculated / calcCred;
      calculated = (calculated * 100.0).roundToDouble() / 100.0;
      if (!combinationsByGpas.containsKey(calculated)) {
        combinationsByGpas[calculated] = [c];
      } else {
        combinationsByGpas[calculated]!.add(c);
      }
    }
    return combinationsByGpas;
  }

  static Map<double, List<int>> applyConstraints(
    List<List<int>> combinations,
    double gpa,
    int totcred,
    List<Lecture> sortedLectures,
    String noneLetter,
    double minGpa,
    double maxGpa,
    List<String> forbiddenLetters,
    int maxCombCountWithSameGpa,
    double marginBetweenGpas,
    Map<String, double> letterArray,
  ) {
    double calculated;
    int calcCred;
    Map<double, List<int>> appliedCombinations = {};
    final letters = letterArray.keys.toList();
    final forbiddenSet = forbiddenLetters.toSet();
    for (int c = 0; c < combinations.length; c++) {
      final combination = combinations[c];
      calculated = gpa * totcred;
      calcCred = totcred;
      bool control = false;
      for (int i = 0; i < combination.length; i++) {
        if (forbiddenSet.contains(letters[combination[i]])) {
          control = true;
          break;
        }
        final lect = sortedLectures[i];
        calculated += letterArray[letters[combination[i]]]! * lect.credit;
        if (lect.letterGrade != noneLetter) {
          calculated -= letterArray[lect.letterGrade]! * lect.credit;
        } else {
          calcCred += lect.credit;
        }
      }
      if (control) continue;
      calculated = calculated / calcCred;
      calculated = (calculated * 100.0).roundToDouble() / 100.0;
      if (calculated >= minGpa && calculated <= maxGpa) {
        if (!appliedCombinations.containsKey(calculated)) {
          appliedCombinations[calculated] = [c];
        } else {
          appliedCombinations[calculated]!.add(c);
        }
      }
    }
    if (appliedCombinations.isEmpty) return appliedCombinations;
    int realMaxLength = appliedCombinations.values
        .map((list) => list.length)
        .reduce((a, b) => a > b ? a : b);

    if (marginBetweenGpas != 0.01) {
      int gap = (marginBetweenGpas * 100).round();
      appliedCombinations.removeWhere((sampleGpa, value) {
        int smp = (sampleGpa * 100).round();
        return smp % gap != 0;
      });
    }
    if (realMaxLength > maxCombCountWithSameGpa) {
      final rand = Random();
      appliedCombinations.forEach((key, list) {
        while (list.length > maxCombCountWithSameGpa) {
          int randomIndex = rand.nextInt(list.length);
          list.removeAt(randomIndex);
        }
      });
    }
    return appliedCombinations;
  }
}

class ListByGpaPayload {
  final double gpa;
  final int totcred;
  final List<List<int>> combinations;
  final List<Lecture> sortedLectures;
  final String noneLetter;
  final Map<String, double> letterArray;

  ListByGpaPayload({
    required this.gpa,
    required this.totcred,
    required this.combinations,
    required this.sortedLectures,
    required this.noneLetter,
    required this.letterArray,
  });
}

class ApplyConstraintsPayload {
  final double gpa;
  final int totcred;
  final List<List<int>> combinations;
  final List<Lecture> sortedLectures;
  final String noneLetter;
  final double minGpa;
  final double maxGpa;
  final List<String> forbiddenLetters;
  final int maxCombCountWithSameGpa;
  final double marginBetweenGpas;
  final Map<String, double> letterArray;

  ApplyConstraintsPayload({
    required this.gpa,
    required this.totcred,
    required this.combinations,
    required this.sortedLectures,
    required this.noneLetter,
    required this.minGpa,
    required this.maxGpa,
    required this.forbiddenLetters,
    required this.maxCombCountWithSameGpa,
    required this.marginBetweenGpas,
    required this.letterArray,
  });
}

class FindAllCombinationsPayload {
  final List<Lecture> sortedLectures;
  final Map<String, int> difficulties;
  final List<String> letters;

  FindAllCombinationsPayload({
    required this.sortedLectures,
    required this.difficulties,
    required this.letters,
  });
}
