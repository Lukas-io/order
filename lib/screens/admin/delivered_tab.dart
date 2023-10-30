import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../constants.dart';
import '../../data/providers.dart';
import 'order_items/deliver_order_item.dart';

class DeliverTab extends ConsumerWidget {
  DeliverTab({super.key});
  final firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orderRef = ref.watch(orderProvider);
    orderRef.getOrders();

    return Container(
      color: kBackgroundColor,
      child: ListView.builder(
        itemBuilder: (context, index) {
          final order = orderRef.deliveredOrders[index];
          return DeliverOrderItem(order);
        },
        itemCount: orderRef.deliveredOrders.length,
      ),
    );
  }
}
