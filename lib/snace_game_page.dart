import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:snace_game/widgets/build_food.dart';
import 'package:snace_game/widgets/build_snace.dart';

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  GamePageState createState() => GamePageState();
}

class GamePageState extends State<GamePage> {
  final int _rows = 20;
  final int _columns = 20;
  final int _squareSize = 20;
  List<Offset> _snake = [];
  Offset _food = const Offset(0, 0);
  var _direction = Direction.right;
  Timer? _timer;
  final int _speed = 200; // milliseconds
  final bool _isPaused = false;
  int _score = 0; // Yig'ilgan balllar

  @override
  void initState() {
    super.initState();
    _startGame();
  }

  void _startGame() {
    _snake = [const Offset(10, 10)];
    _generateFood();
    _direction = Direction.right;
    _score = 0; // O'yin boshida balllar 0 qilinadi
    _timer = Timer.periodic(Duration(milliseconds: _speed), (Timer timer) {
      if (!_isPaused) {
        setState(() {
          _moveSnake();
        });
      }
    });
  }

  void _generateFood() {
    final random = Random();
    _food = Offset(
      random.nextInt(_columns).toDouble(),
      random.nextInt(_rows).toDouble(),
    );
  }

  void _moveSnake() {
    var newHead = _snake.first;

    switch (_direction) {
      case Direction.up:
        newHead = newHead.translate(0, -1);
        break;
      case Direction.down:
        newHead = newHead.translate(0, 1);
        break;
      case Direction.left:
        newHead = newHead.translate(-1, 0);
        break;
      case Direction.right:
        newHead = newHead.translate(1, 0);
        break;
    }

    if (_snake.contains(newHead) ||
        newHead.dx < 0 ||
        newHead.dx >= _columns ||
        newHead.dy < 0 ||
        newHead.dy >= _rows) {
      _timer?.cancel();
      // O'yin tugadi
    } else {
      setState(() {
        _snake.insert(0, newHead);
        if (newHead == _food) {
          _score++; // Yemayni yeydik, ball oshiriladi
          _generateFood();
        } else {
          _snake.removeLast();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Snake Game - Score: $_score'),
      ),
      body: GestureDetector(
        onVerticalDragUpdate: (details) {
          if (_direction != Direction.up && _direction != Direction.down) {
            if (details.delta.dy > 0) {
              _direction = Direction.down;
            } else if (details.delta.dy < 0) {
              _direction = Direction.up;
            }
          }
        },
        onHorizontalDragUpdate: (details) {
          if (_direction != Direction.left && _direction != Direction.right) {
            if (details.delta.dx > 0) {
              _direction = Direction.right;
            } else if (details.delta.dx < 0) {
              _direction = Direction.left;
            }
          }
        },
        child: Container(
          color: Colors.black,
          child: Stack(
            children: [
              SnakeBody(snake: _snake, squareSize: _squareSize),
              FoodPosition(food: _food, squareSize: _squareSize),
            ],
          ),
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: _restartGame,
            child: const Icon(Icons.refresh),
          ),
          const SizedBox(width: 16),
          FloatingActionButton(
            onPressed: _generateFood,
            child: const Icon(Icons.play_arrow),
          ),
        ],
      ),
    );
  }

  void _restartGame() {
    setState(() {
      _snake.clear();
      _startGame();
    });
  }

  @override
  void didUpdateWidget(GamePage oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Ilon qirqilganda o'yin to'xtashi
    if (_snake.length > 1 &&
        _snake.getRange(1, _snake.length).contains(_snake.first)) {
      _timer?.cancel();
      // O'yin tugadi
    }
  }
}

enum Direction { up, down, left, right }
