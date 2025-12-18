class LetterArray {
  static Map<String, double> lettermap = {
    'AA': 4.0,
    'BA': 3.5,
    'BB': 3.0,
    'CB': 2.5,
    'CC': 2.0,
    'DC': 1.5,
    'DD': 1.0,
    'FD': 0.5,
    'FF': 0.0,
  };

  static void set(Map<String, double> values) {
    lettermap = Map.from(values);
    letters = lettermap.keys.toList()
      ..sort(
        (a, b) =>
            LetterArray.lettermap[b]!.compareTo(LetterArray.lettermap[a]!),
      );
  }

  static List<String> letters = lettermap.keys.toList();

  static double calculateLecturePoint(String letter, int credit) {
    final value = lettermap[letter];
    if (value == null) {
      throw Exception('Geçersiz harf notu.');
    }
    return value * credit;
  }

  static bool checkLetterValid(String letter) {
    final value = lettermap[letter];
    return (value != null);
  }

  static bool checkGpaValid(double gpa) {
    double max = lettermap[letters.first] ?? -1;
    double min = lettermap[letters.last] ?? -1;
    if (min == -1 || max == -1) {
      throw Exception('Letter Array okunamadi.');
    }
    if (max < min) {
      throw Exception('Min maxtan büyük geldi...');
    }
    return gpa <= max && min <= gpa;
  }
}
