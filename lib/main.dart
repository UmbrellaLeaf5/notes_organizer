import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:path/path.dart' as path;

import 'classes.dart';

import 'widgets/buttons.dart';
import 'widgets/dialogs.dart';
import 'widgets/previews.dart';

/// Главный класс приложения "Organizer Notes"
///
/// Инициализирует MaterialApp с темной темой и настраивает:
/// - Цветовую схему на основе глубокого фиолетового
/// - Пользовательский шрифт Comfortaa
/// - Основную страницу приложения [MainHomePage]
void main() {
  runApp(const MainApp());
}

/// Корневой виджет приложения
///
/// ### Особенности:
/// - Устанавливает темную тему Material 3
/// - Настраивает цветовую схему
/// - Подключает пользовательский шрифт
class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Notes organizer",
      theme: ThemeData.dark(useMaterial3: true).copyWith(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
        textTheme: ThemeData.dark().textTheme.apply(
              fontFamily: 'Comfortaa',
            ),
      ),
      debugShowCheckedModeBanner: false,
      home: const MainHomePage(),
    );
  }
}

/// Главная страница приложения с списком заметок
///
/// ### Состояние:
/// - Содержит список заметок [_notes]
/// - Управляет диалогами добавления/редактирования
/// - Обрабатывает импорт файлов (для нативных платформ)
class MainHomePage extends StatefulWidget {
  const MainHomePage({super.key});

  @override
  State<MainHomePage> createState() => _MainHomePageState();
}

/// Состояние главной страницы приложения
///
/// ### Функционал:
/// - Отображение списка заметок или заглушки при пустом списке
/// - Управление FloatingActionButton (разные версии для web/нативных платформ)
/// - Обработка добавления/редактирования/удаления заметок
class _MainHomePageState extends State<MainHomePage> {
  /// Список заметок приложения
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
      floatingActionButton: kIsWeb
          ? AddNoteButton(
              onPressed: () => _showAddNoteDialog(context),
            )
          : Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AddNoteButton(
                    onPressed: () => _showAddNoteDialog(context),
                  ),
                  ImportFilesButton(
                    onPressed: _importTXTFiles,
                  ),
                ],
              ),
            ),
      floatingActionButtonLocation: kIsWeb
          ? FloatingActionButtonLocation.startFloat
          : FloatingActionButtonLocation.centerFloat,
    );
  }

  /// Импортирует .txt файлы из выбранной директории
  ///
  /// ### Особенности:
  /// - Работает только на нативных платформах (не web)
  /// - Каждый файл становится отдельной заметкой
  /// - Название файла (без расширения) становится заголовком заметки
  /// - Содержимое файла становится текстом заметки
  ///
  /// ### Ограничения:
  /// - Читает только файлы из корня выбранной директории (без рекурсии)
  Future<void> _importTXTFiles() async {
    if (kIsWeb) return;

    String? selectedDirectory = await FilePicker.platform.getDirectoryPath();

    if (selectedDirectory != null) {
      List<Note> importedNotes = [];

      for (var file
          in Directory(selectedDirectory).listSync(recursive: false)) {
        if (file is File && path.extension(file.path) == '.txt') {
          importedNotes.add(Note(
              title: path.basenameWithoutExtension(file.path),
              text: await file.readAsString()));
        }
      }

      setState(() {
        _notes.addAll(importedNotes);
      });
    }
  }

  /// Показывает диалог добавления новой заметки
  ///
  /// При подтверждении:
  /// - Создает новую заметку с введенным заголовком
  /// - Добавляет заметку в список [_notes]
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

  /// Показывает диалог редактирования существующей заметки
  ///
  /// [index] - позиция редактируемой заметки в списке
  ///
  /// При подтверждении:
  /// - Обновляет заголовок и текст заметки
  /// - Сохраняет изменения в списке [_notes]
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
