import 'package:flutter/material.dart';
import 'widgets/dialogs.dart';

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

class Note {
  String title;
  String text;

  Note({required this.title, this.text = ""});
}

class NotePreview extends StatelessWidget {
  final Note note;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const NotePreview({
    super.key,
    required this.note,
    required this.onEdit,
    required this.onDelete,
  });

  void _showMenu(BuildContext context, Offset position) {
    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(
          position.dx, position.dy, position.dx, position.dy),
      items: [
        PopupMenuItem(
          value: 'edit',
          onTap: onEdit,
          child: const Text('Edit'),
        ),
        PopupMenuItem(
          value: 'delete',
          onTap: onDelete,
          child: const Text('Delete'),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onEdit,
      onLongPressStart: (details) {
        _showMenu(context, details.globalPosition);
      },
      onSecondaryTapUp: (details) {
        _showMenu(context, details.globalPosition);
      },
      child: Card(
        margin: const EdgeInsets.all(4.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      note.title,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.more_vert),
                    onPressed: () {
                      _showMenu(context, const Offset(0, 0));
                    },
                  ),
                ],
              ),
              if (note.text.isNotEmpty) ...[
                const SizedBox(height: 8.0),
                Text(
                  note.text,
                  style: const TextStyle(fontSize: 14.0),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
