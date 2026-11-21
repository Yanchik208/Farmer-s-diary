
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers.dart/journal_controller2.dart';
import '../models/farm_note1.dart';
import '../widgets/new_note6.dart';

// Головний клас екрана блокнота
class JournalScreen extends StatelessWidget {

  const JournalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final JournalController controller = Get.find();
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 109, 124, 204),
      
      // Верхня панель застосунку 
      appBar: AppBar(
        backgroundColor:  const Color.fromARGB(255, 24, 27, 91),
        // Колір тексту та іконок в AppBar
        foregroundColor: const Color.fromARGB(255, 172, 182, 255),
        title: const Text('Farmer’s Diary'),
      ),

      body: Stack(
        children: [
      
          LayoutBuilder(
            builder: (context, constraints) {
          // Перевіряє ширину екрана: якщо більше 750 пікселів — це ноутбук/ПК
              bool isDesktop = constraints.maxWidth > 750;

          // Контейнер, який імітує сторінку блокнота
            return Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 226, 234, 252),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Color.fromARGB(255, 154, 176, 244), width: 4),
              ),
              
            // Якщо це ноутбук — показує розворот книги, якщо телефон — звичайний список
              child: isDesktop
                  ? _buildDesktopSpread(controller) 
                  : _buildMobileList(controller), 
            );
        },
      ),

      Positioned(
        right: 32,  // Відступ від краю екрана
            bottom: 32, 
            child: SizedBox(
              width: 70,
              height: 70,
              
              child : FloatingActionButton(
                backgroundColor: const Color.fromARGB(255, 175, 188, 236),
                foregroundColor: const Color.fromARGB(255, 60, 69, 137),
                elevation: 0.0,
                onPressed: () {
                  print('📖 [UI_LOGGER] Натиснуто кнопку створення нового запису');
                  // Відкриває діалогове вікно редактора через GetX навігацію
                  Get.dialog(const NoteEditorDialog());
                },
        
                  // Іконка плюса всередині кнопки
                  child: const Icon(Icons.add),
                ),
            ),
          ),
        ],
      ),
    );
  }      

  //  метод для розвороту на 2 сторінки (для ноутбука)
  Widget _buildDesktopSpread(JournalController controller) {
    return Row(
      children: [
        // Ліва сторінка: список усіх нотаток
        Expanded(
          flex: 4,
          child: Container(
            //імітація корінця книги
            decoration: const BoxDecoration(
              border: Border(right: BorderSide(color: Color.fromARGB(255, 154, 176, 244), width: 2)),
            ),
            child: _buildMobileList(controller, isDesktopMode: true),
          ),
        ),
        
        // Права сторінка: детальний перегляд обраної нотатки
        Expanded(
          flex: 6,
          child: Obx(() {
            if (controller.notes.isEmpty) {
              return const Center(child: Text('Notebook is empty', style: TextStyle(fontSize: 16)));
            }
            // визначає індекс нотатки і перевіряє чи вона існує ше
              int safeIndex = controller.selectedNoteIndex.value < controller.notes.length
                  ? controller.selectedNoteIndex.value
                  : 0;
            // Відображає сторінку деталей для обраного запису
            return _buildNoteDetailPage(controller.notes[safeIndex]);
          }),
        ),
      ],
    );
  }

  // метод для побудови списку нотаток
  Widget _buildMobileList(JournalController controller, {bool isDesktopMode = false}) {
    // Obx спостерігає за змінами у списку notes і перемальовує список при додаванні/видаленні
    return Obx(() {
      // Перевірка: якщо нотаток немає, виводимо повідомлення
      if (controller.notes.isEmpty) {
        return const Center(
          child: Padding(
            padding: EdgeInsets.all(24.0),
            child: Text(
              'There are no entries yet.\nPress "+", to add note',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Color.fromARGB(255, 17, 20, 83)),
            ),
          ),
        );
      }

      // виведення списку нотаток
      return ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: controller.notes.length, 
        itemBuilder: (context, index) {
          // Отримує конкретну нотатку за її індексом
          final note = controller.notes[index];
          // Перевіряє, чи ця нотатка зараз обрана
          final isSelected = isDesktopMode && controller.selectedNoteIndex.value == index;

          // Прев'ю Нотатки з лівого списку
          return Card(
            color: Color.fromARGB(255, 201, 213, 251),
            margin: const EdgeInsets.only(bottom: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: const BorderSide(
              color: Color.fromARGB(255, 167, 182, 247), 
              width: 1.5,
            ),
            ),
            child: ListTile(
              // Іконка або стікер зліва від назви нотатки
              leading: note.sticker != null
                  ? Transform.scale(
                      scale: 1.8,
                      child: Image.asset(
                        note.sticker!,
                        width: 32,
                        height: 32,
                        fit: BoxFit.contain,
                      ),
                    )
                  : Transform.scale(
                      scale: 1.8,    // однаковий масштаб
                      child: Image.asset(
                        'assets/stickers/Default.png',
                        width: 32,
                        height: 32,
                        fit: BoxFit.contain,
                      ),
                    ),
              // Заголовок 
              title: Text(note.title, style: const TextStyle(fontWeight: FontWeight.bold)),
              // Підзаголовок 
              subtitle: Text('${note.cropName} • ${note.season}'),
              
              // Кнопки редагування та видалення справа
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Кнопка редагування
                  IconButton(
                    icon: const Icon(Icons.edit, size: 18, color: Color.fromARGB(255, 70, 70, 169)),
                    onPressed: () {
                      print('✏️ [UI_LOGGER] Редагування запису ID=${note.id}');
                      // Відкриває діалог редагування, передаючи існуючу нотатку
                      Get.dialog(NoteEditorDialog(existingNote: note));
                    },
                  ),
                  // Кнопка видалення
                  IconButton(
                    icon: const Icon(Icons.delete_outline, size: 18, color: Color.fromARGB(255, 70, 70, 169)),
                    onPressed: () => controller.deleteNote(note.id), // Виклик методу видалення
                  ),
                ],
              ),
              
              // Дія при натисканні на картку
              onTap: () {
                print('👆 [UI_LOGGER] Обрано нотатку ID=${note.id}');
                // Зберігає індекс обраної нотатки
                controller.selectedNoteIndex.value = index;
                // Якщо це телефон, відкриває спливаюче вікно з деталями
                if (!isDesktopMode) {
                  Get.dialog(
                    Dialog(
                      backgroundColor: const Color.fromARGB(255, 119, 155, 237),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: SizedBox(height: 400, child: _buildNoteDetailPage(note)),
                      ),
                    ),
                  );
                }
              },
            ),
          );
        },
      );
    });
  }

  Widget _buildNoteDetailPage(FarmNote note) {
    
    //  прокручування, якщо текст довгий
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Заголовок
          Text(note.title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 17, 33, 90))),
          const SizedBox(height: 8), // Відступ

          Text('Culture: ${note.cropName} | Season: ${note.season} | Growth: ${note.growthDays} d.',
              style: const TextStyle(color: Color.fromARGB(255, 17, 33, 90))),
          const Divider(height: 20),

          // Текстовий опис нотатки (або текст, якщо опис порожній)
          Text(note.description.isEmpty ? 'No description' : note.description, style: const TextStyle(fontSize: 15)),
          const SizedBox(height: 16),
          
          // Якщо до нотатки прикріплено фото
          if (note.photoBytes != null)
          Center(
            child: Container(
              height: 280, 
              width: 500, 
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color.fromARGB(255, 154, 176, 244), width: 2),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: Image.memory(note.photoBytes!, fit: BoxFit.cover), // Відображення фото з байтів
              ),
            ),
          )
        ],
      ),
    );
  }
}
