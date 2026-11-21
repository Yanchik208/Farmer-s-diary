
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers.dart/journal_controller2.dart';


class StickerPicker extends StatelessWidget {
  final String? selectedSticker;    // Шлях до поточного обраного стікера
  final Function(String? stickerPath) onSelect;

  const StickerPicker({
    super.key,
    required this.selectedSticker,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Choose sticker to make it lovely:',
          style: TextStyle(color: Color.fromARGB(255, 5, 14, 42)),
        ),
        const SizedBox(height: 8),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal, 
          child: Row(
            children: [
              _buildStickerItem('assets/stickers/parsnip.png', 'Pasnip'),
              const SizedBox(width: 8),
              _buildStickerItem('assets/stickers/Strawberry.png', 'Strawberry'),
              const SizedBox(width: 8),
              _buildStickerItem('assets/stickers/Melon.png', 'Melon'),
              const SizedBox(width: 8),
              _buildStickerItem('assets/stickers/Pumpkin.png', 'Pumpkin'),
              const SizedBox(width: 8),
              _buildStickerItem('assets/stickers/Carrot.png', 'Carrot'),
              const SizedBox(width: 8),
              _buildStickerItem('assets/stickers/Raddish.png', 'Radish'),
              const SizedBox(width: 8),
              _buildStickerItem('assets/stickers/BokChoy.png', 'Bok Choy'),
              const SizedBox(width: 8),
              _buildStickerItem('assets/stickers/Nectarine.png', 'Nectarine'),
              const SizedBox(width: 8),
              _buildStickerItem('assets/stickers/sunflower.png', 'Sunflower'),
              const SizedBox(width: 8),
              _buildStickerItem('assets/stickers/Eggplant.png', 'Eggplant'),
              const SizedBox(width: 8),
              _buildStickerItem('assets/stickers/Mango.png', 'Mango'),
              const SizedBox(width: 8),
              _buildStickerItem('assets/stickers/Orange.png', 'Orange'),
              const SizedBox(width: 8),
              _buildStickerItem('assets/stickers/RedMushroom.png', 'Red mushroom'),
              const SizedBox(width: 8),
              _buildStickerItem('assets/stickers/Tomato.png', 'Tomato'),
          ],
          ),
        ),
      ],
    );
  }

  // Доп метод для створення картки стікера
  Widget _buildStickerItem(String path, String name) {
    final isSelected = selectedSticker == path;

    return GestureDetector(
      onTap: () {
        print('🖼️ [UI_LOGGER] Обрано стікер: $name');
        // Якщо стікер вже був вибраний — знімає вибір (null), інакше обирає шлях
        onSelect(isSelected ? null : path);
      },
      child: Container(
        width: 70,
        height: 70,
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: isSelected ? const Color.fromARGB(255, 155, 176, 253) : const Color.fromARGB(255, 179, 198, 255),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Image.asset(
          path,
          fit: BoxFit.contain, //масштабується
        ),
      ),
    );
  }
}