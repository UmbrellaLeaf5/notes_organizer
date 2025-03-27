import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Диалоговое окно для добавления новой заметки
///
/// ### Особенности:
/// - Содержит текстовое поле для ввода заголовка
/// - Автоматически фокусируется на поле ввода при открытии
/// - Валидация: нельзя добавить заметку с пустым заголовком
/// - Поддерживает отправку по Enter
///
/// ### Пример использования:
/// ```dart
/// AddNoteDialog(
///   onNoteAdded: (title) => _addNewNote(title),
/// )
/// ```
class AddNoteDialog extends StatefulWidget {
  /// Callback-функция, вызываемая при добавлении заметки
  ///
  /// Принимает заголовок новой заметки
  final Function(String) onNoteAdded;

  /// Создает диалог добавления заметки
  ///
  /// [onNoteAdded] - обязательный параметр, обработчик добавления заметки
  const AddNoteDialog({super.key, required this.onNoteAdded});

  @override
  AddNoteDialogState createState() => AddNoteDialogState();
}

/// Состояние диалога добавления заметки
class AddNoteDialogState extends State<AddNoteDialog> {
  /// Текущее значение заголовка заметки
  String newNoteTitle = "";

  /// Обрабатывает добавление заметки
  ///
  /// ### Логика работы:
  /// 1. Проверяет, что заголовок не пустой
  /// 2. Вызывает [widget.onNoteAdded] с заголовком
  /// 3. Закрывает диалоговое окно
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

/// Диалоговое окно редактирования заметки
///
/// ### Особенности:
/// - Поля для редактирования заголовка и текста заметки
/// - Поддерживает горячие клавиши (Ctrl/Cmd + Enter для сохранения)
/// - Многострочное текстовое поле для содержимого заметки
/// - Автоматически заполняет текущие значения заметки
///
/// ### Пример использования:
/// ```dart
/// EditNoteDialog(
///   initialTitle: note.title,
///   initialText: note.text,
///   onSave: (newTitle, newText) => _updateNote(newTitle, newText),
/// )
/// ```
class EditNoteDialog extends StatefulWidget {
  /// Начальное значение заголовка заметки
  final String initialTitle;

  /// Начальное значение текста заметки
  final String initialText;

  /// Callback-функция сохранения изменений
  ///
  /// Принимает новый заголовок и текст заметки
  final Function(String, String) onSave;

  /// Создает диалог редактирования заметки
  ///
  /// [initialTitle] - текущий заголовок заметки
  /// [initialText] - текущий текст заметки
  /// [onSave] - обработчик сохранения изменений
  const EditNoteDialog({
    super.key,
    required this.initialTitle,
    required this.initialText,
    required this.onSave,
  });

  @override
  EditNoteDialogState createState() => EditNoteDialogState();
}

/// Состояние диалога редактирования заметки
class EditNoteDialogState extends State<EditNoteDialog> {
  /// Редактируемый заголовок заметки
  late String _editedTitle;

  /// Редактируемый текст заметки
  late String _editedText;

  @override
  void initState() {
    super.initState();
    _editedTitle = widget.initialTitle;
    _editedText = widget.initialText;
  }

  /// Сохраняет изменения заметки
  ///
  /// ### Логика работы:
  /// 1. Вызывает [widget.onSave] с новыми значениями
  /// 2. Закрывает диалоговое окно
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
