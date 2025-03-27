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
                return GestureDetector(
                  onTap: () {
                    _showEditNoteDialog(context, index);
                  },
                  child: NotePreview(
                    note: _notes[index],
                  ),
                );
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

  Future<void> _showAddNoteDialog(BuildContext context) async {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AddNoteWidget(
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
    String editedTitle = _notes[index].title;
    String editedText = _notes[index].text;

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Edit Note"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  autofocus: true,
                  decoration: const InputDecoration(
                      hintText: "Enter your Note's title here"),
                  controller: TextEditingController(text: editedTitle),
                  onChanged: (value) {
                    editedTitle = value;
                  },
                ),
                const SizedBox(height: 16),
                TextField(
                  decoration: const InputDecoration(
                      hintText: "Enter your Note's text here"),
                  maxLines: 7,
                  controller: TextEditingController(text: editedText),
                  onChanged: (value) {
                    editedText = value;
                  },
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text("Save"),
              onPressed: () {
                setState(() {
                  _notes[index] = Note(title: editedTitle, text: editedText);
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

class AddNoteWidget extends StatefulWidget {
  final Function(String) onNoteAdded;

  const AddNoteWidget({super.key, required this.onNoteAdded});

  @override
  AddNoteWidgetState createState() => AddNoteWidgetState();
}

class AddNoteWidgetState extends State<AddNoteWidget> {
  String newNoteTitle = "";

  void _addNote() {
    if (newNoteTitle.isNotEmpty) {
      widget.onNoteAdded(newNoteTitle);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Add a new Note"),
      content: TextField(
        autofocus: true,
        decoration: const InputDecoration(
          hintText: "Enter your Note's title here",
        ),
        onChanged: (value) {
          setState(() {
            newNoteTitle = value;
          });
        },
        onSubmitted: (_) => _addNote(),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text("Cancel"),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          onPressed: _addNote,
          child: const Text("Add"),
        ),
      ],
    );
  }
}

class Note {
  String title;
  String text;

  Note({required this.title, this.text = ""});
}

class NotePreview extends StatelessWidget {
  final Note note;

  const NotePreview({super.key, required this.note});

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
              note.title,
              style: const TextStyle(fontWeight: FontWeight.bold),
              overflow: TextOverflow.ellipsis,
            ),
            if (note.text.isNotEmpty) ...[
              const SizedBox(height: 8.0),
              Text(
                note.text,
                style: const TextStyle(fontSize: 14.0),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ]
          ],
        ),
      ),
    );
  }
}
