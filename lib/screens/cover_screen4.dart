
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'main_journal_screen.dart';

class CoverScreen extends StatelessWidget{
  const CoverScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 24, 42, 76),
      body: Center(
        child: GestureDetector(
          onTap: () {
            print('📖 [UI_LOGGER] Користувач відкрив блокнот з обкладинки');
            Get.to(
              () => const JournalScreen(),
              transition: Transition.rightToLeftWithFade,
              duration: const Duration(milliseconds: 500),
            );
          },
          child: MouseRegion(
            cursor: SystemMouseCursors.click, // Зміна курсора на руку при наведенні
            child: Container(
              width: 340,
              height: 480,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                color: const Color.fromARGB(255, 119, 130, 195),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black,
                    blurRadius: 20
                  ),
                ],
                border: Border.all(color: const Color.fromARGB(255, 13, 15, 64), width: 0.8),
              ),
              child: Stack(
                children: [

                  const Align(
                    alignment: Alignment(0.14, -0.60),
                    child: ClipOval(
                      child: SizedBox(
                        width: 220,
                        height: 220,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: Color(0xFFD0E1F9), // Фоновий колір навколо кола
                            shape: BoxShape.circle,
                          ),
                          child: Image(
                            image: AssetImage('assets/theme/farm_cover.jpg'),
                            fit: BoxFit.cover, // Заповнює круг
                          ),
                        ),
                      ),
                    ),
                  ),

                  //Корінець зліва
                  Positioned(
                    left: 0,
                    top: 0,
                    bottom: 0,
                    child: Container(
                      width: 24,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 24, 27, 91),
                        border: const Border(
                          right: BorderSide(color: Color.fromARGB(255, 208, 211, 255), width: 2),
                        ),
                      ),
                    ),
                  ),

                  //Назва блокнтоа
                  Align(
                    alignment: Alignment(0.14, 0.98),
                    child: Container(
                      margin: const EdgeInsets.all(24),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      decoration: BoxDecoration(
                        color: Color(0xFFD0E1F9),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color.fromARGB(255, 106, 108, 189), width: 2),
                      ),
                      child: const Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Farmers Diary',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 36, 43, 102),
                              letterSpacing: 1.2,
                            ),
                          ),
                          SizedBox(height: 4)
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
