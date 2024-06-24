import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:order/data/providers.dart';

import 'food.dart';

final container = ProviderContainer();

final menu = container.read(menuProvider);

//
// container.dispose();
class LocalUser extends ChangeNotifier {
  String name, email, uid;
  final List<Food> cartOrders;
  bool toggleSwitch = false;
  bool admin, dispatcher, loggedIn;
  String profileUrl;
  final List<Food> orders;

  LocalUser({
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
    required this.orders,
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

  Future<void> addToCart(List<dynamic> orders) async {
    for (var order in orders) {
      String imgUrl = '';
      String foodName = order['food'];
      int quantity = order['quantity'];
      double price = order['price'];
      await menu.getMenuItems();
      List<Food> menuItems = menu.getMenu;

      for (var menuItem in menuItems) {
        if (menuItem.name == foodName) {
          imgUrl = menuItem.imageUrl;
          print(imgUrl);
          break;
        }
      }
      Food food = Food(
        imageUrl: imgUrl,
        name: foodName,
        quantity: quantity,
        price: price,
      );
      bool added = false;
      for (Food foodItem in cartOrders) {
        if (food.name == foodItem.name) {
          foodItem.quantity += food.quantity;
          added = true;
          break;
        }
      }
      if (!added) {
        cartOrders.add(food);
      }
      notifyListeners();
    }
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
