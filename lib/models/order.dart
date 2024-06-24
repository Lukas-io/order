import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

final firestore = FirebaseFirestore.instance;

class Order extends ChangeNotifier {
  List<Map> completedOrders = [];
  List<Map> deliveredOrders = [];
  List<Map> pendingOrders = [];
  List<Map> userOrders = [];

  Order();

  Future<void> getOrders() async {
    await getPending();
    await getCompleted();
    await getDelivered();
  }

  String itemsCount(List orders) {
    String count = '';
    if (orders.isNotEmpty) {
      count = "(${orders.length})";
    }
    return count;
  }

  Future<void> getPending() async {
    List<Map> pending = [];
    await firestore.collection("orders").get().then(
      (event) async {
        for (var order in event.docs) {
          try {
            if (order.data()['status'] == 'pending') {
              final Map userInfo = await getUserInfo(order.data()['uid']);
              pending.add({'order': order.data(), 'user': userInfo});
            }
          } catch (e) {
            if (kDebugMode) {
              print('ERROR: $e');
            }
          }
        }
      },
    ).whenComplete(() => pendingOrders = pending);
    notifyListeners();
  }

  Future<void> getUserOrders(String uid) async {
    List<Map> orders = [];
    await firestore.collection("orders").get().then(
      (event) async {
        for (var order in event.docs) {
          try {
            if (order.data()['uid'] == uid) {
              orders.add(order.data());
            }
          } catch (e) {
            if (kDebugMode) {
              print('ERROR: $e');
            }
          }
        }
      },
    ).whenComplete(() => userOrders = orders);
    notifyListeners();
  }

  Future<void> getDelivered() async {
    List<Map> delivered = [];

    await firestore.collection("orders").get().then(
      (event) async {
        for (var order in event.docs) {
          try {
            if (order.data()['status'] == 'delivering') {
              delivered.add({
                'order': order.data(),
                'user': await getUserInfo(order.data()['uid'])
              });
            }
          } catch (e) {
            if (kDebugMode) {
              print('ERROR: $e');
            }
          }
        }
      },
    ).whenComplete(() => deliveredOrders = delivered);
    notifyListeners();
  }

  Future<void> getCompleted() async {
    List<Map> completed = [];

    await firestore.collection("orders").get().then(
      (event) async {
        for (var order in event.docs) {
          try {
            if (order.data()['status'] == 'completed') {
              completed.add({
                'order': order.data(),
                'user': await getUserInfo(order.data()['uid'])
              });
            }
          } catch (e) {
            if (kDebugMode) {
              print('ERROR: $e');
            }
          }
        }
      },
    ).whenComplete(() => completedOrders = completed);
    notifyListeners();
  }

  Future<Map> getUserInfo(String userUid) async {
    Map userInfo = {};
    await firestore.collection("users").get().then((event) {
      for (var userDocs in event.docs) {
        if (userDocs.data()['uid'] == userUid) {
          userInfo['name'] = userDocs.data()['name'];
          userInfo['profileUrl'] = userDocs.data()['profileUrl'];
        }
      }
    });
    return userInfo;
  }
}
