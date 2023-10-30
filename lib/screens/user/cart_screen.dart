import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:order/constants.dart';
import 'package:order/data/providers.dart';

import '../../models/food.dart';
import '../dialogs/confirm_dialog.dart';

class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        title: const Text('Cart'),
        titleTextStyle: kTitleTextStyle,
        centerTitle: true,
        shadowColor: Colors.white,
        backgroundColor: kBackgroundColor,
        iconTheme: kAppBarIconThemeData,
      ),
      body: ListView.builder(
        itemBuilder: (context, index) {
          if (user.cartOrders.length == index) {
            if (user.cartOrders.isNotEmpty) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Divider(
                      thickness: 1.0,
                      color: Colors.black54,
                    ),
                    const SizedBox(height: 20.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Total Amount:',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 29,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          "N${user.getTotalAmount.toStringAsFixed(0)}",
                          style: const TextStyle(
                            color: Color(0xFF19C32A),
                            fontSize: 29,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 100,
                    )
                  ],
                ),
              );
            } else {
              return Padding(
                padding: const EdgeInsets.only(top: 30.0),
                child: Center(
                  child: Opacity(
                    opacity: 0.5,
                    child: Text(
                      'No order yet',
                      style: kHeadingTextStyle,
                    ),
                  ),
                ),
              );
            }
          } else {
            return CartItem(index: index);
          }
        },
        itemCount: user.cartOrders.length + 1,
      ),
      bottomSheet: GestureDetector(
        onTap: () {
          if (user.cartOrders.isNotEmpty) {
            Navigator.push(
                context,
                DialogRoute(
                    context: context,
                    builder: (context) => const ConfirmDialog()));
          }
        },
        child: Opacity(
          opacity: user.cartOrders.isNotEmpty ? 1.0 : 0.5,
          child: Container(
            width: double.infinity,
            margin: const EdgeInsets.all(20.0),
            height: 86,
            decoration: ShapeDecoration(
              color: kPrimaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: Center(
              child: Text(
                'CHECKOUT',
                style: kBottomSheetTextStyle,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CartItem extends ConsumerStatefulWidget {
  const CartItem({super.key, required this.index});
  final int index;
  @override
  ConsumerState<CartItem> createState() => _CartItemState();
}

class _CartItemState extends ConsumerState<CartItem> {
  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserProvider);
    Food food = user.cartOrders[widget.index];

    return Container(
      margin: const EdgeInsets.all(10.0),
      width: double.infinity,
      height: 130,
      decoration: ShapeDecoration(
        color: const Color(0xFFFAF3F0),
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
      child: Row(
        children: [
          Container(
            width: 118,
            height: 130,
            clipBehavior: Clip.antiAlias,
            decoration: ShapeDecoration(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(food.imageUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Container(
                  decoration: ShapeDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment(0.00, -1.00),
                      end: Alignment(0, 1),
                      colors: [
                        Color(0x7F717171),
                        Color(0x91717171),
                        Color(0x9E717171),
                        Color(0xAF717171),
                        Color(0xBA717171),
                        Color(0xCC717171),
                        Color(0xFF717171)
                      ],
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Text(food.name,
                              overflow: TextOverflow.ellipsis,
                              style: kCartOrderTextStyle),
                        ),
                        Text(
                          'N${food.price.toStringAsFixed(0)}',
                          style: kCartPriceTextStyle,
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: const ShapeDecoration(
                          color: Color(0xFFDE550D),
                          shape: OvalBorder(),
                          shadows: [
                            BoxShadow(
                              color: Color(0x3F000000),
                              blurRadius: 4,
                              offset: Offset(0, 4),
                            )
                          ],
                        ),
                        child: IconButton(
                          onPressed: () {
                            user.reduceQuantity(food);
                          },
                          icon: const Icon(
                            Icons.remove,
                            size: 30.0,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Text(food.quantity.toString(), style: kHeadingTextStyle),
                      Container(
                        width: 50,
                        height: 50,
                        decoration: const ShapeDecoration(
                          color: Color(0xFFDE550D),
                          shape: OvalBorder(),
                          shadows: [
                            BoxShadow(
                              color: Color(0x3F000000),
                              blurRadius: 4,
                              offset: Offset(0, 4),
                            )
                          ],
                        ),
                        child: IconButton(
                          onPressed: () {
                            user.addOrder(food);
                          },
                          icon: const Icon(
                            Icons.add,
                            size: 30.0,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
