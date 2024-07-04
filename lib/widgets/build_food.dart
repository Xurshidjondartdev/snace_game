import 'package:flutter/material.dart';

class FoodPosition extends StatelessWidget {
  const FoodPosition({
    super.key,
    required this.food,
    required this.squareSize,
  });

  final Offset food;
  final int squareSize;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: food.dx * squareSize,
      top: food.dy * squareSize,
      child: Container(
        width: squareSize.toDouble(),
        height: squareSize.toDouble(),
        color: Colors.red,
      ),
    );
  }
}
