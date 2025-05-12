import 'package:equatable/equatable.dart';
import 'package:hive_flutter/adapters.dart';

part 'note_model.g.dart';

@HiveType(typeId: 1)
class Notes extends Equatable {
  @HiveField(0)
  final String title;

  @HiveField(1)
  final String description;

  @HiveField(2)
  final String date;

  @HiveField(3)
  final bool isBookMarked;

  const Notes(
      {this.isBookMarked = false,
      required this.title,
      required this.description,
      required this.date});

  @override
  List<Object?> get props => [title, date, description, isBookMarked];

  Notes copyWith({
    String? title,
    String? date,
    String? description,
    bool? isBookMarked,
  }) {
    return Notes(
      title: title ?? this.title,
      date: date ?? this.date,
      description: description ?? this.description,
      isBookMarked: isBookMarked ?? this.isBookMarked,
    );
  }
}
