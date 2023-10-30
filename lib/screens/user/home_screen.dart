import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:order/constants.dart';
import 'package:order/screens/user/cart_screen.dart';

import '../../data/providers.dart';
import '../../models/food.dart';
import 'app_drawer.dart';
import 'menu_item.dart';

final storage = FirebaseStorage.instance;

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final menu = ref.watch(menuProvider);
    menu.getMenu();

    return Scaffold(
        drawer: user.admin ? null : AppDrawer(),
        appBar: AppBar(
          surfaceTintColor: Colors.transparent,
          iconTheme: kAppBarIconThemeData,
          titleTextStyle: kTitleTextStyle,
          backgroundColor: kBackgroundColor,
          title: const Text('Home'),
          centerTitle: true,
          actions: [
            Stack(children: [
              IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const CartScreen()));
                },
                icon: const Icon(
                  Icons.shopping_cart,
                ),
              ),
              Visibility(
                visible: user.cartOrders.isNotEmpty,
                child: Positioned(
                  top: 5.0,
                  right: 7.0,
                  child: Container(
                    alignment: Alignment.center,
                    height: 15.0,
                    width: 15.0,
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle, color: Colors.grey),
                    child: Text(
                      user.cartOrders.length.toString(),
                      style:
                          const TextStyle(color: Colors.white, fontSize: 10.0),
                    ),
                  ),
                ),
              ),
            ])
          ],
        ),
        body: Container(
          color: kBackgroundColor,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  children: List.generate(menu.menu.length, (index) {
                    Food food = menu.menu[index];
                    return MenuItem(
                      food: food,
                    );
                  }),
                ),
              ),
            ],
          ),
        ));
  }
}
