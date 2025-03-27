import 'package:flutter/material.dart';

/// Кнопка для добавления новой заметки
///
/// ### Особенности:
/// - Использует стандартный FloatingActionButton
/// - Отображает иконку "+" (Icons.add)
/// - Имеет серый цвет фона (Colors.grey[800])
/// - Всплывающая подсказка "Add Note"
///
/// ### Пример использования:
/// ```dart
/// AddNoteButton(
///   onPressed: () => _addNewNote(),
/// )
/// ```
class AddNoteButton extends StatelessWidget {
  /// Callback-функция, вызываемая при нажатии на кнопку
  final VoidCallback onPressed;

  /// Создает кнопку для добавления заметки
  ///
  /// [onPressed] - обязательный параметр, обработчик нажатия
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

/// Кнопка для импорта текстовых файлов
///
/// ### Особенности:
/// - Использует стандартный FloatingActionButton
/// - Отображает иконку папки (Icons.folder)
/// - Имеет серый цвет фона (Colors.grey[800])
/// - Всплывающая подсказка "Import TXT files"
/// - По умолчанию скрыта в веб-версии приложения
///
/// ### Пример использования:
/// ```dart
/// ImportFilesButton(
///   onPressed: () => _importNotesFromFiles(),
/// )
/// ```
class ImportFilesButton extends StatelessWidget {
  /// Callback-функция, вызываемая при нажатии на кнопку
  final VoidCallback onPressed;

  /// Создает кнопку для импорта файлов
  ///
  /// [onPressed] - обязательный параметр, обработчик нажатия
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
