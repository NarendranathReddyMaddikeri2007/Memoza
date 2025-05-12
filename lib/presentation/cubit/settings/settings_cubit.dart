import 'package:bloc/bloc.dart';
import 'package:memoza/data/models/settings/settings_model.dart';
import 'package:memoza/data/repositories/settings/settings_repository.dart';

class SettingsCubit extends Cubit<Settings> {
  final SettingsRepository settingsRepository;

  SettingsCubit({
    required this.settingsRepository,
  }) : super(settingsRepository.getInitialSetting());

  void toggleTheme(isDarkMode) {
    //Retrive the grid state as we are updating only the theme and not the layout
    Settings settings = settingsRepository.getInitialSetting();
    //Update the values in the database
    settingsRepository.putSettingsToBox(
        isGrid: settings.isGrid,
        isDarkMode: isDarkMode,
        language: settings.language,
        color: settings.color);
    emit(isDarkMode
        ? Settings(
            isGrid: settings.isGrid,
            isDarkMode: true,
            language: settings.language,
            color: settings.color)
        : Settings(
            isGrid: settings.isGrid,
            isDarkMode: false,
            language: settings.language,
            color: settings.color));
  }

  void toggleLayout(isGrid) {
    Settings settings = settingsRepository.getInitialSetting();
    settingsRepository.putSettingsToBox(
        isGrid: isGrid,
        isDarkMode: settings.isDarkMode,
        language: settings.language,
        color: settings.color);

    emit(isGrid
        ? Settings(
            isGrid: true,
            isDarkMode: settings.isDarkMode,
            language: settings.language,
            color: settings.color)
        : Settings(
            isGrid: false,
            isDarkMode: settings.isDarkMode,
            language: settings.language,
            color: settings.color));
  }
}
