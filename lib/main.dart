import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:memoza/core/config/app_themes.dart';
import 'package:memoza/data/models/note/note_model.dart';
import 'package:memoza/data/models/settings/settings_model.dart';
import 'package:memoza/data/repositories/notes/notes_repository.dart';
import 'package:memoza/data/repositories/settings/settings_repository.dart';
import 'package:memoza/presentation/bloc/notes_bloc/notes_bloc.dart';
import 'package:memoza/presentation/pages/home/home.dart';
import 'package:path_provider/path_provider.dart';

import 'presentation/cubit/settings/settings_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final directory = await getApplicationDocumentsDirectory();

  await Hive.initFlutter(directory.path);

  Hive.registerAdapter(NotesAdapter());
  Hive.registerAdapter(SettingsAdapter());

  Box<Notes> notesBox = await NotesRepository.openBox('notes') as Box<Notes>;
  Box<Settings> settingsBox = await SettingsRepository.openBox('settings');

  SettingsRepository(box: settingsBox).initializeSettings();

  runApp(MyApp(notesBox: notesBox, settingsBox: settingsBox));
}

class MyApp extends StatelessWidget {
  final Box<Notes> notesBox;
  final Box<Settings> settingsBox;

  const MyApp({super.key, required this.notesBox, required this.settingsBox});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(
              create: (context) =>
                  NotesBloc(notesRepository: NotesRepository(box: notesBox))
                    ..add(LoadNotesEvent())),
          BlocProvider(
            create: (context) => SettingsCubit(
              settingsRepository: SettingsRepository(box: settingsBox),
            ),
          )
        ],
        child: BlocBuilder<SettingsCubit, Settings>(
          builder: (context, state) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: lightTheme,
              darkTheme: darkTheme,
              themeMode: state.isDarkMode ? ThemeMode.dark : ThemeMode.light,
              home: HomeScreen(),
            );
          },
        ));
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}

class Note {
  final String title;

  final String description;

  final String date;

  final bool isBookMarked;

  const Note(
      {this.isBookMarked = false,
      required this.title,
      required this.description,
      required this.date});

  @override
  List<Object?> get props => [title, date, description, isBookMarked];


   Note copyWith({
    String? title,
    String? date,
    String? description,
    bool? isBookMarked,
  }) {
    return Note(
      title: title ?? this.title,
      date: date ?? this.date,
      description: description ?? this.description,
      isBookMarked: isBookMarked ?? this.isBookMarked,
    );
  }
}



final List<Note> notes = generateNotes(100);

List<Note> generateNotes(int count) {
  final random = Random();
  final titles = ['Meeting', 'Groceries', 'Homework', 'Workout', 'Plan'];
  final descriptions = [
    'Complete the assigned task',
    'Buy vegetables and fruits',
    'Maths and Science chapters',
    'Chest and back routine',
    'Outline weekly goals'
  ];

  return List.generate(count, (index) {
    final title = '${titles[random.nextInt(titles.length)]} ${index + 1}';
    final description = descriptions[random.nextInt(descriptions.length)];
    final date =
        '${random.nextInt(28) + 1}-${random.nextInt(12) + 1}-2025'; // format: dd-mm-yyyy
    final isBookMarked = random.nextBool();

    return Note(
      title: title,
      description: description,
      date: date,
      isBookMarked: isBookMarked,
    );
  });
}
