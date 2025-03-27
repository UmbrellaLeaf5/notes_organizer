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
  final List<String> _notesTitles = [];
  final List<String> _notesTexts = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // IDK: возможно, потом сделаю покрасивее
      appBar: AppBar(
        title: const Text("Notes Organizer"),
      ),
      body: _notesTitles.isEmpty
          // если заметок нет, просто выводим текст по центру об этом
          ? const Center(child: Text("No Notes yet..."))
          // если они есть, отображаем с помощью ListView
          : ListView.builder(
              itemCount: _notesTitles.length,
              itemBuilder: (context, index) {
                return NotePreview(noteTitle: _notesTitles[index]);
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
    String newNoteTitle = "";

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Add a new Note"),
          content: TextField(
            autofocus: true,
            decoration:
                const InputDecoration(hintText: "Enter your Note's title here"),
            onChanged: (value) {
              newNoteTitle = value;
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
                if (newNoteTitle.isNotEmpty) {
                  setState(() {
                    _notesTitles.add(newNoteTitle);
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

class NotePreview extends StatelessWidget {
  final String noteTitle;
  final String noteText;

  const NotePreview({super.key, required this.noteTitle, this.noteText = ""});

  String _getFirstLines(String text, {int amount = 3}) {
    List<String> lines = text.split('\n');
    return lines.take(amount).join('\n');
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(4.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              noteTitle,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            Text(
              _getFirstLines(noteText),
              style: const TextStyle(fontSize: 14.0),
            ),
          ],
        ),
      ),
    );
  }
}
