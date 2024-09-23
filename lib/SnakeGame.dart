// ignore_for_file: file_names

import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

class SnakeGame extends StatefulWidget {
  const SnakeGame({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SnakeGameState createState() => _SnakeGameState();
}

class _SnakeGameState extends State<SnakeGame> {
  int rows = 20;
  int columns = 20;
  int totalCells = 400;
  List<int> snakePosition = [45, 65, 85];
  int foodPosition = Random().nextInt(400);
  String direction = 'down';
  Timer? gameTimer;
  bool gameOver = false;

  @override
  void initState() {
    super.initState();
    startGame();
  }

  void startGame() {
    gameTimer =
        Timer.periodic(const Duration(milliseconds: 250), (Timer timer) {
      setState(() {
        updateSnake();
      });
    });
  }

  @override
  void dispose() {
    gameTimer?.cancel();
    super.dispose();
  }

  void updateSnake() {
    if (!gameOver) {
      switch (direction) {
        case 'down':
          if (snakePosition.last + columns >= totalCells) {
            snakePosition.add(snakePosition.last + columns - totalCells);
          } else {
            snakePosition.add(snakePosition.last + columns);
          }
          break;
        case 'up':
          if (snakePosition.last - columns < 0) {
            snakePosition.add(snakePosition.last - columns + totalCells);
          } else {
            snakePosition.add(snakePosition.last - columns);
          }
          break;
        case 'right':
          if ((snakePosition.last + 1) % columns == 0) {
            snakePosition.add(snakePosition.last + 1 - columns);
          } else {
            snakePosition.add(snakePosition.last + 1);
          }
          break;
        case 'left':
          if (snakePosition.last % columns == 0) {
            snakePosition.add(snakePosition.last - 1 + columns);
          } else {
            snakePosition.add(snakePosition.last - 1);
          }
          break;
      }

      // إذا ابتلعت الطعام
      if (snakePosition.last == foodPosition) {
        foodPosition = Random().nextInt(totalCells);
      } else {
        snakePosition.removeAt(0);
      }

      // التحقق من التصادم
      if (snakePosition.toSet().length != snakePosition.length) {
        gameOver = true;
        gameTimer?.cancel();
        showGameOverScreen();
      }
    }
  }

  void showGameOverScreen() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Game Over'),
          content: const Text('You have collided with yourself!'),
          actions: [
            ElevatedButton(
              child: const Text('Play Again'),
              onPressed: () {
                resetGame();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void resetGame() {
    setState(() {
      snakePosition = [45, 65, 85];
      direction = 'down';
      foodPosition = Random().nextInt(totalCells);
      gameOver = false;
      startGame();
    });
  }

////////////////////////////////////////////////////
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    columns = (screenWidth / 20).floor();
    rows = (screenHeight / 20).floor() - 4;
    totalCells = rows * columns;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      body: Container(
        //margin: EdgeInsets.all(10), //!
        child: Column(
          children: [
            Expanded(
              child: Container(
                margin: EdgeInsets.only(top: 20),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.white)),
                child: GestureDetector(
                  
                  child: GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: totalCells,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: columns,
                    ),
                    itemBuilder: (BuildContext context, int index) {
                      if (snakePosition.contains(index)) {
                        return Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              color: const Color.fromARGB(255, 136, 0, 255)),
                          //   color: const Color.fromARGB(255, 136, 0, 255),
                          margin: const EdgeInsets.all(1),
                        );
                      } else if (index == foodPosition) {
                        return Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              color: Colors.amber),
                          margin: const EdgeInsets.all(1),
                        );
                      } else {
                        return Container(
                          color: const Color.fromARGB(
                              20, 255, 255, 255), //لون المربعات
                          margin: const EdgeInsets.all(1),
                        );
                      }
                    },
                  ),
                ),
              ),
            ),
            // const SizedBox(
            //   height: 50,
            // ),
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: const Color.fromARGB(55, 95, 95, 95)),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_upward,
                          color: Color.fromARGB(255, 116, 3, 255)),
                      iconSize: 50,
                      onPressed: () {
                        if (direction != 'down') {
                          direction = 'up';
                        }
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back,
                              color: Color.fromARGB(255, 116, 3, 255)),
                          iconSize: 50,
                          onPressed: () {
                            if (direction != 'right') {
                              direction = 'left';
                            }
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.arrow_forward,
                              color: Color.fromARGB(255, 116, 3, 255)),
                          iconSize: 50,
                          onPressed: () {
                            if (direction != 'left') {
                              direction = 'right';
                            }
                          },
                        ),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(Icons.arrow_downward,
                          color: Color.fromARGB(255, 116, 3, 255)),
                      iconSize: 50,
                      onPressed: () {
                        if (direction != 'up') {
                          direction = 'down';
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
