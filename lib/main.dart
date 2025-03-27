import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:path/path.dart' as path;

import 'classes.dart';

import 'widgets/buttons.dart';
import 'widgets/dialogs.dart';
import 'widgets/previews.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Notes organizer",
      theme: ThemeData.dark(useMaterial3: true).copyWith(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
        textTheme: ThemeData.dark().textTheme.apply(
              fontFamily: 'Comfortaa',
            ),
      ),
      debugShowCheckedModeBanner: false,
      home: const MainHomePage(),
    );
  }
}

class MainHomePage extends StatefulWidget {
  const MainHomePage({super.key});

  @override
  State<MainHomePage> createState() => _MainHomePageState();
}

class _MainHomePageState extends State<MainHomePage> {
  final List<Note> _notes = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notes Organizer"),
      ),
      body: _notes.isEmpty
          ? const Center(child: Text("No Notes yet..."))
          : ListView.builder(
              itemCount: _notes.length,
              itemBuilder: (context, index) {
                return NotePreview(
                  note: _notes[index],
                  onEdit: () {
                    _showEditNoteDialog(context, index);
                  },
                  onDelete: () {
                    setState(() {
                      _notes.removeAt(index);
                    });
                  },
                );
              },
            ),
      floatingActionButton: kIsWeb
          ? AddNoteButton(
              onPressed: () => _showAddNoteDialog(context),
            )
          : Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AddNoteButton(
                    onPressed: () => _showAddNoteDialog(context),
                  ),
                  ImportFilesButton(
                    onPressed: _importTXTFiles,
                  ),
                ],
              ),
            ),
      floatingActionButtonLocation: kIsWeb
          ? FloatingActionButtonLocation.startFloat
          : FloatingActionButtonLocation.centerFloat,
    );
  }

  Future<void> _importTXTFiles() async {
    if (kIsWeb) return;

    String? selectedDirectory = await FilePicker.platform.getDirectoryPath();

    if (selectedDirectory != null) {
      List<Note> importedNotes = [];

      for (var file
          in Directory(selectedDirectory).listSync(recursive: false)) {
        if (file is File && path.extension(file.path) == '.txt') {
          importedNotes.add(Note(
              title: path.basenameWithoutExtension(file.path),
              text: await file.readAsString()));
        }
      }

      setState(() {
        _notes.addAll(importedNotes);
      });
    }
  }

  Future<void> _showAddNoteDialog(BuildContext context) async {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AddNoteDialog(
          onNoteAdded: (title) {
            setState(() {
              _notes.add(Note(title: title));
            });
          },
        );
      },
    );
  }

  Future<void> _showEditNoteDialog(BuildContext context, int index) async {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return EditNoteDialog(
          initialTitle: _notes[index].title,
          initialText: _notes[index].text,
          onSave: (newTitle, newText) {
            setState(() {
              _notes[index] = Note(title: newTitle, text: newText);
            });
          },
        );
      },
    );
  }
}
