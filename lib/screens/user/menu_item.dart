import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../constants.dart';
import '../../data/providers.dart';
import '../../models/food.dart';

class MenuItem extends ConsumerStatefulWidget {
  const MenuItem({
    super.key,
    required this.food,
  });
  final Food food;

  @override
  ConsumerState<MenuItem> createState() => _MenuItemState();
}

class _MenuItemState extends ConsumerState<MenuItem> {
  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserProvider);
    bool isCart = user.getQuantity(widget.food) != 0;
    return Container(
      margin: const EdgeInsets.all(8.0),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(widget.food.imageUrl),
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.circular(15.0),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.0),
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
            ),
          ),
          Positioned(
            bottom: 70.0,
            child: Text(
              widget.food.name,
              style: kFoodTextStyle,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Visibility(
            visible: !isCart,
            child: Positioned(
              bottom: 12.0,
              left: 15.0,
              child: Text(
                'N${widget.food.price.toStringAsFixed(0)}',
                style: kPriceTextStyle,
              ),
            ),
          ),
          Visibility(
            visible: isCart,
            child: Positioned(
              bottom: 10.0,
              left: 10.0,
              child: Container(
                decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(30.0)),
                child: IconButton(
                  onPressed: () {
                    setState(() {
                      user.reduceQuantity(widget.food);
                      if (user.getQuantity(widget.food) <= 0) {
                        isCart = false;
                      }
                    });
                  },
                  icon: const Icon(
                    Icons.remove,
                    size: 30.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          Visibility(
            visible: isCart,
            child: Positioned(
                bottom: 18.0,
                child: Text(
                  user.getQuantity(widget.food).toString(),
                  style: kPriceTextStyle,
                )),
          ),
          Positioned(
            bottom: 10.0,
            right: 10.0,
            child: Container(
              decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(30.0)),
              child: IconButton(
                onPressed: () {
                  user.addOrder(widget.food);
                },
                icon: const Icon(
                  Icons.add,
                  size: 30.0,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
