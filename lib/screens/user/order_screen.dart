import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:order/data/providers.dart';
import 'package:order/screens/user/app_drawer.dart';

import '../../constants.dart';
import 'cart_screen.dart';

class OrderScreen extends ConsumerWidget {
  const OrderScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
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
        child: Column(
          children: [
            Container(
              margin:
                  const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
              width: double.infinity,
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
              decoration: ShapeDecoration(
                color: kBackgroundColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                shadows: const [
                  BoxShadow(
                    color: Color(0x3F000000),
                    blurRadius: 6.0,
                    offset: Offset(1.0, 3.0),
                  )
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Order #54',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 28,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            'Ademola Adeyinka',
                            style: TextStyle(
                              color: Colors.black.withOpacity(0.6),
                              fontSize: 24,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        width: 70,
                        height: 70,
                        decoration: const ShapeDecoration(
                          color: Color(0xFF19C32A),
                          shape: OvalBorder(),
                        ),
                        child: const Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 60,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '19/09/23',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 28,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Text(
                        'N1100',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 28,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  TextButton(
                    style: const ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(kPrimaryColor),
                      shape: MaterialStatePropertyAll(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15.0)),
                        ),
                      ),
                    ),
                    onPressed: () {},
                    child: const Text(
                      'Re-Order',
                      style: TextStyle(color: Colors.white, fontSize: 29.0),
                    ),
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                'P.S. This screen is not really functioning yet. May add '
                'functionality later on. But this screen is essentially made to '
                'check up on past orders and so on. ',
                style: TextStyle(fontSize: 16.0, color: kPrimaryColor),
              ),
            )
          ],
        ),
      ),
    );
  }
}
