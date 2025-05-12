import 'package:hive/hive.dart';
import 'package:memoza/data/models/note/note_model.dart';

class NotesRepository {
  final Box<Notes> box;

  NotesRepository({required this.box});

  static openBox(String boxName) async {
    Box<Notes> box = await Hive.openBox(boxName);
    return box;
  }

  List<Notes> getNotes() {
    return box.values.toList().cast<Notes>();
  }

  Future<void> createNotes(Notes notes) async {
    await box.add(notes);
  }

  Future<void> updateNotes(int index, Notes notes) async {
    await box.putAt(index, notes);
  }

  Future<void> deleteNote(int index) async {
    try {
      await box.deleteAt(index);
    } catch (e) {
      throw Exception(e);
    }
  }

  void deleteAllNotes() {
    try {
      box.deleteAll(box.keys);
    } catch (e) {
      throw Exception(e);
    }
  }
}
