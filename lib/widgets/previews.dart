import 'package:flutter/material.dart';

import '../classes.dart';

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
    final GlobalKey iconKey = GlobalKey();

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
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18.0),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    key: iconKey,
                    icon: const Icon(Icons.more_vert),
                    onPressed: () {
                      final RenderBox renderBox = iconKey.currentContext!
                          .findRenderObject() as RenderBox;
                      final Offset position =
                          renderBox.localToGlobal(Offset.zero);
                      _showMenu(context, position);
                    },
                  ),
                ],
              ),
              if (note.text.isNotEmpty) ...[
                const SizedBox(height: 8.0),
                Text(
                  note.text,
                  style: const TextStyle(fontSize: 12.0),
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
