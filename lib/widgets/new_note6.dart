
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../controllers.dart/journal_controller2.dart';
import '../models/farm_note1.dart';
import 'sticker_picker5.dart';


class NoteEditorDialog extends StatefulWidget {
  final FarmNote? existingNote; // Якщо тут є дані — це редагування, null — створення нової
  const NoteEditorDialog({super.key, this.existingNote});

  @override
  State<NoteEditorDialog> createState() => _NoteEditorDialogState();
}

class _NoteEditorDialogState extends State<NoteEditorDialog> {
  // Зв'язує головним контролером GetX
  final JournalController controller = Get.find();
  
  // текстові контролери для полів вводу
  late TextEditingController titleController;
  late TextEditingController cropController;
  late TextEditingController daysController;
  late TextEditingController descController;
  
  String chosenSeason = 'Spring';
  String? chosenSticker;
  Uint8List? imageBytes;

  @override
  void initState() {
    super.initState();
    // Заповнює поля старими даними (якщо редагує) або залишає пустими
    titleController = TextEditingController(text: widget.existingNote?.title ?? '');
    cropController = TextEditingController(text: widget.existingNote?.cropName ?? '');
    daysController = TextEditingController(text: widget.existingNote != null ? widget.existingNote!.growthDays.toString() : '4');
    descController = TextEditingController(text: widget.existingNote?.description ?? '');
    
    chosenSeason = widget.existingNote?.season ?? 'Spring';
    chosenSticker = widget.existingNote?.sticker;
    imageBytes = widget.existingNote?.photoBytes;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color.fromARGB(255, 218, 227, 245),
      title: Text(widget.existingNote == null ? 'Add Note' : 'Edit Note'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            // Поле для назви
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Note Title'),
            ),
            const SizedBox(height: 10),

            // Вибір стікера
            StickerPicker(
              selectedSticker: chosenSticker,
              onSelect: (path) {
                setState(() {
                  chosenSticker = path;
                });
              },
            ),
            const SizedBox(height: 10),

            // Поле для назви культури
            TextField(
              controller: cropController,
              decoration: const InputDecoration(labelText: 'Crop Name'),
            ),
            const SizedBox(height: 10),

            // Вибір сезону
            DropdownButtonFormField<String>(
              value: chosenSeason,
              dropdownColor: const Color.fromARGB(255, 227, 234, 252),
              decoration: const InputDecoration(labelText: 'Season'),
              items: const [
                DropdownMenuItem(value: 'Spring', child: Text('Spring')),
                DropdownMenuItem(value: 'Summer', child: Text('Summer')),
                DropdownMenuItem(value: 'Autumn', child: Text('Autumn')),
                DropdownMenuItem(value: 'Winter', child: Text('Winter')),
              ],
              //зберігає вибір і оновлює екран
              onChanged: (String? value) {
                setState(() {
                  chosenSeason = value!;
                });
              },
            ),
            const SizedBox(height: 10),

            // Кількість днів росту
            TextField(
              controller: daysController,
              decoration: const InputDecoration(labelText: 'Growth Days'),
            ),
            const SizedBox(height: 10),

            // Опис
            TextField(
              controller: descController,
              maxLines: 3,
              decoration: const InputDecoration(labelText: 'Description / Notes'),
            ),
            const SizedBox(height: 15),

            // Кнопки для камери та галереї
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () async {
                    // Робить фото з камери
                    Uint8List? bytes = await controller.pickImage(ImageSource.camera); //чекає, поки користувач сфотографує і закриє камеру
                    if (bytes != null) {
                      setState(() {
                        imageBytes = bytes;
                      });
                    }
                  },
                  icon: const Icon(Icons.camera_alt),
                  label: const Text('Camera'),
                ),

                ElevatedButton.icon(
                  onPressed: () async {
                    // Вибирає картинку з файлів / галереї
                    Uint8List? bytes = await controller.pickImage(ImageSource.gallery);
                    if (bytes != null) {
                      setState(() {
                        imageBytes = bytes;
                      });
                    }
                  },
                  icon: const Icon(Icons.photo),
                  label: const Text('Gallery'),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Рамка для показу фотографії
            Container(
              height: 190,
              width: 330,
              decoration: BoxDecoration(
                border: Border.all(width: 0.6, color:Color.fromARGB(255, 124, 124, 131)),
                color: const Color.fromARGB(255, 212, 219, 238),
              ),
              child: imageBytes != null
                  ? Image.memory(imageBytes!, fit: BoxFit.cover)
                  : const Center(child: Text('Your photo will appear here')),
            ),
          ],
        ),
      ),
      actions: [
        // Кнопка скасування
        ElevatedButton(
          onPressed: () {
            Get.back(); // Закриває вікно
          },
          child: const Text('Cancel'),
        ),
        
        // Кнопка збереження
        ElevatedButton(
          onPressed: () {
            if (titleController.text.isEmpty) {
              Get.snackbar('Error', 'Please enter a note title!');
              return;
            }

            // Створює новий об'єкт нотатки
            FarmNote newNote = FarmNote(
              id: widget.existingNote?.id ?? DateTime.now().toString(),
              title: titleController.text,
              cropName: cropController.text.isEmpty ? 'Not specified' : cropController.text,
              season: chosenSeason,
              growthDays: int.tryParse(daysController.text) ?? 1,
              description: descController.text,
              sticker: chosenSticker,
              photoBytes: imageBytes,
              createdAt: widget.existingNote?.createdAt ?? DateTime.now(),
            );

            // Додає або оновлює через контролер
            if (widget.existingNote == null) {
              controller.addNote(newNote);
            } else {
              controller.updateNote(newNote.id, newNote);
            }

            Get.back(); // Закриває вікно після збереження
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
