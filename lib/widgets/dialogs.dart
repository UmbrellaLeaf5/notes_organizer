import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
    return KeyboardListener(
      autofocus: true,
      focusNode: FocusNode(),
      onKeyEvent: (KeyEvent event) {
        if (event is KeyDownEvent &&
            event.logicalKey == LogicalKeyboardKey.enter &&
            (HardwareKeyboard.instance.isMetaPressed ||
                HardwareKeyboard.instance.isControlPressed)) {
          _saveNote();
        }
      },
      child: AlertDialog(
        title: const Text("Edit Note"),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: "Enter your Note's title here",
                ),
                onChanged: (value) => _editedTitle = value,
                // используем TextEditingController,
                // так как нужно изменять предыдущее значение
                controller: TextEditingController()..text = _editedTitle,
              ),
              const SizedBox(height: 16),
              TextField(
                decoration: const InputDecoration(
                  hintText: "Enter your Note's text here",
                ),
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
            onPressed: () => Navigator.of(context).pop(),
          ),
          TextButton(
            onPressed: _saveNote,
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }
}
