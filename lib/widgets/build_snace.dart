import 'package:flutter/material.dart';

class SnakeBody extends StatelessWidget {
  const SnakeBody({
    super.key,
    required this.snake,
    required this.squareSize,
  });

  final List<Offset> snake;
  final int squareSize;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: snake
          .map((position) => Positioned(
                left: position.dx * squareSize,
                top: position.dy * squareSize,
                child: Container(
                  width: squareSize.toDouble(),
                  height: squareSize.toDouble(),
                  color: Colors.green,
                ),
              ))
          .toList(),
    );
  }
}