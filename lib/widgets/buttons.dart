import 'package:flutter/material.dart';

class AddNoteButton extends StatelessWidget {
  final VoidCallback onPressed;

  const AddNoteButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onPressed,
      tooltip: "Add Note",
      backgroundColor: Colors.grey[800],
      child: const Icon(Icons.add),
    );
  }
}

class ImportFilesButton extends StatelessWidget {
  final VoidCallback onPressed;

  const ImportFilesButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onPressed,
      tooltip: "Import TXT files",
      backgroundColor: Colors.grey[800],
      child: const Icon(Icons.folder),
    );
  }
}
