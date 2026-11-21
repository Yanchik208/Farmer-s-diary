
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../models/farm_note1.dart';

class JournalController extends GetxController{
  // Реактивний список всіх записів
  var notes = <FarmNote>[].obs;

  var selectedNoteIndex = 0.obs;
  var selectedSeasonFilter = 'All'.obs;

  // Інструмент для захоплення фото з камери або вибору з диска
  final ImagePicker _picker = ImagePicker();

  @override
  void onInit(){
    super.onInit();
    print('[LOG] 🟢 JournalController ініціалізовано. Завантаження початкових даних...');
    notes.add(
      FarmNote(
        id: '1', 
        title: 'First time at the farm!', 
        cropName: 'Parsnip', 
        season: 'Spring', 
        growthDays: 4, 
        description: 'Planted the first 15 parsnip seeds by the pond. I watered them with a watering can and now waiting for the fist harvest', 
        createdAt: DateTime.now(),
      ),
    );
    print('[LOG] 📄 Початковий запис успішно додано. Всього нотаток: ${notes.length}');
  }

  Future<Uint8List?> pickImage(ImageSource source) async {
    final String sourceType = source == ImageSource.camera? 'camera' : 'gallery/storage';
    try{
      print('[LOG] 📷 Спроба відкрити джерело зображення ($sourceType)...');

    // Чекає поки користувач зробить фото або обере файл
    final XFile? pickedFile = await _picker.pickImage(source: source);

    if (pickedFile != null){
      final bytes = await pickedFile.readAsBytes();
      print('[LOG] ✅ Зображення успішно отримано з $sourceType. Розмір байтів: ${bytes.lengthInBytes}');
      return bytes;
    } else {
      // Якщо користувач просто натиснув назад/ скасував вибір
      print('[LOG] ⚠️ Вибір зображення з $sourceType було скасовано користувачем.');
      return null;
      }
    } catch (e, stackTrace){
      print('[LOG] ❌ ПОМИЛКА під час вибору зображення з $sourceType: $e');
      print('[LOG] 🔍 StackTrace помилки: $stackTrace');
    
      Get.snackbar('Помилка камери/файлу', 'Не вдалося завантажити фото: $e');
      return null;
    }
  }

  /// Додавання нового запису
  void addNote(FarmNote note) {
    notes.insert(0,note);
    selectedNoteIndex.value = 0;
    print('[LOG] ➕ Додано новий запис: "${note.title}"');
  }

  /// Редагування запису
  void updateNote(String id, FarmNote updatedNote){
    int index = notes.indexWhere((n) => n.id == id);
    if (index != -1){
      notes[index] = updatedNote;
      notes.refresh();
      print('[LOG] ✏️ Оновлено запис із ID: $id');
    } else {
      print('[LOG] ❌ ПОМИЛКА: Не вдалося знайти запис із ID $id для оновлення.');
    }
  }

  void deleteNote (String id){
    notes.removeWhere((n) => n.id == id);

    // Корегує індекс вибраної нотатки
    if (selectedNoteIndex.value >= notes.length && notes.isNotEmpty ){
      selectedNoteIndex.value = notes.length - 1;
    }
    print('[LOG] 🗑️ Видалено запис з ID: $id. Залишилось у списку: ${notes.length}');
  }
}


