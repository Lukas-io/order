import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../constants.dart';
import '../../data/providers.dart';
import '../../models/food.dart';
import 'add_dialog.dart';
import 'edit_menu_item.dart';

class MenuEditScreen extends ConsumerWidget {
  const MenuEditScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final menu = ref.watch(menuProvider);
    menu.getMenu();
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
          backgroundColor: kBackgroundColor,
          iconTheme: kAppBarIconThemeData,
          titleTextStyle: kTitleTextStyle,
          // backgroundColor: const Color(0xFFFAF3F0),
          surfaceTintColor: Colors.transparent,
          title: const Text('Menu'),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    DialogRoute(
                        builder: (context) => const AddDialog(),
                        context: context));
              },
              icon: const Icon(
                Icons.add,
              ),
            )
          ]),
      body: Container(
        child: Column(
          children: [
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                children: List.generate(menu.menu.length, (index) {
                  Food food = menu.menu[index];
                  return EditMenuItem(
                    food: food,
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
