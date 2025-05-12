import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:memoza/core/config/app_themes.dart';
import 'package:memoza/data/models/note/note_model.dart';
import 'package:memoza/data/models/settings/settings_model.dart';
import 'package:memoza/data/repositories/notes/notes_repository.dart';
import 'package:memoza/data/repositories/settings/settings_repository.dart';
import 'package:memoza/presentation/bloc/notes_bloc/notes_bloc.dart';
import 'package:path_provider/path_provider.dart';

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
                  ..add(LoadNotesEvent()),
          )
        ],
        child: BlocBuilder(
          builder: (context, state) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              darkTheme: darkTheme,
              theme: lightTheme,
              themeMode: ThemeMode.dark,
              home: const MyHomePage(
                title: 'NARENDRANATH',
              ),
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
