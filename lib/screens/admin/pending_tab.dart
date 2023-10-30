import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:order/data/providers.dart';
import 'package:order/screens/admin/order_items/pending_order_item.dart';

import '../../constants.dart';

class PendingTab extends ConsumerWidget {
  const PendingTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orderRef = ref.watch(orderProvider);
    orderRef.getOrders();

    return Container(
      color: kBackgroundColor,
      // child: Column(
      //   children: List.generate(orderRef.pendingOrders.length, (index) {
      //     var order = orderRef.pendingOrders[index];
      //     return UserOrderItem(order);
      //   }),
      //   // children: [
      //   //   MaterialButton(
      //   //     onPressed: () async {
      //   //       print(orderRef.pendingOrders);
      //   //     },
      //   //     child: Text('press me'),
      //   //   ),
      //   // ]),
      // ),

      child: ListView.builder(
        itemBuilder: (context, index) {
          final order = orderRef.pendingOrders[index];
          return PendingOrderItem(order);
        },
        itemCount: orderRef.pendingOrders.length,
      ),
    );
  }
}
