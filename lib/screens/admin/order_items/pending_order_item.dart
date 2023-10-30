import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../constants.dart';

class PendingOrderItem extends ConsumerWidget {
  PendingOrderItem(this.order, {super.key});
  final Map order;
  final firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String userName = order['user']['name'];
    String userProfileUrl = order['user']['profileUrl'];
    Map orderInfo = order['order'];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20.0),
      margin: const EdgeInsets.all(15.0),
      decoration: ShapeDecoration(
        color: const Color(0xFFFAF3F0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        shadows: const [
          BoxShadow(
            color: Color(0x3F000000),
            blurRadius: 6.0,
            offset: Offset(1.5, 4.0),
          )
        ],
      ),
      child: Column(
        children: [
          Row(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: ShapeDecoration(
                  image: DecorationImage(
                    image: NetworkImage(userProfileUrl),
                    fit: BoxFit.cover,
                  ),
                  shape: const OvalBorder(),
                ),
              ),
              const SizedBox(width: 20.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    userName,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 24,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Opacity(
                    opacity: 0.5,
                    child: Text(
                      'Order #${orderInfo['id']}',
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(
            height: 10.0,
          ),
          Column(
              children: List.generate(
            orderInfo['order'].length,
            (index) {
              final orderListItem = orderInfo['order'][index];
              final foodName = orderListItem['food'];
              final foodQuantity = orderListItem['quantity'];
              final foodPrice = orderListItem['price'];
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('$foodName x$foodQuantity',
                      style: const TextStyle(fontSize: 24)),
                  Text(
                    'N${(foodPrice * foodQuantity).toStringAsFixed(0)}',
                    style: const TextStyle(fontSize: 24),
                  )
                ],
              );
            },
          )),
          const SizedBox(
            height: 20.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                'N${orderInfo['total']}',
                style: const TextStyle(
                  color: Color(0xFF19C32A),
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
                onPressed: () async {
                  await firestore
                      .collection('orders')
                      .doc(orderInfo['id'].toString())
                      .update({'status': 'delivering'});
                },
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 17.0),
                  child: Text(
                    'Done',
                    style: TextStyle(color: Colors.white, fontSize: 24.0),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
