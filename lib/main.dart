import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as path;
import 'package:flutter/material.dart';

import 'classes.dart';

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
      floatingActionButton: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            FloatingActionButton(
              onPressed: () => _showAddNoteDialog(context),
              tooltip: "Add Note",
              backgroundColor: Colors.grey[800],
              child: const Icon(Icons.add),
            ),
            FloatingActionButton(
              onPressed: _importTXTFiles,
              tooltip: "Import TXT files",
              backgroundColor: Colors.grey[800],
              child: const Icon(Icons.folder),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Future<void> _importTXTFiles() async {
    String? selectedDirectory = await FilePicker.platform.getDirectoryPath();

    if (selectedDirectory != null) {
      final dir = Directory(selectedDirectory);
      List<FileSystemEntity> files = dir.listSync(recursive: false);

      List<Note> importedNotes = [];

      for (var file in files) {
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
