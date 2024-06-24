import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:order/data/providers.dart';

import '../../constants.dart';

class UserOrderItem extends ConsumerWidget {
  const UserOrderItem(this.order, {super.key});

  final Map<dynamic, dynamic> order;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userProvider = ref.watch(currentUserProvider);
    int id = order['id'];
    List<dynamic> purchasedOrder = order['order'];
    String status = order['status'];
    int amountPaid = order['total'];

    Color iconColor;
    IconData statusIcon;

    switch (status) {
      case 'completed':
        iconColor = Color(0xFF19C32A);
        statusIcon = Icons.check;
        break;
      case 'pending':
        iconColor = Color(0xF0706c65);
        statusIcon = Icons.remove;
        break;
      case 'delivering':
        iconColor = Color(0xFF8d8f71);
        statusIcon = Icons.circle_outlined;
        break;
      default:
        iconColor = Colors.cyanAccent;
        statusIcon = Icons.add;
    }
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
      decoration: ShapeDecoration(
        color: kBackgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        shadows: const [
          BoxShadow(
            color: Color(0x3F000000),
            blurRadius: 4.0,
            offset: Offset(1.0, 2.0),
          )
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Order #$id',
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 28,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Container(
                width: 50,
                height: 50,
                decoration: ShapeDecoration(
                  color: iconColor,
                  shape: OvalBorder(),
                ),
                child: Icon(
                  statusIcon,
                  color: Colors.white,
                  size: 40,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Column(
            children: List.generate(purchasedOrder.length, (index) {
              double pricePerMeal = purchasedOrder[index]['price'] *
                  purchasedOrder[index]['quantity'];

              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "${purchasedOrder[index]['food']} x${purchasedOrder[index]['quantity']}",
                    style: const TextStyle(fontSize: 16.0),
                  ),
                  Text(
                    "N${pricePerMeal.toStringAsFixed(0)}",
                    style: const TextStyle(fontSize: 16.0),
                  ),
                ],
              );
            }),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'N${amountPaid.toString()}',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 28,
                  fontWeight: FontWeight.w500,
                ),
              ),
              TextButton(
                style: const ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(kPrimaryColor),
                  shape: MaterialStatePropertyAll(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15.0)),
                    ),
                  ),
                ),
                onPressed: () {
                  userProvider.addToCart(purchasedOrder);
                },
                child: const Text(
                  'Re-Order',
                  style: TextStyle(color: Colors.white, fontSize: 29.0),
                ),
              ),
            ],
          ),
          // const SizedBox(height: 10),
        ],
      ),
    );
  }
}
