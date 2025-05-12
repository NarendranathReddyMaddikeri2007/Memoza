import 'package:equatable/equatable.dart';
import 'package:hive_flutter/adapters.dart';

part 'settings_model.g.dart';

@HiveType(typeId: 2)
class Settings extends Equatable {
  @HiveField(0)
  final bool isGrid;

  @HiveField(1)
  final bool isDarkMode;

  @HiveField(2)
  final String color;

  @HiveField(3)
  final String language;

  const Settings(
      {required this.isGrid,
      required this.isDarkMode,
      required this.color,
      required this.language});

  @override
  List<Object?> get props => [isGrid, isDarkMode, color, language];

  Settings copyWith({
    bool? isGrid,
    bool? isDarkMode,
    String? color,
    String? language,
  }) {
    return Settings(
      isGrid: isGrid ?? this.isGrid,
      isDarkMode: isDarkMode ?? this.isDarkMode,
      color: color ?? this.color,
      language: language ?? this.language,
    );
  }
}
