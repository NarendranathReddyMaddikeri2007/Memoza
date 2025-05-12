import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:memoza/data/models/note/note_model.dart';
import 'package:memoza/data/repositories/notes/notes_repository.dart';

part 'notes_event.dart';
part 'notes_state.dart';

class NotesBloc extends Bloc<NotesEvent, NotesState> {
  final NotesRepository notesRepository;

  NotesBloc({required this.notesRepository}) : super(NotesLoadingState()) {
    on<LoadNotesEvent>(_onLoadNotes);
    on<AddNotesEvent>(_onAddNotes);
    on<UpdateNotesEvent>(_onUpdateNotes);
    on<DeleteNotesEvent>(_onDelteNotes);
    on<DeleteAllNotesevent>(_deleteAllNotes);
  }

  FutureOr<void> _onLoadNotes(LoadNotesEvent event, Emitter<NotesState> emit) {
    emit(NotesLoadingState());
    try {
      List<Notes> notes = notesRepository.getNotes();
      emit(NotesLoadedState(note: notes));
    } catch (e) {
      emit(NotesErrorState(errorMessage: e.toString()));
    }
  }

  Future<void> _onAddNotes(
      AddNotesEvent event, Emitter<NotesState> emit) async {
    emit(NotesLoadingState());
    try {
      await notesRepository.createNote(event.notes);
      List<Notes> notes = notesRepository.getNotes();
      emit(NotesLoadedState(note: notes));
    } catch (e) {
      emit(NotesErrorState(errorMessage: e.toString()));
    }
  }

  Future<void> _onUpdateNotes(
      UpdateNotesEvent event, Emitter<NotesState> emit) async {
    try {
      await notesRepository.updateNotes(event.index, event.notes);
      List<Notes> notes = notesRepository.getNotes();
      emit(NotesLoadedState(note: notes));
    } catch (e) {
      emit(NotesErrorState(errorMessage: e.toString()));
    }
  }

  Future<void> _onDelteNotes(
      DeleteNotesEvent event, Emitter<NotesState> emit) async {
    emit(NotesLoadingState());
    try {
      await notesRepository.deleteNote(event.index);
      List<Notes> notes = notesRepository.getNotes();
      emit(NotesLoadedState(note: notes));
    } catch (e) {
      emit(NotesErrorState(errorMessage: e.toString()));
    }
  }

  FutureOr<void> _deleteAllNotes(
      DeleteAllNotesevent event, Emitter<NotesState> emit) {
    emit(NotesLoadingState());
    try {
      notesRepository.deleteAllNotes();
      List<Notes> notes = notesRepository.getNotes();
      emit(NotesLoadedState(note: notes));
    } catch (e) {
      emit(NotesErrorState(
          errorMessage: 'Something went wrong!\n ${e.toString()}'));
    }
  }
}
