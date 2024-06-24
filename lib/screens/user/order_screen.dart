import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:order/data/providers.dart';
import 'package:order/screens/user/app_drawer.dart';
import 'package:order/screens/user/user_order_item.dart';

import '../../constants.dart';
import 'cart_screen.dart';

class OrderScreen extends ConsumerWidget {
  const OrderScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final orders = ref.watch(orderProvider);
    orders.getUserOrders(user.uid);
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: const Text('Orders'),
        surfaceTintColor: Colors.transparent,
        titleTextStyle: kTitleTextStyle,
        centerTitle: true,
        backgroundColor: kBackgroundColor,
        iconTheme: kAppBarIconThemeData,
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
                    style: const TextStyle(color: Colors.white, fontSize: 10.0),
                  ),
                ),
              ),
            ),
          ])
        ],
      ),
      body: Container(
          color: kBackgroundColor,
          child: ListView.builder(
            itemBuilder: (context, index) {
              Map<dynamic, dynamic> order = orders.userOrders[index];
              return UserOrderItem(order);
            },
            itemCount: orders.userOrders.length,
          )),
    );
  }
}
