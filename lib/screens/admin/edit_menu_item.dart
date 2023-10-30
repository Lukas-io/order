import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../constants.dart';
import '../../data/providers.dart';
import '../../models/food.dart';

class EditMenuItem extends ConsumerWidget {
  const EditMenuItem({
    super.key,
    required this.food,
  });
  final Food food;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final menu = ref.watch(menuProvider);
    return Container(
      margin: const EdgeInsets.all(8.0),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(food.imageUrl),
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
              food.name,
              style: kFoodTextStyle,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Positioned(
            bottom: 12.0,
            left: 15.0,
            child: Text(
              'N${food.price.toStringAsFixed(0)}',
              style: kPriceTextStyle,
            ),
          ),
          Positioned(
            bottom: 10.0,
            right: 10.0,
            child: Container(
              decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(30.0)),
              child: IconButton(
                onPressed: () async {
                  await menu.removeFood(food);
                },
                icon: const Icon(
                  Icons.delete_rounded,
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
