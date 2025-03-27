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

class AddNoteDialog extends StatefulWidget {
  final Function(String) onNoteAdded;

  const AddNoteDialog({super.key, required this.onNoteAdded});

  @override
  AddNoteDialogState createState() => AddNoteDialogState();
}

class AddNoteDialogState extends State<AddNoteDialog> {
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

class EditNoteDialog extends StatefulWidget {
  final String initialTitle;
  final String initialText;
  final Function(String, String) onSave;

  const EditNoteDialog({
    super.key,
    required this.initialTitle,
    required this.initialText,
    required this.onSave,
  });

  @override
  EditNoteDialogState createState() => EditNoteDialogState();
}

class EditNoteDialogState extends State<EditNoteDialog> {
  late String _editedTitle;
  late String _editedText;

  @override
  void initState() {
    super.initState();
    _editedTitle = widget.initialTitle;
    _editedText = widget.initialText;
  }

  void _saveNote() {
    widget.onSave(_editedTitle, _editedText);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
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
              onChanged: (value) => _editedTitle = value,
              // используем TextEditingController,
              // так как нужно изменять предыдущее значение
              controller: TextEditingController()..text = _editedTitle,
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: const InputDecoration(
                  hintText: "Enter your Note's text here"),
              maxLines: 7,
              onChanged: (value) => _editedText = value,
              controller: TextEditingController()..text = _editedText,
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
          onPressed: _saveNote,
          child: const Text("Save"),
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
