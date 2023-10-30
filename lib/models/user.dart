import 'package:flutter/material.dart';

import 'food.dart';

class LocalUser extends ChangeNotifier {
  String name, email, uid;
  final List<Food> cartOrders;
  bool toggleSwitch = false;
  bool admin, dispatcher, loggedIn;
  String profileUrl;

  LocalUser({
    // required this.completedOrders,
    required this.cartOrders,
    this.profileUrl = 'https://firebasestorage.googleapis.com/v0/b/order-c5bfb.'
        'appspot.com/o/default_profile.png?alt=media&token=df390ec0-1f66-4018-'
        '8e85-4d8d69f1f59f',
    this.name = '',
    this.email = '',
    this.admin = false,
    this.dispatcher = false,
    this.uid = '',
    this.loggedIn = false,
  });

  set setUserName(String name) {
    this.name = name;
    notifyListeners();
  }

  set setLoggedIn(bool login) {
    loggedIn = login;
  }

  set setProfileUrl(String url) {
    profileUrl = url;
    notifyListeners();
  }

  get getProfileImage {
    return NetworkImage(profileUrl);
  }

  set setUserEmail(String email) {
    this.email = email;
    notifyListeners();
  }

  set setAdmin(bool isAdmin) {
    admin = isAdmin;
    notifyListeners();
  }

  set setDispatcher(bool isDispatcher) {
    dispatcher = isDispatcher;
    notifyListeners();
  }

  set setUserUID(String uid) {
    this.uid = uid;
  }

  get getTotalAmount {
    double total = 0;
    for (var food in cartOrders) {
      total += food.price * food.quantity;
    }
    return total.toInt();
  }

  void addOrder(Food food) {
    bool added = false;
    for (Food foodItem in cartOrders) {
      if (food.name == foodItem.name) {
        foodItem.quantity++;
        added = true;
      }
    }
    if (!added) {
      cartOrders.add(food);
      food.quantity++;
    }
    notifyListeners();
  }

  int getQuantity(Food food) {
    int quantity = 0;
    for (Food foodItem in cartOrders) {
      if (food.name == foodItem.name) {
        quantity = foodItem.quantity;
      }
    }
    return quantity;
  }

  void reduceQuantity(Food food) {
    dynamic emptyOrder;
    for (Food foodItem in cartOrders) {
      if (food.name == foodItem.name) {
        if (foodItem.quantity > 0) {
          foodItem.quantity--;
        }
      }
      if (foodItem.quantity == 0) {
        emptyOrder = foodItem;
      }
    }

    if (emptyOrder != null) {
      cartOrders.remove(emptyOrder);
    }

    notifyListeners();
  }

  void toggle() {
    toggleSwitch = !toggleSwitch;
    notifyListeners();
  }

  void clearCart() {
    for (Food food in cartOrders) {
      food.quantity = 0;
    }
    cartOrders.clear();
    notifyListeners();
  }
}
