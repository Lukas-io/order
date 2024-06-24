// Food
import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

import 'food.dart';

class Menu extends ChangeNotifier {
  final firestore = FirebaseFirestore.instance;
  List<Food> _menu = [];

  Future<void> getMenuItems() async {
    await firestore.collection("menu").get().then(
      (event) {
        List<Food> menuItems = [];

        for (var foodItem in event.docs) {
          try {
            menuItems.add(Food(
                imageUrl: (foodItem.data()['imageUrl']),
                name: foodItem.data()['name'],
                price: foodItem.data()['price'] / 1.0));
          } catch (e) {
            if (kDebugMode) {
              print(e);
            }
          }
        }
        _menu = menuItems;
      },
    );
    notifyListeners();
  }

  get getMenu => _menu;
  Future<void> addFood(Food food) async {
    final foodDetails = {
      'name': food.name,
      'price': food.price,
      'imageUrl': food.imageUrl
    };
    await firestore.collection('menu').doc(food.name).set(foodDetails);
    notifyListeners();
  }

  Future<void> removeFood(Food food) async {
    String foodName = food.name;
    final storageRef = FirebaseStorage.instance.ref();
    Reference foodRef = storageRef.child('Food Images/$foodName');
    await firestore.collection('menu').doc(food.name).delete();
    await foodRef.delete();
    notifyListeners();
  }
}
