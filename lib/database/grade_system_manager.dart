import 'package:hive/hive.dart';
import 'package:unisaver_flutter/system/letter_array.dart';

class GradeSystemManager {
  static final Map<String, double> defaultSystem = {
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

  static late Box _box;

  static Future<void> selectSystem(Map<String, dynamic> system) async {
    await _box.put('selectedSystem', system);
    LetterArray.set(Map<String, double>.from(system['letters']));
  }

  static void initLetterArray() {
    LetterArray.set(
      Map<String, double>.from(_box.get('selectedSystem')['letters']),
    );
  }

  static Future<void> startEditingSystem(Map<String, dynamic> system) async {
    await _box.put('editingSystem', system);
  }

  static Map<String, dynamic>? get editingSystem {
    final sys = Map<String, dynamic>.from(_box.get('editingSystem'));
    if (sys['name'] == '') {
      return null;
    }
    return sys;
  }

  static Future<void> endEditingSystem(
    Map<String, double> newletters,
    String newName,
    bool newEdit,
  ) async {
    if (newEdit) {
      final list = userSystems;
      list.add({'name': newName, 'letters': newletters});
      await _box.put('userSystems', list);
      return;
    }
    final old = Map<String, dynamic>.from(_box.get('editingSystem'));
    final list = userSystems;
    final idx = list.indexWhere((s) => s['name'] == old['name']);
    if (idx == -1) return;
    final updated = {'name': newName, 'letters': newletters};
    list[idx] = updated;
    await _box.put('userSystems', list);
    final selected = selectedSystemMap;
    if (selected!['name'] == old['name']) {
      await _box.put('selectedSystem', updated);
      LetterArray.set(newletters);
    }
    await _box.put('editingSystem', {'name': ''});
  }

  static Future<void> resetEditingSystem() async {
    await _box.put('editingSystem', {'name': ''});
  }

  static List<Map<String, dynamic>> get userSystems {
    final list = _box.get('userSystems');
    if (list != null) {
      return (list as List).map((e) => Map<String, dynamic>.from(e)).toList();
    }
    return [];
  }

  static Map<String, dynamic>? getArrayByName(String name) {
    final list = _box.get('userSystems');
    List<Map<String, dynamic>> listmap = [];
    if (list != null) {
      listmap = (list as List)
          .map((e) => Map<String, dynamic>.from(e))
          .toList();
    }
    for (var array in listmap) {
      if (array['name'] == name) return array;
    }
    return null;
  }

  static Future<void> init() async {
    _box = Hive.box('gradeSystems');

    // 1) Application (default) sistemi yoksa oluştur
    if (!_box.containsKey('application')) {
      _box.put('application', {'name': 'Default', 'letters': defaultSystem});
    }

    // 2) Eğer selectedSystem yoksa varsayılanı kaydet
    if (!_box.containsKey('selectedSystem')) {
      _box.put('selectedSystem', {'name': 'Default', 'letters': defaultSystem});
    }

    await resetEditingSystem();

    // 3) LetterArray'i güncelle → sadece letters map gerekiyor
    final selected = _box.get('selectedSystem');

    if (selected is Map && selected.containsKey('letters')) {
      LetterArray.set(Map<String, double>.from(selected['letters']));
    } else {
      // her ihtimale karşı fallback
      LetterArray.set(defaultSystem);
    }
  }

  static Future<bool> addSystem(
    String name,
    Map<String, double> letters,
  ) async {
    final newSystem = {"name": name, "letters": letters};

    // Çakışma kontrolü
    for (var system in userSystems) {
      if (system['name'] == newSystem['name']) {
        return false;
      }
    }

    final list = [...userSystems, newSystem];
    await _box.put('userSystems', list);
    return true;
  }

  static Map<String, dynamic>? get selectedSystemMap {
    final stored = _box.get('selectedSystem');
    if (stored is Map && stored['name'] is String && stored['letters'] is Map) {
      return {
        'name': stored['name'],
        'letters': Map<String, double>.from(stored['letters']),
      };
    }

    return null;
  }

  static Map<String, dynamic> get defaultSystemMap {
    final stored = _box.get('application');
    if (stored is Map &&
        stored.containsKey('name') &&
        stored.containsKey('letters') &&
        stored['letters'] is Map) {
      return {
        'name': stored['name'],
        'letters': Map<String, double>.from(stored['letters']),
      };
    }
    final fixed = {'name': 'Default', 'letters': defaultSystem};

    _box.put('application', fixed);
    return fixed;
  }

  static Future<void> deleteSystem(Map<String, dynamic> system) async {
    if (system['name'] == "Default") return;

    final list = userSystems.where((s) => s['name'] != system['name']).toList();
    await _box.put('userSystems', list);

    final selected = selectedSystemMap;
    if (selected!['name'] == system['name']) {
      await _box.put('selectedSystem', {
        'name': 'Default',
        'letters': defaultSystem,
      });
    }
  }
}
