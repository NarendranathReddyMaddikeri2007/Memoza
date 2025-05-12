import 'package:hive/hive.dart';
import 'package:memoza/data/models/settings/settings_model.dart';

class SettingsRepository {
  final Box<Settings> box;

  SettingsRepository({required this.box});

  static openBox(String boxName) async {
    Box<Settings> box = await Hive.openBox(boxName);
    return box;
  }

  initializeSettings() {
    if (box.isEmpty) {
      box.put(0,
          Settings(isGrid: false, isDarkMode: true, color: '', language: ''));
    }
  }

  Settings getInitialSetting() {
    List<Settings> settings = box.values.toList().cast<Settings>();
    return settings[0];
  }

  void putSettingsToBox(
      {required bool isGrid,
      required bool isDarkMode,
      required String color,
      required String language}) {
    box.putAt(
        0,
        Settings(
            isGrid: isGrid,
            isDarkMode: isDarkMode,
            color: color,
            language: language));
  }
}
