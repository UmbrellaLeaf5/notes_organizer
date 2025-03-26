import 'package:flutter/material.dart';

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
            seedColor: Colors.deepPurple, brightness: Brightness.dark),
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
  /// MEANS: список всех заметок (их содержаний)
  final List<String> _notes = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // IDK: возможно, потом сделаю покрасивее
      appBar: AppBar(
        title: const Text("Notes Organizer"),
      ),
      body: _notes.isEmpty
          // если заметок нет, просто выводим текст по центру об этом
          ? const Center(child: Text("No notes yet..."))
          // если они есть, отображаем с помощью ListView
          : ListView.builder(
              itemCount: _notes.length,
              itemBuilder: (context, index) {
                return Note(noteContent: _notes[index]);
              },
            ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(left: 10),
        child: FloatingActionButton(
          onPressed: () {
            _showAddNoteDialog(context);
          },
          tooltip: "Add Note",
          backgroundColor: Colors.grey[800],
          child: const Icon(Icons.add),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
    );
  }

  /// DOES: выводит на экран диалоговое окно создания новой заметки
  Future<void> _showAddNoteDialog(BuildContext context) async {
    String newNote = "";

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Add a New Note"),
          content: TextField(
            autofocus: true,
            decoration: const InputDecoration(hintText: "Enter your note here"),
            onChanged: (value) {
              newNote = value;
            },
          ),
          actions: <Widget>[
            TextButton(
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text("Add"),
              onPressed: () {
                // добавляем только, если есть какой-то текст
                if (newNote.isNotEmpty) {
                  setState(() {
                    _notes.add(newNote);
                  });
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }
}

/// MEANS: класс виджета заметки
class Note extends StatelessWidget {
  final String noteContent;

  const Note({super.key, required this.noteContent});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(4.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(noteContent),
      ),
    );
  }
}
